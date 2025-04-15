import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/models/purchase_order/productModel.dart';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> postPurchaseOrderApi(
    List<Product> PurchaseOrderList,
    double totalPrice,
    double Vat,
    String docStatus,
    String editNo,
    String orderID) async {
  var accessToken = await getToken(); // Make sure to await the Future result
  final bearerToken = "Bearer " "$accessToken";
  log("postPurchaseOrderApi $bearerToken");

  final url = Uri.parse(postPurchaseOrdeRoute);
  log(postPurchaseOrdeRoute);

  log("purchaseOrderlist ");
  List<Map<String, dynamic>> convertProductsToJson(
    List<Product> products,
  ) {
    return products.map((product) => product.toJson()).toList();
  }



  List<Map<String, dynamic>> jsonBody =
      convertProductsToJson(PurchaseOrderList);

  log("response: $jsonBody");
  var data = {
    'PurchaseOrderHeader': {
      'CustomerID': 2001,
      'CustomerName': 'John Doe',
      'TotalAmount': totalPrice,
      'TotalVat': Vat,

      // 'O'(open) --> fresh data
      // 'U'(updated) --> edited data
    },
    'PurchaseOrderLines': jsonBody,
  };

  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'Authorization': bearerToken,
    'DocStatus': 'O'
  };

  try {
    log("res: $data");
    final response =
        await http.post(url, headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      log(response.body);
      return "Success";
    } else {
      log(response.body);

      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
    return "Failed";
  }
}
