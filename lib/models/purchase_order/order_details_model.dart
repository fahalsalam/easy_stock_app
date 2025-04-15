// To parse this JSON data, do
//
//     final orderdetailsByidModel = orderdetailsByidModelFromJson(jsonString);

import 'dart:convert';

OrderdetailsByidModel orderdetailsByidModelFromJson(String str) => OrderdetailsByidModel.fromJson(json.decode(str));

String orderdetailsByidModelToJson(OrderdetailsByidModel data) => json.encode(data.toJson());

class OrderdetailsByidModel {
    bool isSucess;
    String message;
    Data data;

    OrderdetailsByidModel({
        required this.isSucess,
        required this.message,
        required this.data,
    });

    factory OrderdetailsByidModel.fromJson(Map<String, dynamic> json) => OrderdetailsByidModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    List<Header> header;
    List<Detail> details;

    Data({
        required this.header,
        required this.details,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        header: List<Header>.from(json["header"].map((x) => Header.fromJson(x))),
        details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "header": List<dynamic>.from(header.map((x) => x.toJson())),
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
    };
}

class Detail {
  String productId;
  String productName;
  String qty;
  String price;
  String total;
  String vat;
  String unit;
  String imageUrl;
  dynamic unitID;
  dynamic uomCode;
  String itemStatus;

  Detail(
      {required this.productId,
      required this.productName,
      required this.qty,
      required this.price,
      required this.total,
      required this.vat,
      required this.unit,
      required this.imageUrl,
      required this.unitID,
      required this.uomCode,
      required this.itemStatus});

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        productId: json["ProductID"].toString(),
        productName: json["ProductName"].toString(),
        qty: json["Qty"].toString(),
        price: json["Price"].toString(),
        total: json["Total"].toString(),
        vat: json["Vat"].toString(),
        unit: json["Unit"].toString(),
        unitID: json["UnitID"].toString(),
        imageUrl: json["ImageUrl"].toString(),
        uomCode: json["UOMCode"].toString(),
        itemStatus: json["ItemStatus"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "ProductID": productId,
        "ProductName": productName,
        "Qty": qty,
        "Price": price,
        "Total": total,
        "Vat": vat,
        "Unit": unit,
        "ImageUrl": imageUrl,
        "UnitID": unitID,
        "UOMCode": uomCode,
        "ItemStatus": itemStatus
      };
}


class Header {
    String orderId;
  String editNo;
  String customerId;
  String customerName;
  String totalAmount;
  DateTime orderDate;
  String totalVat;
    String printHeader;
    String country;
    String state;
    String trnNo;

    Header({
        required this.orderId,
        required this.editNo,
        required this.customerId,
        required this.customerName,
        required this.totalAmount,
        required this.orderDate,
        required this.totalVat,
        required this.printHeader,
        required this.country,
        required this.state,
        required this.trnNo,
    });

