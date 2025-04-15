// To parse this JSON data, do
//
//     final vehicleMastermodel = vehicleMastermodelFromJson(jsonString);

import 'dart:convert';

VehicleMastermodel vehicleMastermodelFromJson(String str) => VehicleMastermodel.fromJson(json.decode(str));

String vehicleMastermodelToJson(VehicleMastermodel data) => json.encode(data.toJson());

class VehicleMastermodel {
    bool isSucess;
    String message;
    List<VehicleDatum> data;

    VehicleMastermodel({
        required this.isSucess,
        required this.message,
        required this.data,
    });

    factory VehicleMastermodel.fromJson(Map<String, dynamic> json) => VehicleMastermodel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<VehicleDatum>.from(json["data"].map((x) => VehicleDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class VehicleDatum {
    int vehicleId;
    String vehicleName;
    String vehicleNumber;
    String driverName;
    String contactNo;
    String imageUrl;
    List<Customer> customers;
    List<Category> categories;

    VehicleDatum({
        required this.vehicleId,
        required this.vehicleName,
        required this.vehicleNumber,
        required this.driverName,
        required this.contactNo,
        required this.imageUrl,
        required this.customers,
        required this.categories,
    });

    factory VehicleDatum.fromJson(Map<String, dynamic> json) => VehicleDatum(
        vehicleId: json["vehicleID"],
        vehicleName: json["vehicleName"],
        vehicleNumber: json["vehicleNumber"],
        driverName: json["driverName"],
        contactNo: json["contactNo"],
        imageUrl: json["imageUrl"],
        customers: List<Customer>.from(json["customers"].map((x) => Customer.fromJson(x))),
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "vehicleID": vehicleId,
        "vehicleName": vehicleName,
        "vehicleNumber": vehicleNumber,
        "driverName": driverName,
        "contactNo": contactNo,
        "imageUrl": imageUrl,
        "customers": List<dynamic>.from(customers.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    };
}

class Category {
    String categoryId;
    String categoryName;

    Category({
        required this.categoryId,
        required this.categoryName,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["categoryID"].toString(),
        categoryName: json["categoryName"],
    );

    Map<String, dynamic> toJson() => {
        "categoryID": categoryId,
        "categoryName": categoryName,
    };
}

class Customer {
    dynamic customerId;
    String customerName;

    Customer({
        required this.customerId,
        required this.customerName,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        customerId: json["customerID"],
        customerName: json["customerName"],
    );

    Map<String, dynamic> toJson() => {
        "customerID": customerId,
        "customerName": customerName,
    };
}


// // To parse this JSON data, do
// //
// //     final vehicleMastermodel = vehicleMastermodelFromJson(jsonString);

// import 'dart:convert';

// VehicleMastermodel vehicleMastermodelFromJson(String str) =>
//     VehicleMastermodel.fromJson(json.decode(str));

// String vehicleMastermodelToJson(VehicleMastermodel data) =>
//     json.encode(data.toJson());

// class VehicleMastermodel {
//   bool isSucess;
//   String message;
//   List<VehicleDatum> data;

//   VehicleMastermodel({
//     required this.isSucess,
//     required this.message,
//     required this.data,
//   });

//   factory VehicleMastermodel.fromJson(Map<String, dynamic> json) =>
//       VehicleMastermodel(
//         isSucess: json["isSucess"],
//         message: json["message"],
//         data: List<VehicleDatum>.from(
//             json["data"].map((x) => VehicleDatum.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "isSucess": isSucess,
//         "message": message,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class VehicleDatum {
//   String vehicleId;
//   String vehicleName;
//   String vehicleNumber;
//   String driverName;
//   String contactNo;
//   String imageUrl;
//   List<Customer> customers;

//   VehicleDatum({
//     required this.vehicleId,
//     required this.vehicleName,
//     required this.vehicleNumber,
//     required this.driverName,
//     required this.contactNo,
//     required this.imageUrl,
//     required this.customers,
//   });

//   factory VehicleDatum.fromJson(Map<String, dynamic> json) => VehicleDatum(
//         vehicleId: json["vehicleID"].toString(),
//         vehicleName: json["vehicleName"].toString(),
//         vehicleNumber: json["vehicleNumber"].toString(),
//         driverName: json["driverName"].toString(),
//         contactNo: json["contactNo"].toString(),
//         imageUrl: json["imageUrl"].toString(),
//         customers: List<Customer>.from(
//             json["customers"].map((x) => Customer.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "vehicleID": vehicleId,
//         "vehicleName": vehicleName,
//         "vehicleNumber": vehicleNumber,
//         "driverName": driverName,
//         "contactNo": contactNo,
//         "imageUrl": imageUrl,
//         "customers": List<dynamic>.from(customers.map((x) => x.toJson())),
//       };
// }

// class Customer {
//   dynamic customerId;
//   String customerName;

//   Customer({
//     required this.customerId,
//     required this.customerName,
//   });

//   factory Customer.fromJson(Map<String, dynamic> json) => Customer(
//         customerId: json["customerID"],
//         customerName: json["customerName"],
//       );

//   Map<String, dynamic> toJson() => {
//         "customerID": customerId,
//         "customerName": customerName,
//       };
// }
