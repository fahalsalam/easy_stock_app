import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> postUserMaster(
    {userCode,
    userName,
    password,
    defaultCustomer,
    isPurchase,
    isMasters,
    isConsolidate,
    isDriver,
    category,
    vehicleID}) async {
  // Define the API URL
  var accessToken = await getToken(); // Make sure to await the Future result
  final bearerToken = "Bearer " + "$accessToken";
  final url = Uri.parse(postUserMasterRoute);

  // Define the headers
  final headers = {
    'XApiKey': apiKey,
    'Authorization': bearerToken,
    'Content-Type': 'application/json'
  };

  // Define the JSON body
  final Map<String, dynamic> body = {
    "UserCode": userCode,
    "UserName": userName,
    "PasswordHash": password,
    "MappedCategory": category,
    "DefaultCustomer": defaultCustomer,
    "IsPurchaseRequest": isPurchase,
    "IsMasters": isMasters,
    "IsConsolidatedPurchase": isConsolidate,
    "IsDriver": isDriver,
    if (isDriver) "VehicleID": vehicleID
  };
  log("req:---------------------------------->>>>>>>  ${jsonEncode(body)}");
  try {
    // Make the POST request
    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    // Check if the request was successful
    if (response.statusCode == 200) {
      print('User added successfully: ${response.body}');
      return 'Success';
    } else {
      log('Failed to add user. Status code: ${response.statusCode}');
      return 'Failed';
    }
  } catch (error) {
    print('Error making request: $error');
    return 'Failed';
  }
}
