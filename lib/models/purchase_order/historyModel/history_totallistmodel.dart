// To parse this JSON data, do
//
//     final orderdetailsByidModel = orderdetailsByidModelFromJson(jsonString);

import 'dart:convert';

//  HistoryOrderdetailsByidModel HistoryOrderdetailsByidModelFromJson(String str) =>
//     HistoryOrderdetailsByidModel.fromJson(json.decode(str));

// String HistoryOrderdetailsByidModelToJson(HistoryOrderdetailsByidModel data) =>
//     json.encode(data.toJson());

class HistoryOrderdetailsByidModel {
  bool isSucess;
  String message;
  Data data;

  HistoryOrderdetailsByidModel({
    required this.isSucess,
    required this.message,
    required this.data,
  });

  factory HistoryOrderdetailsByidModel.fromJson(Map<String, dynamic> json) =>
      HistoryOrderdetailsByidModel(
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
  List<HistoryDetailss> details;

  Data({
    required this.header,
    required this.details,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        header:
            List<Header>.from(json["header"].map((x) => Header.fromJson(x))),
        details:
            List<HistoryDetailss>.from(json["details"].map((x) => HistoryDetailss.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "header": List<dynamic>.from(header.map((x) => x.toJson())),
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class HistoryDetailss {
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
  HistoryDetailss(
      {required this.productId,
      required this.productName,
      required this.qty,
      required this.price,
      required this.total,
      required this.vat,
      required this.unit,
      required this.imageUrl,
      required this.unitID,
      required this.uomCode});

  factory HistoryDetailss.fromJson(Map<String, dynamic> json) => HistoryDetailss(
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
        "UOMCode": uomCode
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

  Header({
    required this.orderId,
    required this.editNo,
    required this.customerId,
    required this.customerName,
    required this.totalAmount,
    required this.orderDate,
    required this.totalVat,
  });

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        orderId: json["OrderID"].toString(),
        editNo: json["EditNo"].toString(),
        customerId: json["CustomerID"].toString(),
        customerName: json["CustomerName"].toString(),
        totalAmount: json["TotalAmount"].toString(),
        orderDate: DateTime.parse(json["OrderDate"]),
        totalVat: json["TotalVat"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "OrderID": orderId,
        "EditNo": editNo,
        "CustomerID": customerId,
        "CustomerName": customerName,
        "TotalAmount": totalAmount,
        "OrderDate": orderDate.toIso8601String(),
        "TotalVat": totalVat,
      };
}
