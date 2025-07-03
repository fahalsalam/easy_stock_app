// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/token_manager/token_manager.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

import '../../../../models/purchase/pending/pending_details_model.dart';

Future<BpoPendingDetailsModel> fetchPendingBPODetails({
  required String pending,
  required String completed,
  required String noStock,
  required String orderID,
  required String editNo,
}) async {
  log("fetchPendingBPODetails");
  TokenManager tokenObj = TokenManager();
  var accessToken = await tokenObj.getAccessToken();
  final url = Uri.parse(getpendingDetailsRoute);

  final headers = {
    'pending': pending.toString(),
    'completed': completed.toString(),
    'noStock': noStock.toString(),
    'OrderID': orderID.toString(),
    'EditNo': editNo.toString(),
    'XApiKey': apiKey,
    'Authorization': "Bearer $accessToken",
  };

  print("Url:$url");
  print("Headers: $headers");

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      log('venda Response data: $data');
      return BpoPendingDetailsModel.fromJson(
          data); // Assuming `fromJson` is implemented
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    log('Error: $e');
    throw Exception('Failed to fetch pending BPO details');
  }
}
