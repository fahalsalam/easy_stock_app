// To parse this JSON data, do
//
//     final bpoDetailsModel = bpoDetailsModelFromJson(jsonString);

import 'dart:convert';

BpoDetailsModel bpoDetailsModelFromJson(String str) =>
    BpoDetailsModel.fromJson(json.decode(str));

String bpoDetailsModelToJson(BpoDetailsModel data) =>
    json.encode(data.toJson());

class BpoDetailsModel {
  bool isSucess;
  String message;
  List<BpoDetailsDatum> data;

  BpoDetailsModel({
    required this.isSucess,
    required this.message,
    required this.data,
  });

  factory BpoDetailsModel.fromJson(Map<String, dynamic> json) =>
      BpoDetailsModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<BpoDetailsDatum>.from(
            json["data"].map((x) => BpoDetailsDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BpoDetailsDatum {
  String orderId;
  String customerName;
  String uomCode;
  String qty;
  String total;
  String editNo;
  String imageUrl;
  BpoDetailsDatum(
      {required this.orderId,
      required this.customerName,
      required this.uomCode,
      required this.qty,
      required this.total,
      required this.editNo,
      required this.imageUrl});

  factory BpoDetailsDatum.fromJson(Map<String, dynamic> json) =>
      BpoDetailsDatum(
          orderId: json["OrderID"].toString(),
          customerName: json["CustomerName"].toString(),
          uomCode: json["UOMCode"].toString(),
          qty: json["Qty"].toString(),
          total: json["Total"].toString(),
          editNo: json["EditNo"].toString(),
          imageUrl: json["ImageUrl"].toString());

  Map<String, dynamic> toJson() => {
        "OrderID": orderId,
        "CustomerName": customerName,
        "UOMCode": uomCode,
        "Qty": qty,
        "Total": total,
        "EditNo": editNo,
        "imageUrl": imageUrl
      };
}
