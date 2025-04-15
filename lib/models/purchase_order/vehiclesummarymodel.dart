// To parse this JSON data, do
//
//     final productSummaryModel = productSummaryModelFromJson(jsonString);

import 'dart:convert';

ProductSummaryModel productSummaryModelFromJson(String str) => ProductSummaryModel.fromJson(json.decode(str));

String productSummaryModelToJson(ProductSummaryModel data) => json.encode(data.toJson());

class ProductSummaryModel {
    bool isSucess;
    String message;
    List<ProductSummaryDatum> data;

    ProductSummaryModel({
        required this.isSucess,
        required this.message,
        required this.data,
    });

    factory ProductSummaryModel.fromJson(Map<String, dynamic> json) => ProductSummaryModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<ProductSummaryDatum>.from(json["data"].map((x) => ProductSummaryDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ProductSummaryDatum {
    String productId;
     String customerId;
    String productName;
    String customerName;
     String totalQty;

    ProductSummaryDatum({
        required this.productId,
        required this.customerId,
        required this.productName,
        required this.customerName,
        required this.totalQty,
    });

    factory ProductSummaryDatum.fromJson(Map<String, dynamic> json) => ProductSummaryDatum(
        productId: json["ProductID"].toString(),
        customerId: json["CustomerID"].toString(),
        productName: json["ProductName"].toString(),
        customerName: json["CustomerName"].toString(),
        totalQty: json["TotalQty"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "ProductID": productId,
        "CustomerID": customerId,
        "ProductName": productName,
        "CustomerName": customerName,
        "TotalQty": totalQty,
    };
}
