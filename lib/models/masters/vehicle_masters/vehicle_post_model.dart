// To parse this JSON data, do
//
//     final vehiclePostModel = vehiclePostModelFromJson(jsonString);

import 'dart:convert';

VehiclePostModel vehiclePostModelFromJson(String str) => VehiclePostModel.fromJson(json.decode(str));

String vehiclePostModelToJson(VehiclePostModel data) => json.encode(data.toJson());

class VehiclePostModel {
    bool isSucess;
    String message;
    List<Datum> data;

    VehiclePostModel({
        required this.isSucess,
        required this.message,
        required this.data,
    });

    factory VehiclePostModel.fromJson(Map<String, dynamic> json) => VehiclePostModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int vehicleId;

    Datum({
        required this.vehicleId,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        vehicleId: json["VehicleID"],
    );

    Map<String, dynamic> toJson() => {
        "VehicleID": vehicleId,
    };
}
