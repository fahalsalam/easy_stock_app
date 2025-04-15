// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:easy_stock_app/models/purchase/bpo_details_model.dart';
import 'package:easy_stock_app/models/purchase/bpo_model.dart';
import 'package:easy_stock_app/services/api_services/purchase_request/bpo/get_bpoDetails_api.dart';
import 'package:easy_stock_app/services/api_services/purchase_request/bpo/getbpo_api.dart';
import 'package:easy_stock_app/services/api_services/purchase_request/bpo/update_api.dart';
import 'package:easy_stock_app/services/api_services/purchase_request/bpo/updatebulkPrice_api.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:flutter/material.dart';

class BpoProvider with ChangeNotifier {
  List<BpoCategoryData> data = [];
  List<BpoDetailsDatum> details = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double totalPrice = 0.0;
  String price = "";

  Future<void> fetchData() async {
    log("Fetching BPO data...");
    _isLoading = true;
    notifyListeners();

    try {
      var res = await fetchPurchaseOrderBPO();
      if (res != 'Failed') {
        Map<String, dynamic> jsonData = json.decode(res);
        BpoListModel obj = BpoListModel.fromJson(jsonData);
        data = obj.data;
        log("Fetched ${data.length} items.");
      } else {
        log("Failed to fetch data.");
        data = [];
      }
    } catch (e) {
      log("Error fetching data: $e");
      data = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Item> products = [];

  Future<void> fetchDatabyid(id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await fetchData();

      // Use firstWhere to find the first matching category based on the id
      final categoryMatch = data.firstWhere(
        (element) => element.categoryId == id,
      );

      products = categoryMatch.items;
        } catch (e) {
      // Handle any potential exceptions here
      print("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> productDetails(String productID) async {
    log("Fetching product details for ID: $productID...");
    _isLoading = true;
    notifyListeners();

    try {
      var res = await fetchPurchaseOrderBPOByProduct(productID);
      if (res != 'Failed') {
        Map<String, dynamic> jsonData = json.decode(res);
        BpoDetailsModel obj = BpoDetailsModel.fromJson(jsonData);
        details = obj.data;
        calculateTotalPrice();
        log("Fetched ${details.length} product details.");
      } else {
        log("Failed to fetch product details.");
        details = [];
      }
    } catch (e) {
      log("Error fetching product details: $e");
      details = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void calculateTotalPrice() {
    totalPrice = details.fold(0.0, (sum, item) {
      double itemPrice = double.tryParse(item.total) ?? 0.0;
      double itemQuantity = double.tryParse(item.qty) ?? 0.0;
      return sum + (itemPrice * itemQuantity);
    });

    price = totalPrice.toStringAsFixed(2);
  }

  updateData(productId, orderId, quantity, bool isNoStock, bool iscompleted,
      context, price, editNo) {
    log("update------>>>>> complete: $iscompleted");
    log("update------>>>>> productId: $productId");
    log("update------>>>>> orderId: $orderId");
    log("update------>>>>> quantity: $quantity");
    log("update------>>>>> isNoStock: $isNoStock");
    log("update------>>>>> iscompleted: $iscompleted");
    log("update------>>>>> price: $price");
    _isLoading = true;
    notifyListeners();
    var res = updateBPOOrderStatus(
        productId: productId,
        orderId: orderId,
        quantity: quantity,
        isNoStock: isNoStock,
        isCompleted: iscompleted,
        editNo: editNo,
        price: price);
    if (res != 'Failed') {
      showSnackBar(context, "", 'Updated', Colors.white);
      productDetails(productId);
    } else {
      showSnackBar(context, "", 'Error', Colors.red);
    }
    fetchData().then((_) {
      _isLoading = false;
    });

    notifyListeners();
  }
  // bulk price updste

  updateBulkPrice({productId,price,context}) {
     log("update------>>>>> productId: $productId");
    log("update------>>>>> price: $price");
    _isLoading = true;
    notifyListeners();
    var res = updateBulkPriceApi(
        productId: productId,     
        price: price);
    if (res != 'Failed') {
      showSnackBar(context, "", 'Updated', Colors.white);
      productDetails(productId.toString());
    } else {
      showSnackBar(context, "", 'Error', Colors.red);
    }
    fetchData().then((_) {
      _isLoading = false;
    });

    notifyListeners();
  }
}
