
import 'dart:developer';
import 'package:easy_stock_app/models/purchase/pending/bpo_pending_model.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/token_manager/token_manager.dart';

Future<BpoPendingModel> getPendingBPO({pending, completed, noStock}) async {
  TokenManager tokenObj = TokenManager();
  var accessToken = await tokenObj.getAccessToken();
  final url = Uri.parse(getpendingRoute);

  Map<String, String> headers = {
    'pending': pending.toString(),
    'completed': completed.toString(),
    'noStock': noStock.toString(),
    'XApiKey': apiKey,
    'Authorization': "Bearer $accessToken",
  };

  try {
    log("Sending request to: $url");
    log("Sending request $headers");
    final response = await http.get(url, headers: headers);
    log("Response status: ${response.statusCode}");
    log("Response body: ${response.body}");
    if (response.statusCode == 200) {
      return bpoPendingModelFromJson(
          response.body); // This can throw JsonParsingException
    } else {
      log("Failed to load data: ${response.body}");
      throw Exception('Failed to load pending BPO: ${response.statusCode}');
    }
  } catch (e) {
    log('Error: $e');
    throw Exception('Network error: $e');
  }
}




