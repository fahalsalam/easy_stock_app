
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> ProductMasterLoadAPI() async {
 var accessToken = await getToken();  // Make sure to await the Future result
  final bearerToken = "Bearer " + "$accessToken";

  log("ProductMasterLoadAPI");
  
  final url = Uri.parse(productLoadRoute);
  log(  productLoadRoute);
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'Authorization': bearerToken
    // "Bearer " + "$_accessToken"
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Map<String, dynamic> jsonData = json.decode(response.body);
      // ProductMasterLoadModel obj = ProductMasterLoadModel.fromJson(jsonData);
     return response.body;
    } else {
      print(response.body);
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load data');
     
    }
  } catch (e) {
    print('Error: $e');
    return "false";
  }
}
