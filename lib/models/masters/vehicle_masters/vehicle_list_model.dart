// To parse this JSON data, do
//
//     final vehicleListModel = vehicleListModelFromJson(jsonString);

import 'dart:convert';

VehicleListModel vehicleListModelFromJson(String str) => VehicleListModel.fromJson(json.decode(str));

String vehicleListModelToJson(VehicleListModel data) => json.encode(data.toJson());

class VehicleListModel {
    bool isSucess;
    String message;
    List<VehicleData> data;

    VehicleListModel({
        required this.isSucess,
        required this.message,
        required this.data,
    });

    factory VehicleListModel.fromJson(Map<String, dynamic> json) => VehicleListModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<VehicleData>.from(json["data"].map((x) => VehicleData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class VehicleData {
    int vehicleId;
    String vehicleName;
    String vehicleNumber;
    String driverName;
    String contactNo;
    String imageUrl;

    VehicleData({
        required this.vehicleId,
        required this.vehicleName,
        required this.vehicleNumber,
        required this.driverName,
        required this.contactNo,
        required this.imageUrl,
    });

    factory VehicleData.fromJson(Map<String, dynamic> json) => VehicleData(
        vehicleId: json["VehicleID"]??"",
        vehicleName: json["VehicleName"]??"",
        vehicleNumber: json["VehicleNumber"]??"",
        driverName: json["DriverName"]??"",
        contactNo: json["ContactNo"]??"",
        imageUrl: json["ImageUrl"]??"",
    );

    Map<String, dynamic> toJson() => {
        "VehicleID": vehicleId,
        "VehicleName": vehicleName,
        "VehicleNumber": vehicleNumber,
        "DriverName": driverName,
        "ContactNo": contactNo,
        "ImageUrl": imageUrl,
    };
}
