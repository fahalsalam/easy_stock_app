import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/token_manager/token_manager.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> getProductSummary({required String productID}) async {
  TokenManager tokenObj = TokenManager();
  var accessToken = await tokenObj.getAccessToken();
  final url = Uri.parse(getProductSummaryRoute);
  log("url:$getProductSummaryRoute");
  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'XApiKey': apiKey,
        'Authorization': "Bearer " "$accessToken",
        'productID': productID
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      log('Response data: ${response.body}');
      return response.body.toString();
    } else {
      log('Request failed with status: ${response.statusCode}');
      return 'Failed';
    }
  } catch (error) {
    print('Error: $error');
    return 'Failed';
  }
}
