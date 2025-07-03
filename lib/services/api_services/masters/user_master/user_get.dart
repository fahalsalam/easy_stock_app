import 'dart:developer';

import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> getUserMaster() async {
  // Define the API URL
  // Define the API URL
  var accessToken = await getToken(); // Make sure to await the Future result
  final bearerToken = "Bearer " "$accessToken";
  final url = Uri.parse(getUserMasterRoute);

  // Define the headers
  final headers = {
    'XApiKey': apiKey,
    'Authorization': bearerToken,
    'Content-Type': 'application/json'
  };

  try {
    // Make the GET request
    final response = await http.get(url, headers: headers);

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the response body
      final data = (response.body);
      print('Response Data: ${response.body}');
      return data.toString();
    } else {
      log('Request failed with status------->>.....: ${response.statusCode},${response.body}');
      return 'Failed';
    }
  } catch (error) {
    print('Error making request: $error');
    return 'Failed';
  }
}
