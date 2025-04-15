// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> AddCategoryAPI(categoryName, imageUrl) async {
  log("Add category API");
  var accessToken = await getToken(); // Make sure to await the Future result
  final bearerToken = "Bearer " "$accessToken";
  final url = Uri.parse(addCategoryRoute);
  log(addCategoryRoute);
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'categoryName': categoryName,
    'imageUrl': imageUrl,
    'Authorization': bearerToken
  };

  try {
    final response = await http.post(url, headers: headers);
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log(response.body.toString());

      Map<String, dynamic> jsonData = json.decode(response.body);
      return 'Success';
    } else {
      return 'Failed';
      // throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
    return 'Failed';
  }
}
