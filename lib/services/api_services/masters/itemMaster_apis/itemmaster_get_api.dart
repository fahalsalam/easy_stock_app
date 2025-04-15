// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> ItemMasterGetAPI({required String searchText}) async {
  log("item Master API");
  var accessToken = await getToken();
  final bearerToken = "Bearer " "$accessToken";
  final url = Uri.parse(itemGETRoute);
  log(itemGETRoute);
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'searchText': searchText,
    'Authorization': bearerToken
  };

  try {
    final response = await http.get(url, headers: headers);
    log(response.body.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);

      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
    return 'Failed';
  }
}
