import 'dart:developer';

import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> fetchProductByBarcode(barcode) async {
    log('fetchProductByBarcode ${barcode}');
    var accessToken = await getToken();  // Make sure to await the Future result
  final bearerToken = "Bearer " "$accessToken";
  final url = Uri.parse(barcodeApiRoute);
  final response = await http.get(
    url,
    headers: {
      
      'Barcode': barcode,
      'XApiKey': apiKey,
       'Authorization': bearerToken,
    },
  );

  if (response.statusCode == 200) {
   log('Success: ${response.body}');
   return response.body;
    // Process the response as needed
  } else {
  log('Failed to load data. Status code: ${response.statusCode}');
    return 'Failed';
  }
}
