import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> cancelPurchaseOrderApi(
    {required String editNo, required String orderID}) async {
  var accessToken = await getToken();
  final bearerToken = "Bearer " "$accessToken";
  log("editPurchaseOrderApi id $orderID");

  final url = Uri.parse(orderCancelRoute);
  log(orderCancelRoute);

  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'Authorization': bearerToken,
    'OrderID': orderID,
    'EditNo': editNo,
  };
  log("------------>>>>>$orderCancelRoute");
  log("----->>>>>>header:$headers");

  try {
    final response = await http.post(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      log(response.body);

      return "Success";
    } else {
      log(response.body);

      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
    return "Failed";
  }
}
