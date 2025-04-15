// To parse this JSON data, do
//
//     final itemModel = itemModelFromJson(jsonString);

import 'dart:convert';

import 'package:easy_stock_app/models/purchase_order/productData_model.dart';

ItemModel itemModelFromJson(String str) => ItemModel.fromJson(json.decode(str));

String itemModelToJson(ItemModel data) => json.encode(data.toJson());

class ItemModel {
    bool isSucess;
    String message;
    List<ItemData> data;

    ItemModel({
        required this.isSucess,
        required this.message,
        required this.data,
    });

    factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<ItemData>.from(json["data"].map((x) => ItemData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}
class ItemData {
    int productId;
    String productName;
    String barcode;
    int unit;
    String unitName;
    double price;
    int vat;
    String vatName;
    int category;
    String categoryName;
    String imageUrl;
    String productCode;
    ItemData({
        required this.productId,
        required this.productName,
        required this.barcode,
        required this.unit,
        required this.unitName,
        required this.price,
        required this.vat,
        required this.vatName,
        required this.category,
        required this.categoryName,
        required this.imageUrl,
        required this.productCode
    });

    factory ItemData.fromJson(Map<String, dynamic> json) => ItemData(
        productId: json["ProductID"] ?? 0,
        productName: json["ProductName"] ?? "",
        barcode: json["Barcode"] ?? "",
        unit: json["Unit"] ?? 0,
        unitName: json["UnitName"] ?? "",
        price: json["Price"]?.toDouble() ?? 0.0,
        vat: json["VAT"] ?? 0,
        vatName: json["VAT_Name"] ?? "",
        category: json["Category"] ?? 0,
        categoryName: json["CategoryName"] ?? "",
        imageUrl: json["ImageUrl"] ?? "",
        productCode: json["ProductCode"]??""

    );

    Map<String, dynamic> toJson() => {
        "ProductID": productId,
        "ProductName": productName,
        "Barcode": barcode,
        "Unit": unit,
        "UnitName": unitName,
        "Price": price,
        "VAT": vat,
        "VAT_Name": vatName,
        "Category": category,
        "CategoryName": categoryName,
        "ImageUrl": imageUrl,
        "ProductCode":productCode
    };
    
    // Convert ItemData to ProductDatum
    ProductDatum toProductDatum() {
        return ProductDatum(
            productId: productId.toString(),
            productName: productName,
            
            barcode: barcode,
            unit: unit.toString(),
            price: price.toString(),
            vat: vat.toString(),
            category: category.toString(),
            imageUrl: imageUrl,
            uomCode: unitName, // Map unitName to uomCode
        );
    }
}

// class ItemData {
//     int productId;
//     String productName;
//     String barcode;
//     int unit;
//     String unitName;
//      double price;
//     int vat;
//     String vatName;
//     int category;
//     String categoryName;
//     String imageUrl;

//     ItemData({
//         required this.productId,
//         required this.productName,
//         required this.barcode,
//         required this.unit,
//         required this.unitName,
//         required this.price,
//         required this.vat,
//         required this.vatName,
//         required this.category,
//         required this.categoryName,
//         required this.imageUrl,
//     });

//     factory ItemData.fromJson(Map<String, dynamic> json) => ItemData(
//         productId: json["ProductID"],
//         productName: json["ProductName"],
//         barcode: json["Barcode"],
//         unit: json["Unit"],
//         unitName: json["UnitName"]?? "",
//         price: json["Price"],
//         vat: json["VAT"],
//         vatName: json["VAT_Name"],
//         category: json["Category"],
//         categoryName: json["CategoryName"],
//         imageUrl: json["ImageUrl"],
//     );

//     Map<String, dynamic> toJson() => {
//         "ProductID": productId,
//         "ProductName": productName,
//         "Barcode": barcode,
//         "Unit": unit,
//         "UnitName": unitName,
//         "Price": price,
//         "VAT": vat,
//         "VAT_Name": vatName,
//         "Category": category,
//         "CategoryName": categoryName,
//         "ImageUrl": imageUrl,
//     };
//       // Convert ItemData to ProductDatum
//   ProductDatum toProductDatum() {
//     return ProductDatum(
//       productId: productId.toString(),
//       productName: productName,
//       barcode: barcode,
//       unit: unit.toString(),
//       price: price.toString(),
//       vat: vat.toString(),
//       category: category.toString(),
//       imageUrl: imageUrl,
//       uomCode: unitName, // Map unitName to uomCode
//     );
//   }
// }

