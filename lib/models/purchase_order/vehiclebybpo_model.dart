// To parse this JSON data, do
//
//     final vehiclebybpoModel = vehiclebybpoModelFromJson(jsonString);

import 'dart:convert';

VehiclebybpoModel vehiclebybpoModelFromJson(String str) => VehiclebybpoModel.fromJson(json.decode(str));

String vehiclebybpoModelToJson(VehiclebybpoModel data) => json.encode(data.toJson());

class VehiclebybpoModel {
    bool isSucess;
    String message;
    List<VehiclebybpoData> data;

    VehiclebybpoModel({
        required this.isSucess,
        required this.message,
        required this.data,
    });

    factory VehiclebybpoModel.fromJson(Map<String, dynamic> json) => VehiclebybpoModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<VehiclebybpoData>.from(json["data"].map((x) => VehiclebybpoData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class VehiclebybpoData {
    int vehicleId;
    String vehicleName;
    int totalBranch;
    int totalItems;
String driverName;
    VehiclebybpoData({
        required this.vehicleId,
        required this.vehicleName,
        required this.totalBranch,
        required this.totalItems,
        required this.driverName
    });

    factory VehiclebybpoData.fromJson(Map<String, dynamic> json) => VehiclebybpoData(
        vehicleId: json["VehicleID"],
        vehicleName: json["VehicleName"],
        totalBranch: json["TotalBranch"],
        totalItems: json["TotalItems"],
        driverName: json["DriverName"]
    );

    Map<String, dynamic> toJson() => {
        "VehicleID": vehicleId,
        "VehicleName": vehicleName,
        "TotalBranch": totalBranch,
        "TotalItems": totalItems,
        "DriverName":driverName
    };
}
