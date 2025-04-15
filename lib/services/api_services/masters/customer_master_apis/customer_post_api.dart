// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> customerPostAPI(customerCode,customerName,group,city, List<String> vehicleIds,) async {
  log("customer post API");
  var accessToken = await getToken(); // Make sure to await the Future result
  final bearerToken = "Bearer " "$accessToken";
  final url = Uri.parse(customerPostRoute);
  log(customerPostRoute);
List<Map<String, String>> formattedVehicles = vehicleIds
    .map((vehicleId) =>
     {"VehicleID": vehicleId})
    .toList();

  var data = {
    "CustomerCode": customerCode,
    "CustomerName": customerName,
    "Group": group,
    "City": city,
    "Vehicles": formattedVehicles
  };
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'Authorization': bearerToken,
  };

  try { log("---->>>>request-------->>>>>:${jsonEncode(data)}");
    log("---->>>>data:$data");
    final response =
        await http.post(url, headers: headers, body: jsonEncode(data));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log(response.body.toString());
      //f the server returns an OK response, parse the JSON

      Map<String, dynamic> jsonData = json.decode(response.body);
      return 'Success';
    } else {
      log(response.body.toString());
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
    return 'Failed';
  }
}
