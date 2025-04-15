import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/utils/constants/api_key.dart';
import 'package:easy_stock_app/utils/urls.dart';
import 'package:http/http.dart' as http;

Future<String> putUserMaster(
    {userCode,
    userName,
    defaultCustomer,
    isPurchase,
    isMasters,
    isConsolidate,
    isDriver,
    userID,category}) async {
  log("user master put $defaultCustomer");
  var accessToken = await getToken();
  final bearerToken = "Bearer " "$accessToken";
  final url = Uri.parse(putUserMasterRoute);

  final headers = {
    'XApiKey': apiKey,
    'Authorization': bearerToken,
    'Content-Type': 'application/json',
    '_UserID': userID.toString(),
  };

  final Map<String, dynamic> body = {
    "UserCode": userCode,
    "UserName": userName,
    "DefaultCustomer": defaultCustomer,
    "MappedCategory":category,
    "IsPurchaseRequest": isPurchase,
    "IsMasters": isMasters,
    "IsConsolidatedPurchase": isConsolidate,
    "IsDriver": isDriver,

  };

  log('-------------->>>>>>>>>>User body: ${body},header:${headers}');

  try {
    final response =
        await http.put(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      print('-------------->>>>>>>>>>User updated successfully: ${response.body}');
      return 'Success';
    } else {
      print(
          'Failed to update user. Status code: ${response.statusCode},${response.body}');
      return 'Failed';
    }
  } catch (error) {
    print('Error making request: $error');
    return 'Failed';
  }
}
