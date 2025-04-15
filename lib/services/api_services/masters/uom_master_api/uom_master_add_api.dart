// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> uomAddAPI({uomCode,uomDescription}) async {
  log("Add uom API");
  var accessToken = await getToken();  // Make sure to await the Future result
  final bearerToken = "Bearer " "$accessToken";
  final url = Uri.parse(UOMAddRoute);
  log(  UOMAddRoute);
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'Authorization': bearerToken,
    'uomCode': uomCode,
    'uomDescription': uomDescription
    
  };
log("ADD uom: $headers");
  try {
    final response = await http.post(url, headers: headers);
    log("Add uom API code ${response.statusCode.toString()}");
     log("Add uom API body ${response.body}");
    if (response.statusCode == 200) {
      log("Add uom API res: ${response.body.toString()}");
      //f the server returns an OK response, parse the JSON

      Map<String, dynamic> jsonData = json.decode(response.body);
      return 'Success';
    } else {
      // If the server returns an error response, throw an exception
      // throw Exception('Failed to load data');
      return "Failed";
    }
  } catch (e) {
    print('Error: $e');
    return "Failed";
  }
}
