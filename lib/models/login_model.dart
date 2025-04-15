// To parse this JSON data, do
//
//     final loginmodel = loginmodelFromJson(jsonString);

import 'dart:convert';

Loginmodel loginmodelFromJson(String str) => Loginmodel.fromJson(json.decode(str));

String loginmodelToJson(Loginmodel data) => json.encode(data.toJson());

class Loginmodel {
    bool isSucess;
    String message;
    LoginData data;

    Loginmodel({
        required this.isSucess,
        required this.message,
        required this.data,
    });

    factory Loginmodel.fromJson(Map<String, dynamic> json) => Loginmodel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: LoginData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": data.toJson(),
    };
}

class LoginData {
    String accessToken;
    String refreshToken;
    String clientId;
    String isPurchaseRequest;
    String isMasters;
    String isConsolidatedPurchase;
  String isDriver;
    LoginData({
        required this.accessToken,
        required this.refreshToken,
        required this.clientId,
        required this.isPurchaseRequest,
        required this.isMasters,
        required this.isConsolidatedPurchase,required this.isDriver
    });

    factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        accessToken: json["_accessToken"].toString(),
        refreshToken: json["_refreshToken"].toString(),
        clientId: json["_clientID"].toString(),
        isPurchaseRequest: json["isPurchaseRequest"].toString(),
        isMasters: json["isMasters"].toString(),
        isConsolidatedPurchase: json["isConsolidatedPurchase"].toString(),
        isDriver: json["isDriver"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "_accessToken": accessToken,
        "_refreshToken": refreshToken,
        "_clientID": clientId,
        "isPurchaseRequest": isPurchaseRequest,
        "isMasters": isMasters,
        "isConsolidatedPurchase": isConsolidatedPurchase,
        "isDriver":isDriver
    };
}






// class LoginModel {
//   String isSuccess;
//   String message;
//   String accessToken;
//   String refreshToken;

//   LoginModel({
//     required this.isSuccess,
//     required this.message,
//     required this.accessToken,
//     required this.refreshToken,
//   });

//   factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
//         isSuccess: json["is_success"] ?? '',
//         message: json["message"] ?? '',
//         accessToken: json["data"]?["_accessToken"] ?? '',
//         refreshToken: json["data"]?["_refreshToken"] ?? '',
//       );

//   Map<String, dynamic> toJson() => {
//         "is_success": isSuccess,
//         "message": message,
//         "data": {
//           "access_token": accessToken,
//           "refresh_token": refreshToken,
//         },
//       };
// }