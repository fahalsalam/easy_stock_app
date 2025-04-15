// To parse this JSON data, do
//
//     final bpocustomermodel = bpocustomermodelFromJson(jsonString);

import 'dart:convert';

Bpocustomermodel bpocustomermodelFromJson(String str) =>
    Bpocustomermodel.fromJson(json.decode(str));

String bpocustomermodelToJson(Bpocustomermodel data) =>
    json.encode(data.toJson());

class Bpocustomermodel {
  bool isSucess;
  String message;
  List<bpoCustomerDatum> data;

  Bpocustomermodel({
    required this.isSucess,
    required this.message,
    required this.data,
  });

  factory Bpocustomermodel.fromJson(Map<String, dynamic> json) =>
      Bpocustomermodel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<bpoCustomerDatum>.from(
            json["data"].map((x) => bpoCustomerDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class bpoCustomerDatum {
  String productId;
  String productName;
  String qty;
  String price;
  String imageUrl;
  String uomCode;
  String vatAmount;
  String orderID;
  bpoCustomerDatum(
      {required this.productId,
      required this.productName,
      required this.qty,
      required this.price,
      required this.imageUrl,
      required this.uomCode,
      required this.vatAmount,
      required this.orderID});

  factory bpoCustomerDatum.fromJson(Map<String, dynamic> json) =>
      bpoCustomerDatum(
          productId: json["ProductID"].toString(),
          productName: json["ProductName"].toString(),
          qty: json["Qty"].toString(),
          price: json["Price"].toString(),
          imageUrl: json["ImageUrl"].toString(),
          uomCode: json["UOMCode"].toString(),
          vatAmount: json["VATAmount"].toString(),
         orderID: json["OrderID"].toString(),
          );
  Map<String, dynamic> toJson() => {
        "ProductID": productId,
        "ProductName": productName,
        "Qty": qty,
        "Price": price,
        "ImageUrl": imageUrl,
        "UOMCode": uomCode,
        "VATAmount":vatAmount,
        "OrderID":orderID
      };
}
