// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> EditCategoryAPI(
    {categoryID, categoryName, isActive, imageUrl}) async {
  var accessToken = await getToken(); // Make sure to await the Future result
  final bearerToken = "Bearer " + "$accessToken";
  log("Edit Category API");
  final url = Uri.parse("${EditCategoryRoute}");
  log("${  EditCategoryRoute}");
  print("Id:${categoryID},name:${categoryName},isactive:${isActive}");
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'categoryID': categoryID.toString(),
    'categoryName': categoryName.toString(),
    'imageUrl': imageUrl,
    'isActive': isActive.toString(),
    'Authorization': bearerToken
    // "Bearer " + "$_accessToken"
  };

  try {
    final response = await http.put(url, headers: headers);
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log(response.body.toString());

      Map<String, dynamic> jsonData = json.decode(response.body);
      return 'Success';
    } else {
      // If the server returns an error response, throw an exception
      log("Failed to load data");
      return 'Failed';
      // throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
    return 'Failed';
  }
}
