import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/models/purchase_order/order_details_model.dart';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> editPurchaseOrderApi(
    {required String customerId,
    required String customername,
    required List<Detail> PurchaseOrderList,
    required double totalPrice,
    required double Vat,
    required String docStatus,
    required String editNo,
    required String orderID}) async {
  var accessToken = await getToken(); // Make sure to await the Future result
  final bearerToken = "Bearer " "$accessToken";
  log("editPurchaseOrderApi id $orderID");

  final url = Uri.parse(postPurchaseOrdeRoute);
  log(postPurchaseOrdeRoute);

  log("purchaseOrderlist ");
 

  List<Map<String, dynamic>> convertDetailsToJson(
    List<Detail> products,
  ) {
    return products.map((product) => product.toJson()).toList();
  }

  List<Map<String, dynamic>> jsonBody = convertDetailsToJson(PurchaseOrderList);
  log("response: $jsonBody");
  var data = {
    'PurchaseOrderHeader': {
      'CustomerID': customerId,
      'CustomerName': customername,
      'TotalAmount': totalPrice,
      'TotalVat': Vat,

      // 'O'(open) --> fresh data
      // 'U'(updated) --> edited data
    },
    'PurchaseOrderLines': jsonBody,
  };

  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'Authorization': bearerToken,
    'OrderID': orderID,
    'EditNo': editNo,
    'DocStatus': docStatus
  };
  log("------------>>>>>$postPurchaseOrdeRoute");
  log("-------------->>>>>data:$data");
  log("----->>>>>>header:$headers");
  log("------------>>>>>");
  try {
    log("res: $data");
    final response =
        await http.post(url, headers: headers, body: jsonEncode(data));

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
