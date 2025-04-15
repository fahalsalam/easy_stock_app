// To parse this JSON data, do
//
//     final bpoListModel = bpoListModelFromJson(jsonString);

import 'dart:convert';

BpoListModel bpoListModelFromJson(String str) =>
    BpoListModel.fromJson(json.decode(str));

String bpoListModelToJson(BpoListModel data) => json.encode(data.toJson());

class BpoListModel {
  bool isSucess;
  String message;
  List<BpoCategoryData> data;

  BpoListModel({
    required this.isSucess,
    required this.message,
    required this.data,
  });

  factory BpoListModel.fromJson(Map<String, dynamic> json) => BpoListModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<BpoCategoryData>.from(
            json["data"].map((x) => BpoCategoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class BpoCategoryData {
  String categoryId;
  String categoryName;
  List<Item> items;

  BpoCategoryData({
    required this.categoryId,
    required this.categoryName,
    required this.items,
  });

  factory BpoCategoryData.fromJson(Map<String, dynamic> json) =>
      BpoCategoryData(
        categoryId: json["categoryID"].toString(),
        categoryName: json["categoryName"].toString(),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categoryID": categoryId,
        "categoryName": categoryName,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  String productId;
  String productName;
  String qty;
  String price;
  String total;
  String uomCode;
  String imageUrl;

  Item({
    required this.productId,
    required this.productName,
    required this.qty,
    required this.price,
    required this.total,
    required this.uomCode,
    required this.imageUrl,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
      productId: json["productID"].toString(),
      productName: json["productName"].toString(),
      qty: json["qty"].toString(),
      price: json["price"].toString(),
      total: json["total"].toString(),
      uomCode: json["uomCode"].toString(),
      imageUrl: json["imageUrl"].toString());

  Map<String, dynamic> toJson() => {
        "productID": productId,
        "productName": productName,
        "qty": qty,
        "price": price,
        "total": total,
        "uomCode": uomCode,
        "imageUrl": imageUrl
      };
}
