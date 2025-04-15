import 'dart:convert';
import 'dart:developer';

import 'package:easy_stock_app/models/purchase_order/historyModel/history_totallistmodel.dart';
import 'package:easy_stock_app/models/purchase_order/historyModel/historymodel.dart';
import 'package:easy_stock_app/models/purchase_order/order_details_model.dart';
import 'package:easy_stock_app/services/api_services/purchase_order/purchase_order_details_byid.dart';
import 'package:easy_stock_app/services/api_services/purchase_order/request_history/getHistory.dart';
import 'package:flutter/material.dart';

class PurchaseHistoryProvider with ChangeNotifier {
  List<HistoryDatum> data = [];
  fetchData() async {
    var res = await getHistoryApi();
    if (res != 'Failed') {
      Map<String, dynamic> jsonData = json.decode(res);
      HistoryModel obj = HistoryModel.fromJson(jsonData);
      data = obj.data;
      notifyListeners();
    } else {
      data = [];
      notifyListeners();
      return;
    }
  }

  List<HistoryDetailss> details = [];
  fetchDetails({orderId, editNo}) async {
    log("order:$orderId");
    log("edit $editNo");
    var res =
        await getPurchaseorderDetailsByidApi(orderId: orderId, editNo: editNo);
    if (res != 'Failed') {
      Map<String, dynamic> jsonData = json.decode(res);
      HistoryOrderdetailsByidModel obj = HistoryOrderdetailsByidModel.fromJson(jsonData);

      print("lpo Length ${obj.data.details.length}");
      details = obj.data.details;
      notifyListeners();
    } else {
      details = [];
      notifyListeners();
      return;
    }
  }
String getItemPrice(int index, String quantity) {
  // Calculate the total for the item and format to 2 decimal points
  details[index].total =
      (double.parse(details[index].price) * double.parse(details[index].qty))
          .toStringAsFixed(2);
  return details[index].total;
}

double totalPrice = 0.00;
double totalVat = 0.00;

String getPrice() {
  if (details.isNotEmpty) {
    // Calculate total price and VAT and format to 2 decimal points
    double totalSum = details.fold(0, (sum, item) {
      return sum + (double.parse(item.price) * double.parse(item.qty));
    });
    double totalvat = details.fold(0, (vat, item) {
      return vat + (double.parse(item.vat));
    });

    // Set the total price and VAT with 2 decimal points
    totalPrice = double.parse(totalSum.toStringAsFixed(2));
    totalVat = double.parse(totalvat.toStringAsFixed(2));

    return totalPrice.toStringAsFixed(2);
  } else {
    return "0.00";
  }
}

  // String getItemPrice(index, quantity) {
  //   details[index].total =
  //       (double.parse(details[index].price) * double.parse(details[index].qty))
  //           .toString();
  //   // notifyListeners();
  //   String price = details[index].total;
  //   return price;
  // }
  //  double totalPrice = 0.00;
  // double totalVat = 0.00;
  // String getPrice() {
  //   if (details.isNotEmpty) {
  //     double totalSum = details.fold(0, (sum, item) {
  //       return sum + (double.parse(item.price) * double.parse(item.qty));
  //     });
  //     double totalvat = details.fold(0, (vat, item) {
  //       return vat + (double.parse(item.vat));
  //     });
  //     totalPrice = totalSum;
  //     totalVat = totalvat;
  //     // notifyListeners();
  //     return totalSum.toString();
  //   } else {
  //     return "0";
  //   }
  // }
}
