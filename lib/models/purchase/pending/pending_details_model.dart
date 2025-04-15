// To parse this JSON data, do
//
//     final bpoPendingDetailsModel = bpoPendingDetailsModelFromJson(jsonString);

import 'dart:convert';

BpoPendingDetailsModel bpoPendingDetailsModelFromJson(String str) =>
    BpoPendingDetailsModel.fromJson(json.decode(str));

String bpoPendingDetailsModelToJson(BpoPendingDetailsModel data) =>
    json.encode(data.toJson());

class BpoPendingDetailsModel {
  bool isSucess;
  String message;
  List<PendingDetailsData> data;

  BpoPendingDetailsModel({
    required this.isSucess,
    required this.message,
    required this.data,
  });

  factory BpoPendingDetailsModel.fromJson(Map<String, dynamic> json) =>
      BpoPendingDetailsModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<PendingDetailsData>.from(
            json["data"].map((x) => PendingDetailsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PendingDetailsData {
  String productId;
  String productName;
  String vat;
  String qty;
  String price;
  String imageUrl;
  String uomCode;
  PendingDetailsData(
      {required this.productId,
      required this.productName,
      required this.qty,
      required this.vat,
      required this.price,
      required this.imageUrl,
      required this.uomCode});

  factory PendingDetailsData.fromJson(Map<String, dynamic> json) =>
      PendingDetailsData(
        productId: json["ProductID"].toString(),
        productName: json["ProductName"].toString(),
        qty: json["Qty"].toString(),
        price: json["Price"].toString(),
        uomCode: json["UOMCode"].toString(),
        imageUrl: json["ImageUrl"] ?? "null",
        vat:json["VAT"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "ProductID": productId,
        "ProductName": productName,
        "Qty": qty,
        "Price": price,
        "ImageUrl": imageUrl,
        "UOMCode": uomCode,
        "VAT":vat
      };
}
