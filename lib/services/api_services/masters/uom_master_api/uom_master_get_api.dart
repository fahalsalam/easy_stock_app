// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> uomGETAPI() async {
  var accessToken = await getToken();  // Make sure to await the Future result
  final bearerToken = "Bearer " "$accessToken";
  final url = Uri.parse(UOMGETRoute);
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'Authorization': bearerToken
    // "Bearer " + "$_accessToken"
  };

  try {
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      //f the server returns an OK response, parse the JSON

      Map<String, dynamic> jsonData = json.decode(response.body);
      return response.body;
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load data');
    }
  } catch (e) {
    return 'Failed';
  }
}
