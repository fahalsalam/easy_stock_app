// To parse this JSON data, do
//
//     final uomMasterModel = uomMasterModelFromJson(jsonString);

import 'dart:convert';

UomMasterModel uomMasterModelFromJson(String str) => UomMasterModel.fromJson(json.decode(str));

String uomMasterModelToJson(UomMasterModel data) => json.encode(data.toJson());

class UomMasterModel {
    bool isSucess;
    String message;
    List<UomData> data;

    UomMasterModel({
        required this.isSucess,
        required this.message,
        required this.data,
    });

    factory UomMasterModel.fromJson(Map<String, dynamic> json) => UomMasterModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<UomData>.from(json["data"].map((x) => UomData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class UomData {
    int uomid;
    String? uomCode;
    String? uomDescription;

    UomData({
        required this.uomid,
        required this.uomCode,
        required this.uomDescription,
    });

    factory UomData.fromJson(Map<String, dynamic> json) => UomData(
        uomid: json["UOMID"],
        uomCode: json["UOMCode"],
        uomDescription: json["UOMDescription"],
    );

    Map<String, dynamic> toJson() => {
        "UOMID": uomid,
        "UOMCode": uomCode,
        "UOMDescription": uomDescription,
    };
}
