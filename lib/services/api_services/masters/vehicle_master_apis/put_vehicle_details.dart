// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/models/masters/productMasterLoad_Model.dart';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> EditVehicleDetailsAPI(
    {vehicleID, vehicleName, vehicleNumber, driverName, contactNo,imgUrl,category}) async {
  log("Edit vehicle details API");
  var accessToken = await getToken();  // Make sure to await the Future result
  final bearerToken = "Bearer " "$accessToken";
  final url = Uri.parse(UpdateVehicleDetailsRoute);
  log(UpdateVehicleDetailsRoute);

  final data = {
    "VehicleName": vehicleName,
    "VehicleNumber": vehicleNumber,
    "DriverName": driverName,
    "ContactNo": contactNo,
    "ImageUrl": imgUrl,
     "MappedCategory": category
  };
  Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'VehicleID': vehicleID,
    'Authorization': bearerToken
    // "Bearer " + "$_accessToken"
  };
log("put vehicle --${jsonEncode(data)}");
  try {
    final response =
        await http.put(url, headers: headers, body: jsonEncode(data));
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      log(response.body.toString());

      Map<String, dynamic> jsonData = json.decode(response.body);
      return "Success";
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
    return 'Failed';
  }
}
