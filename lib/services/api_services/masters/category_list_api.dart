// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> CategoryListAPI() async {
  var accessToken = await getToken();  // Make sure to await the Future result
  final bearerToken = "Bearer " + "$accessToken";
  log(" category list API");
  final url = Uri.parse("${CategoryListRoute}");
  log("${  CategoryListRoute}");
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,

    'Authorization': bearerToken
    
  };

  try {
    final response = await http.get(url, headers: headers);
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log(response.body.toString());
      //f the server returns an OK response, parse the JSON

      Map<String, dynamic> jsonData = json.decode(response.body);
      return response.body;
    } else {
      log(response.body.toString());
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
    return "Failed";
  }
}
