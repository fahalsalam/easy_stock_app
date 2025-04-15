import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> itemMasterUpdateAPI({
  required String productID,
  required String productCode,
  required String productName,
  String? barcode,
  String? uom,
  String? vat,
  String? price,
  String? category,
  String? imageUrl,
}) async {
  log("Item Master Edit API");

  // Fetch the access token
  var accessToken = await getToken();
  if (accessToken == null) {
    log("Failed to fetch access token");
    return 'Failed to retrieve token';
  }

  final bearerToken = "Bearer $accessToken";
  final url = Uri.parse(itemPUTRoute);
  log(itemPUTRoute);

  // Prepare request data
  final data = {
    "productCode": productCode,
    "productName": productName,
    "barcode": barcode,
    "uom": uom,
    "vat": vat,
    "price": price,
    "category": category,
    "imageurl": imageUrl,
  };
  final jsonBody = jsonEncode(data);

  // Set headers
  final headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'Authorization': bearerToken,
    'ProductID': productID,
  };

  log("<<<<<< Request Details >>>>>>");
  log("Headers: $headers");
  log("Body: $jsonBody");

  try {
    final response = await http.put(url, headers: headers, body: jsonBody);
    log("Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      // throw Exception('Failed to update item master. Response: ${response.body}');
      return response.body;
    }
  } catch (e) {
    log('Error: $e');
    return 'Failed';
  }
}













// // ignore_for_file: unused_local_variable

// import 'dart:convert';
// import 'dart:developer';
// import 'package:easy_stock_app/utils/constants/api_key.dart';
// import 'package:easy_stock_app/utils/urls.dart';
// import 'package:http/http.dart' as http;

// Future<String> ItemMasterUPDATEAPI({
//   productID,
//   productCode,productName,barcode,uom,vat,price,category,imageUrl}) async {
//   log("item Master Edit API");
//   var accessToken = await getToken();  // Make sure to await the Future result
//   final bearerToken = "Bearer " + "$accessToken";
//   final url = Uri.parse(itemPUTRoute);
//   log(  itemPUTRoute);

//   // Convert your data to JSON
//   final data = {
//     "productCode": productCode,
//     "productName": productName,
//     "barcode": barcode,
//     "uom": uom,
//     "vat": vat,
//     "price": price,
//     "category": category,
//     "imageurl": imageUrl
//     // "http://example.com/image.png"
//   };
//   final jsonBody = jsonEncode(data);
//   Map<String, String>? headers = {
//     'Content-Type': 'application/json',
//     'XApiKey': apiKey,
//     'Authorization': bearerToken,
//     'ProductID':productID
//     // "Bearer " + "$_accessToken"
//   };
//   log("<<<<<<------------------------------>>>>");
// log(headers.toString());
// log(jsonBody .toString()); 
//  log("<<<<<<------------------------------>>>>");
//   try {
//     final response = await http.put(
//       url,
//       headers: headers,
//       body: jsonBody,
//     );
//     log(response.statusCode.toString());
//     if (response.statusCode == 200) {
//       log(response.body.toString());
//       //f the server returns an OK response, parse the JSON

//       Map<String, dynamic> jsonData = json.decode(response.body);

//       return response.body;
//     } else {
//       log(response.body.toString());
//       // If the server returns an error response, throw an exception
//       throw Exception('Failed to load data');
//     }
//   } catch (e) {
//     print('Error: $e');
//     return 'Failed';
//   }
// }
