// To parse this JSON data, do
//
//     final bpovehicleDetailsmodel = bpovehicleDetailsmodelFromJson(jsonString);

import 'dart:convert';

BpovehicleDetailsmodel bpovehicleDetailsmodelFromJson(String str) =>
    BpovehicleDetailsmodel.fromJson(json.decode(str));

String bpovehicleDetailsmodelToJson(BpovehicleDetailsmodel data) =>
    json.encode(data.toJson());

class BpovehicleDetailsmodel {
  bool isSucess;
  String message;
  List<bpoVehicleDatum> data;

  BpovehicleDetailsmodel({
    required this.isSucess,
    required this.message,
    required this.data,
  });

  factory BpovehicleDetailsmodel.fromJson(Map<String, dynamic> json) =>
      BpovehicleDetailsmodel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<bpoVehicleDatum>.from(
            json["data"].map((x) => bpoVehicleDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class bpoVehicleDatum {
  String productId;
  String productName;
  String totalQty;
  String imageUrl;
  String? categoryName;

  bpoVehicleDatum({
    required this.productId,
    required this.productName,
    required this.totalQty,
    required this.imageUrl,
    this.categoryName,
  });

  factory bpoVehicleDatum.fromJson(Map<String, dynamic> json) =>
      bpoVehicleDatum(
        productId: json["ProductID"].toString(),
        productName: json["ProductName"].toString(),
        totalQty: json["TotalQty"].toString(),
        imageUrl: json["ImageUrl"].toString(),
        categoryName: json["CategoryName"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "ProductID": productId,
        "ProductName": productName,
        "TotalQty": totalQty,
        "ImageUrl": imageUrl,
        "CategoryName": categoryName,
      };
}

// // To parse this JSON data, do
// //
// //     final bpovehicleDetailsmodel = bpovehicleDetailsmodelFromJson(jsonString);

// import 'dart:convert';

// BpovehicleDetailsmodel bpovehicleDetailsmodelFromJson(String str) => BpovehicleDetailsmodel.fromJson(json.decode(str));

// String bpovehicleDetailsmodelToJson(BpovehicleDetailsmodel data) => json.encode(data.toJson());

// class BpovehicleDetailsmodel {
//     bool isSucess;
//     String message;
//     List<bpoVehicleDatum> data;

//     BpovehicleDetailsmodel({
//         required this.isSucess,
//         required this.message,
//         required this.data,
//     });

//     factory BpovehicleDetailsmodel.fromJson(Map<String, dynamic> json) => BpovehicleDetailsmodel(
//         isSucess: json["isSucess"],
//         message: json["message"],
//         data: List<bpoVehicleDatum>.from(json["data"].map((x) => bpoVehicleDatum.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "isSucess": isSucess,
//         "message": message,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//     };
// }

// class bpoVehicleDatum {
//     int customerId;
//     String customerName;
//     int totalItems;

//     bpoVehicleDatum({
//         required this.customerId,
//         required this.customerName,
//         required this.totalItems,
//     });

//     factory bpoVehicleDatum.fromJson(Map<String, dynamic> json) => bpoVehicleDatum(
//         customerId: json["CustomerID"],
//         customerName: json["CustomerName"],
//         totalItems: json["TotalItems"],
//     );

//     Map<String, dynamic> toJson() => {
//         "CustomerID": customerId,
//         "CustomerName": customerName,
//         "TotalItems": totalItems,
//     };
// }
