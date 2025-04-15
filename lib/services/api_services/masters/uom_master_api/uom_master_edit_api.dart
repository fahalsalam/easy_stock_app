// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> uomEditAPI({uomCode, uomDescription, uomID}) async {
  log("Edit uom API");
  var accessToken = await getToken();
  final bearerToken = "Bearer " "$accessToken";
  final url = Uri.parse(UOMEditRoute);
  log(  UOMEditRoute);
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'Authorization': bearerToken,
    'uomCode': uomCode,
    'uomDescription': uomDescription,
    'UOMID': uomID.toString()
  };
  log("header: $headers");
  try {
    final response = await http.put(url, headers: headers);
    log("Edit uom API ${response.statusCode.toString()}");
    if (response.statusCode == 200) {
      log("Edit uom API ${response.body.toString()}");

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
