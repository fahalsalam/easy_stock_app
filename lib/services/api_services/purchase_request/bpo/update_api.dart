// Function to send POST request to update BPO Order Status

import 'dart:developer';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/token_manager/token_manager.dart';

Future<String> updateBPOOrderStatus({
  required String productId,
  required String orderId,
  required String quantity,
  required String editNo,
  bool isNoStock = false,
  bool isCompleted = false,
  required String price,
}) async {
  TokenManager tokenObj = TokenManager();
  var accessToken = await tokenObj.getAccessToken();
  log("update BPO Order");
  final url = Uri.parse(getPurchaseUpdateRoute);
  log("uri:$url");
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'Authorization': "Bearer " "$accessToken",
    'ProductID': productId.toString(),
    'OrderID': orderId.toString(),
    'EditNo': editNo,
    'Qty': quantity.toString(),
    'Price': price.toString(),
    'IsNoStock': isNoStock.toString(),
    'IsCompleted': isCompleted.toString(),
  };
  log("-------------------->>>>....update");
  log("-------------------->>>>....update......$headers");
  final response = await http.post(
    url,
    headers: headers,
  );
  log(headers.toString());
  if (response.statusCode == 200) {
    log(response.body);
    return 'Success';
  } else {
    return 'Failed';
  }
}