    factory Header.fromJson(Map<String, dynamic> json) => Header(
          orderId: json["OrderID"].toString(),
        editNo: json["EditNo"].toString(),
        customerId: json["CustomerID"].toString(),
        customerName: json["CustomerName"].toString(),
        totalAmount: json["TotalAmount"].toString(),
        orderDate: DateTime.parse(json["OrderDate"]),
        totalVat: json["TotalVat"].toString(),
        printHeader: json["PrintHeader"].toString(),
        country: json["Country"].toString(),
        state: json["State"].toString(),
        trnNo: json["TRNNo"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "OrderID": orderId,
        "EditNo": editNo,
        "CustomerID": customerId,
        "CustomerName": customerName,
        "TotalAmount": totalAmount,
        "OrderDate": orderDate.toIso8601String(),
        "TotalVat": totalVat,
        "PrintHeader": printHeader,
        "Country": country,
        "State": state,
        "TRNNo": trnNo,
    };
}







// To parse this JSON data, do
//
//     final orderdetailsByidModel = orderdetailsByidModelFromJson(jsonString);

// import 'dart:convert';

// OrderdetailsByidModel orderdetailsByidModelFromJson(String str) =>
//     OrderdetailsByidModel.fromJson(json.decode(str));

// String orderdetailsByidModelToJson(OrderdetailsByidModel data) =>
//     json.encode(data.toJson());

// class OrderdetailsByidModel {
//   bool isSucess;
//   String message;
//   Data data;

//   OrderdetailsByidModel({
//     required this.isSucess,
//     required this.message,
//     required this.data,
//   });

//   factory OrderdetailsByidModel.fromJson(Map<String, dynamic> json) =>
//       OrderdetailsByidModel(
//         isSucess: json["isSucess"],
//         message: json["message"],
//         data: Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "isSucess": isSucess,
//         "message": message,
//         "data": data.toJson(),
//       };
// }

// class Data {
//   List<Header> header;
//   List<Detail> details;

//   Data({
//     required this.header,
//     required this.details,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         header:
//             List<Header>.from(json["header"].map((x) => Header.fromJson(x))),
//         details:
//             List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "header": List<dynamic>.from(header.map((x) => x.toJson())),
//         "details": List<dynamic>.from(details.map((x) => x.toJson())),
//       };
// }

// class Detail {
//   String productId;
//   String productName;
//   String qty;
//   String price;
//   String total;
//   String vat;
//   String unit;
//   String imageUrl;
//   dynamic unitID;
//   dynamic uomCode;
//   String itemStatus;

//   Detail(
//       {required this.productId,
//       required this.productName,
//       required this.qty,
//       required this.price,
//       required this.total,
//       required this.vat,
//       required this.unit,
//       required this.imageUrl,
//       required this.unitID,
//       required this.uomCode,
//       required this.itemStatus});

//   factory Detail.fromJson(Map<String, dynamic> json) => Detail(
//         productId: json["ProductID"].toString(),
//         productName: json["ProductName"].toString(),
//         qty: json["Qty"].toString(),
//         price: json["Price"].toString(),
//         total: json["Total"].toString(),
//         vat: json["Vat"].toString(),
//         unit: json["Unit"].toString(),
//         unitID: json["UnitID"].toString(),
//         imageUrl: json["ImageUrl"].toString(),
//         uomCode: json["UOMCode"].toString(),
//         itemStatus: json["ItemStatus"].toString(),
//       );

//   Map<String, dynamic> toJson() => {
//         "ProductID": productId,
//         "ProductName": productName,
//         "Qty": qty,
//         "Price": price,
//         "Total": total,
//         "Vat": vat,
//         "Unit": unit,
//         "ImageUrl": imageUrl,
//         "UnitID": unitID,
//         "UOMCode": uomCode,
//         "ItemStatus": itemStatus
//       };
// }

// class Header {
  // String orderId;
  // String editNo;
  // String customerId;
  // String customerName;
  // String totalAmount;
  // DateTime orderDate;
  // String totalVat;

//   Header({
//     required this.orderId,
//     required this.editNo,
//     required this.customerId,
//     required this.customerName,
//     required this.totalAmount,
//     required this.orderDate,
//     required this.totalVat,
//   });

//   factory Header.fromJson(Map<String, dynamic> json) => Header(
        // orderId: json["OrderID"].toString(),
        // editNo: json["EditNo"].toString(),
        // customerId: json["CustomerID"].toString(),
        // customerName: json["CustomerName"].toString(),
        // totalAmount: json["TotalAmount"].toString(),
        // orderDate: DateTime.parse(json["OrderDate"]),
        // totalVat: json["TotalVat"].toString(),
//       );

//   Map<String, dynamic> toJson() => {
//         "OrderID": orderId,
//         "EditNo": editNo,
//         "CustomerID": customerId,
//         "CustomerName": customerName,
//         "TotalAmount": totalAmount,
//         "OrderDate": orderDate.toIso8601String(),
//         "TotalVat": totalVat,
//       };
// }
