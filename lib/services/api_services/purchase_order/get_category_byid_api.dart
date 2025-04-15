import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/token_manager/token_manager.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> getProductsbyidApi({categoryID}) async {
    TokenManager tokenObj = TokenManager();
  var accessToken = await tokenObj.getAccessToken();
  log("Products byidApi id:$categoryID");

  final url = Uri.parse(getCategoryByidRoute);
  log(  getCategoryByidRoute);
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'Authorization': "Bearer " "$accessToken",
    'CategoryID': categoryID, 
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
       log(response.body);
      
      return response.body;
    } else {
      log(response.body);
    
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
    return "false";
  }
}
