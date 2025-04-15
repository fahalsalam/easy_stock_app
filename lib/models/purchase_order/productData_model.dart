// To parse this JSON data, do
//
//     final productdataList = productdataListFromJson(jsonString);

import 'dart:convert';

import 'package:easy_stock_app/models/purchase_order/lpoModel.dart';

ProductdataList productdataListFromJson(String str) =>
    ProductdataList.fromJson(json.decode(str));

String productdataListToJson(ProductdataList data) =>
    json.encode(data.toJson());

class ProductdataList {
  bool isSucess;
  String message;
  List<ProductDatum> data;

  ProductdataList({
    required this.isSucess,
    required this.message,
    required this.data,
  });

  factory ProductdataList.fromJson(Map<String, dynamic> json) =>
      ProductdataList(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<ProductDatum>.from(
            json["data"].map((x) => ProductDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ProductDatum {
  String productId;
  String productName;
  String barcode;
  String unit;
  String price;
  String vat;
  String category;
  String imageUrl;
  String uomCode;
  ProductDatum(
      {required this.productId,
      required this.productName,
      required this.barcode,
      required this.unit,
      required this.price,
      required this.vat,
      required this.category,
      required this.imageUrl,
      required this.uomCode});

  factory ProductDatum.fromJson(Map<String, dynamic> json) => ProductDatum(
        productId: json["ProductID"].toString(),
        productName: json["ProductName"].toString(),
        barcode: json["Barcode"].toString(),
        unit: json["Unit"].toString(),
        price: json["Price"].toString(),
        vat: json["VAT"].toString(),
        category: json["Category"].toString(),
        imageUrl: json["ImageUrl"].toString(),
        uomCode: json["UOMCode"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "ProductID": productId,
        "ProductName": productName,
        "Barcode": barcode,
        "Unit": unit,
        "Price": price,
        "VAT": vat,
        "Category": category,
        "ImageUrl": imageUrl,
        "UOMCode": uomCode
      };
 

  // Convert to lpoDatum with dynamic data
  lpoDatum toLpoDatum({
    required String customerId,
    required String customerName,
    String editNo = "1",
    DateTime? orderDate,
  }) {
    return lpoDatum(
      orderId: productId,
      editNo: editNo,
      customerId: customerId,
      customerName: customerName,
      totalAmount: double.parse(price),
      orderDate: orderDate ?? DateTime.now(),
    );
  }
}


