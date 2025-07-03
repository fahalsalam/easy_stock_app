// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/token_manager/token_manager.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> fetchPurchaseOrderBPO() async {
  TokenManager tokenObj = TokenManager();
  var _accessToken = await tokenObj.getAccessToken();
  log("get bpo api");

  final url = Uri.parse(getPurchaseOrderRoute);
  log(getPurchaseOrderRoute);
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'Authorization': "Bearer " "$_accessToken",
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    log("response   88968ret7w :${response.body.toString()}");
    return response.body.toString();
  } else {
    print('Failed to load Purchase Order BPO ${response.statusCode}');
    return 'Failed';
  }
}
