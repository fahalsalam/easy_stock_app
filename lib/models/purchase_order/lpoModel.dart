// To parse this JSON data, do
//
//     final purchaseOrderLpoModel = purchaseOrderLpoModelFromJson(jsonString);

import 'dart:convert';

PurchaseOrderLpoModel purchaseOrderLpoModelFromJson(String str) =>
    PurchaseOrderLpoModel.fromJson(json.decode(str));

String purchaseOrderLpoModelToJson(PurchaseOrderLpoModel data) =>
    json.encode(data.toJson());

class PurchaseOrderLpoModel {
  bool isSucess;
  String message;
  List<lpoDatum> data;

  PurchaseOrderLpoModel({
    required this.isSucess,
    required this.message,
    required this.data,
  });

  factory PurchaseOrderLpoModel.fromJson(Map<String, dynamic> json) =>
      PurchaseOrderLpoModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data:
            List<lpoDatum>.from(json["data"].map((x) => lpoDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class lpoDatum {
  String orderId;
  String editNo;
  String customerId;
  String customerName;
  double totalAmount;
  DateTime orderDate;
  String companyname;
  String country;
  String state;
  String trnno;
  lpoDatum({
    required this.orderId,
    required this.editNo,
    required this.customerId,
    required this.customerName,
    required this.totalAmount,
    required this.orderDate,
    this.companyname = '',
    this.state = '',
    this.country = '',
    this.trnno = '',
  });

  factory lpoDatum.fromJson(Map<String, dynamic> json) => lpoDatum(
        orderId: json["OrderID"].toString(),
        editNo: json["EditNo"].toString(),
        customerId: json["CustomerID"].toString(),
        customerName: json["CustomerName"],
        totalAmount: json["TotalAmount"],
        orderDate: DateTime.parse(json["OrderDate"]),
        companyname: json["PrintHeader"].toString(),
        country: json["Country"].toString(),
        state: json["State"].toString(),
        trnno: json["TRNNo"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "OrderID": orderId,
        "EditNo": editNo,
        "CustomerID": customerId,
        "CustomerName": customerName,
        "TotalAmount": totalAmount,
        "OrderDate": orderDate.toIso8601String(),
        "PrintHeader": companyname,
        "Country": companyname,
        "State": state,
        "TRNNo": trnno
      };
}
