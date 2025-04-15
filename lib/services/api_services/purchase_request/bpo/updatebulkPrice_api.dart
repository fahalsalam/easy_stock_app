// Function to send POST request to update BPO Order Status

import 'dart:developer';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/token_manager/token_manager.dart';

Future<String> updateBulkPriceApi(
    {required int productId,
    required double price,
    String orderid = "",
    String editno = ""}) async {
  TokenManager tokenObj = TokenManager();
  var accessToken = await tokenObj.getAccessToken();
  log("update BPO Order");
  final updateBulkPriceroute =
      'https://easystockapi.scanntek.com/api/6365/BulkPriceUpdate';
  final url = Uri.parse(updateBulkPriceroute);
  log("uri:$url");
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'Authorization': "Bearer " "$accessToken",
    'ProductID': productId.toString(),
    'Price': price.toString(),
    'OrderID': orderid,
    'EditNo': editno
  };
  log("-------------------->>>>....update");
  // log("-------------------->>>>....update......$headers");
  final response = await http.post(
    url,
    headers: headers,
  );
  // log(headers.toString());
  log(" bulk   -------------------->>>>....update......$response");
  if (response.statusCode == 200) {
    log(response.body);
    return 'Success';
  } else {
    return 'Failed';
  }
}
