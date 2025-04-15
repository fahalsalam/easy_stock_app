import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<bool> postGeneralSettings(int orderEditValidity) async {
  var accessToken = await getToken(); // Make sure to await the Future result
  final bearerToken = "Bearer " "$accessToken";
  final url = Uri.parse(postvalidityRoute);
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'XApiKey': apiKey,
        'Authorization': bearerToken,
      },
      body: jsonEncode({
        "OrderEditValidity": orderEditValidity,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log("Response Data: $data");
      return true;
    } else {
      log("Error: ${response.statusCode} - ${response.body}");
      return false;
    }
  } catch (e) {
    debugPrint("Exception: $e");
    return false;
  }
}
