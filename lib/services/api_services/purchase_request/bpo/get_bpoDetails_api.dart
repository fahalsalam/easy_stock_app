import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/token_manager/token_manager.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> fetchPurchaseOrderBPOByProduct(productID) async {
  TokenManager tokenObj = TokenManager();
  var accessToken = await tokenObj.getAccessToken();
  log("get bpo details api");

  final url = Uri.parse(getPurchaseOrderbyProductRoute);
  // log( getPurchaseOrderRoute);
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'ProductID': productID,
    'Authorization': "Bearer " "$accessToken",
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    print("response:${response.body}");
    return response.body.toString();
  } else {
    print(
        'Failed to load Purchase Order BPO by product ${response.statusCode}');
    return 'Failed';
  }
}
