// To parse this JSON data, do
//
//     final customerMasterModel = customerMasterModelFromJson(jsonString);

import 'dart:convert';

CustomerMasterModel customerMasterModelFromJson(String str) =>
    CustomerMasterModel.fromJson(json.decode(str));

String customerMasterModelToJson(CustomerMasterModel data) =>
    json.encode(data.toJson());

class CustomerMasterModel {
  bool isSucess;
  String message;
  List<CustomerData> data;

  CustomerMasterModel({
    required this.isSucess,
    required this.message,
    required this.data,
  });

  factory CustomerMasterModel.fromJson(Map<String, dynamic> json) =>
      CustomerMasterModel(
        isSucess: json["isSucess"] ?? false, // Default to false if null
        message: json["message"] ?? "Unknown error", // Provide default message
        data: (json["data"] != null
                ? List<CustomerData>.from(
                    json["data"].map((x) => CustomerData.fromJson(x)))
                : <CustomerData>[]), // Provide an empty list if null
      );

  Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CustomerData {
  String customerId;
  String customerCode;
  String customerName;
  String group;
  String city;
  List<Vehicle> vehicles;

  CustomerData({
    required this.customerId,
    required this.customerCode,
    required this.customerName,
    required this.group,
    required this.city,
    required this.vehicles,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) => CustomerData(
        customerId: json["CustomerID"]?.toString() ?? "0", // Default to "0" if null
        customerCode: json["CustomerCode"] ?? "Unknown Code", // Default if null
        customerName: json["CustomerName"] ?? "Unknown Name", // Default if null
        group: json["Group"] ?? "No Group", // Default if null
        city: json["City"] ?? "Unknown City", // Default if null
        vehicles: (json["Vehicles"] != null
                ? List<Vehicle>.from(
                    json["Vehicles"].map((x) => Vehicle.fromJson(x)))
                : <Vehicle>[]), // Empty list if null
      );

  Map<String, dynamic> toJson() => {
        "CustomerID": customerId,
        "CustomerCode": customerCode,
        "CustomerName": customerName,
        "Group": group,
        "City": city,
        "Vehicles": List<dynamic>.from(vehicles.map((x) => x.toJson())),
      };
}

class Vehicle {
  String customerId;
  String vehicleId;
  String vehicleName;

  Vehicle({
    required this.customerId,
    required this.vehicleId,
    required this.vehicleName,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        customerId: json["CustomerID"]?.toString() ?? "0", // Default to "0" if null
        vehicleId: json["VehicleID"]?.toString() ?? "0", // Default to "0" if null
        vehicleName: json["VehicleName"] ?? "Unnamed Vehicle", // Default if null
      );

  Map<String, dynamic> toJson() => {
        "CustomerID": customerId,
        "VehicleID": vehicleId,
        "VehicleName": vehicleName,
      };
}


// import 'dart:convert';

// CustomerMasterModel customerMasterModelFromJson(String str) =>
//     CustomerMasterModel.fromJson(json.decode(str));

// String customerMasterModelToJson(CustomerMasterModel data) =>
//     json.encode(data.toJson());

// class CustomerMasterModel {
//   bool isSucess;
//   String message;
//   List<CustomerData> data;

//   CustomerMasterModel({
//     required this.isSucess,
//     required this.message,
//     required this.data,
//   });

//   factory CustomerMasterModel.fromJson(Map<String, dynamic> json) =>
//       CustomerMasterModel(
//         isSucess: json["isSucess"],
//         message: json["message"],
//         data: List<CustomerData>.from(
//             json["data"].map((x) => CustomerData.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "isSucess": isSucess,
//         "message": message,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class CustomerData {
//   String customerId;
//   String customerCode;
//   String customerName;
//   String group;
//   String city;
//   List<Vehicle> vehicles;

//   CustomerData({
//     required this.customerId,
//     required this.customerCode,
//     required this.customerName,
//     required this.group,
//     required this.city,
//     required this.vehicles,
//   });

//   factory CustomerData.fromJson(Map<String, dynamic> json) => CustomerData(
//         customerId: json["CustomerID"].toString(),
//         customerCode: json["CustomerCode"],
//         customerName: json["CustomerName"],
//         group: json["Group"],
//         city: json["City"],
//         vehicles: List<Vehicle>.from(
//             json["Vehicles"].map((x) => Vehicle.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "CustomerID": customerId,
//         "CustomerCode": customerCode,
//         "CustomerName": customerName,
//         "Group": group,
//         "City": city,
//         "Vehicles": List<dynamic>.from(vehicles.map((x) => x.toJson())),
//       };
// }

// class Vehicle {
//   String customerId;
//   String vehicleId;
//   String vehicleName;

//   Vehicle({
//     required this.customerId,
//     required this.vehicleId,
//     required this.vehicleName,
//   });

//   factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
//         customerId: json["CustomerID"].toString(),
//         vehicleId: json["VehicleID"].toString(),
//         vehicleName: json["VehicleName"],
//       );

//   Map<String, dynamic> toJson() => {
//         "CustomerID": customerId,
//         "VehicleID": vehicleId,
//         "VehicleName": vehicleName,
//       };
// }








// // To parse this JSON data, do
// //
// //     final customerMasterModel = customerMasterModelFromJson(jsonString);

// import 'dart:convert';

// CustomerMasterModel customerMasterModelFromJson(String str) =>
//     CustomerMasterModel.fromJson(json.decode(str));

// String customerMasterModelToJson(CustomerMasterModel data) =>
//     json.encode(data.toJson());

// class CustomerMasterModel {
//   bool isSucess;
//   String message;
//   List<CustomerData> data;

//   CustomerMasterModel({
//     required this.isSucess,
//     required this.message,
//     required this.data,
//   });

//   factory CustomerMasterModel.fromJson(Map<String, dynamic> json) =>
//       CustomerMasterModel(
//         isSucess: json["isSucess"],
//         message: json["message"],
//         data: List<CustomerData>.from(
//             json["data"].map((x) => CustomerData.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "isSucess": isSucess,
//         "message": message,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class CustomerData {
//   int customerId;
//   String customerCode;
//   String customerName;
//   String customerGroup;
//   String customerCity;
//   String vehicleID;
//   String vehicleName;

//   CustomerData(
//       {required this.customerId,
//       required this.customerCode,
//       required this.customerName,
//       required this.customerGroup,
//       required this.customerCity,
//       required this.vehicleID,
//       required this.vehicleName,
//       });

//   factory CustomerData.fromJson(Map<String, dynamic> json) => CustomerData(
//       customerId: json["CustomerID"],
//       customerCode: json["CustomerCode"],
//       customerName: json["CustomerName"],
//       customerGroup: json["Group"],
//       customerCity: json["City"],
//       vehicleID: json["VehicleID"].toString(),
//       vehicleName:json["VehicleName"]
//       );

//   Map<String, dynamic> toJson() => {
//         "CustomerID": customerId,
//         "CustomerCode": customerCode,
//         "CustomerName": customerName,
//         "Group":customerGroup,
//         "City":customerCity,
//         "VehicleID":vehicleID,
//         "VehicleName":vehicleName
//       };
// }
