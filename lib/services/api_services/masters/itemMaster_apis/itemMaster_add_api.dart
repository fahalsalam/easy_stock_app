// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> ItemMasterADDAPI({ productCode,productName,barcode,uom,tax,price,category,imageUrl}) async {
  log("item Master ADD API");
  var accessToken = await getToken();  // Make sure to await the Future result
  final bearerToken = "Bearer " + "$accessToken";
  final url = Uri.parse(itemPOSTRoute);
  log(  itemPOSTRoute);

  // Convert your data to JSON
  final data = {
    "productCode": productCode,
    "productName": productName,
    "barcode": barcode,
    "uom": uom,
    "vat": tax,
    "price": price,
    "category": category,
    "imageurl":imageUrl
    // "http://example.com/image.png"
  };
  final jsonBody = jsonEncode(data);
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'Authorization': bearerToken,
    // "Bearer " + "$_accessToken"
  };
log("------------->>>>>>>>>");
log("------------->>>>>>>>>header:$headers");
log("------------->>>>>>>>>body:$data");
  try {
    final response = await http.post(
      url,
      headers: headers,
      body: jsonBody,
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log(response.body.toString());
      //f the server returns an OK response, parse the JSON

      Map<String, dynamic> jsonData = json.decode(response.body);

      return response.body;
    } else { print('Error: ${response.body}');
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
    return 'Failed';
  }
}
