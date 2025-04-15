

import 'dart:convert';

ProductModel ProductModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String ProductModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
    bool isSucess;
    String message;
    List<ProductData> data;

    ProductModel({
        required this.isSucess,
        required this.message,
        required this.data,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<ProductData>.from(json["data"].map((x) => ProductData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ProductData {
    int productId;

    ProductData({
        required this.productId,
    });

    factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        productId: json["ProductID"],
    );

    Map<String, dynamic> toJson() => {
        "ProductID": productId,
    };
}
