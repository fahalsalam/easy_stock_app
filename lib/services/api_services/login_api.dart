import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/models/login_model.dart';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/constants/loginConstants.dart';
import 'package:easy_stock_app/utils/token_manager/token_manager.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> LoginAPI({
  required String tenantName,
  required String userName,
  required String password,
}) async {
  log("login API call...");
  final url = Uri.parse("${loginRoute}");
  log("Login URL: $url");

  // Defining the request headers
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'XApiKey': apiKey,
    'TenantName': tenantName,
    'UserName': userName,
    'Password': password
  };

  try {
    // Making the GET request
    final response = await http.get(url, headers: headers);
    log("Response headers: $headers");
    log("Response status code: ${response.statusCode}");

    // Check if the response is successful
    if (response.statusCode == 200) {
      log("-------------------------------->>> Login successful: ${response.body}");

      // Parse the JSON response
      Map<String, dynamic> jsonData = json.decode(response.body);
      Loginmodel loginResponse = Loginmodel.fromJson(jsonData);

      // Log access and refresh tokens
      log("Access Token: ${loginResponse.data.accessToken}");
      log("Refresh Token: ${loginResponse.data.refreshToken}");

      // Save tokens using the TokenManager
      TokenManager tokenManager = TokenManager();
      await tokenManager.saveTokens(
        loginResponse.data.accessToken,
        loginResponse.data.refreshToken,
        1000, //  token expiry
      );
// menu menuObj = menu(
      isMaster = loginResponse.data.isMasters;
      isOrder = loginResponse.data.isConsolidatedPurchase;
      isPurchase = loginResponse.data.isPurchaseRequest;
      isDriver = loginResponse.data.isDriver;
      customerID = loginResponse.data.clientId;
      // tenantName = loginResponse.data.TenantName;
      // userName = loginResponse.data.UserName;

      // );

      log("isMasters: ${isMaster}");
      log("isConsolidatedPurchase: ${isOrder}");
      log("isPurchaseRequest: ${isPurchase}");
      log("isDriver: ${isDriver}");
      log("clientId: ${customerID}");
      // log("TenantName: ${loginResponse.data.TenantName}");
      // log("UserName: ${loginResponse.data.UserName}");
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('username', tenantName);
      // prefs.setString('userCode', userName);
      // prefs.setString('password', password);
      // prefs.setBool('isRememberMe', true);
      // Return 'Failed' if access token is null
      if (loginResponse.data.accessToken.isEmpty) {
        return 'Failed';
      }

      // Successful login
      return 'Success';
    } else {
      // Log the failed response
      log("Login failed with status code: ${response.statusCode}, body: ${response.body}");
      return 'Failed';
    }
  } catch (e) {
    // Handle any errors during the API call
    log("Exception occurred during login: $e");
    return 'Failed';
  }
}
