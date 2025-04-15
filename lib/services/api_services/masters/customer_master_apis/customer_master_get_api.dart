import 'dart:developer';

import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Function to get customer master data
Future<String> getCustomerMaster() async {
  log("customer get API");
  var accessToken = await getToken(); // Make sure to await the Future result
  final bearerToken = "Bearer " + "$accessToken";
  final url = Uri.parse("${customerGetRoute}");
  log("${customerGetRoute}");

  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'Authorization': bearerToken,
  };
print('------------------------->>Customer Master get Data: $headers');
  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('------------------------->>Customer Master get Data: $data');
      return response.body.toString();
    } else {
      print('Failed to load customer data: ${response.statusCode}');
      return 'Failed';
    }
  } catch (e) {
    print('Error occurred: $e');
    return 'Failed';
  }
}
