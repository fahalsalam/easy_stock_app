import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> updateCustomer({
  required String customerCode,
  required String customerName,
  required String group,
  required String city,
  required Set<int> vehicleIds, // Allow multiple vehicle IDs
  required String customerID,
}) async {
  log("Initiating customer update API call...");

  try {
    // Retrieve token and prepare bearer
    var accessToken = await getToken(); // Ensure getToken handles errors
    final bearerToken = "Bearer $accessToken";
    final url = Uri.parse(customerPutRoute);

    // Format vehicles as a list of maps
    List<Map<String, dynamic>> formattedVehicles = vehicleIds
        .map((vehicleId) => {"VehicleID": vehicleId.toString()})
        .toList();

    // Prepare request payload
    var data = {
      "CustomerCode": customerCode,
      "CustomerName": customerName,
      "Group": group,
      "City": city,
      "Vehicles": formattedVehicles,
    };

    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'XApiKey': apiKey,
      'Authorization': bearerToken,
      "CustomerID": customerID
    };

    log("Headers: $headers");
    log("Request Data: ${jsonEncode(data)}");

    // Send PUT request
    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return 'Success: ${response.body}';
    } else {
      throw Exception('Failed to update customer: ${response.body}');
    }
  } catch (e) {
    log('Error: $e');
    return 'Failed: $e';
  }
}




