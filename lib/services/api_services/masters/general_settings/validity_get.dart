import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/models/masters/general/general_get_model.dart';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<GeneralsettingModel?> getGeneralSettings() async {
  try {
    var accessToken = await getToken(); // Make sure to await the Future result
    final bearerToken = "Bearer $accessToken";
    final url = Uri.parse(getvalidityRoute);

    final response = await http.post(
      url,
      headers: {
        // 'Content-Type': 'application/json',
        // 'XApiKey': apiKey,
        'Authorization': bearerToken,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      GeneralsettingModel obj = GeneralsettingModel.fromJson(data);
      log("Response Data: $data");
      return obj;
    } else {
      log("Error: ${response.statusCode} - ${response.body}");
      return null;
    }
  } catch (e) {
    debugPrint("Exception: $e");
    return null;
  }
}




// import 'dart:convert';
// import 'dart:developer';
// import 'package:easy_stock_app/models/masters/general/general_get_model.dart';
// import 'package:easy_stock_app/utils/constants/api_key.dart';
// import 'package:easy_stock_app/utils/urls.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// Future<GeneralsettingModel> getGeneralSettings() async {
//   var accessToken = await getToken(); // Make sure to await the Future result
//   final bearerToken = "Bearer " "$accessToken";
//   final url = Uri.parse(getvalidityRoute);
//   try {
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'XApiKey': apiKey,
//         'Authorization': bearerToken
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       GeneralsettingModel obj = GeneralsettingModel.fromJson(data);
//       log("Response Data: $data");
//       return obj;
//     } else {
//       log("Error: ${response.statusCode} - ${response.body}");
//     }
//   } catch (e) {
//     debugPrint("Exception: $e");
//   }
// }
