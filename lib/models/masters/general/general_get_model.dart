// To parse this JSON data, do
//
//     final generalsettingModel = generalsettingModelFromJson(jsonString);

import 'dart:convert';

GeneralsettingModel generalsettingModelFromJson(String str) => GeneralsettingModel.fromJson(json.decode(str));

String generalsettingModelToJson(GeneralsettingModel data) => json.encode(data.toJson());

class GeneralsettingModel {
    String isSuccess;
    String message;
    List<GeneralDatum> data;

    GeneralsettingModel({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory GeneralsettingModel.fromJson(Map<String, dynamic> json) => GeneralsettingModel(
        isSuccess: json["isSuccess"].toString(),
        message: json["message"],
        data: List<GeneralDatum>.from(json["data"].map((x) => GeneralDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class GeneralDatum {
    int editTimeValidityInMinutes;

    GeneralDatum({
        required this.editTimeValidityInMinutes,
    });

    factory GeneralDatum.fromJson(Map<String, dynamic> json) => GeneralDatum(
        editTimeValidityInMinutes: json["EditTimeValidityInMinutes"],
    );

    Map<String, dynamic> toJson() => {
        "EditTimeValidityInMinutes": editTimeValidityInMinutes,
    };
}
