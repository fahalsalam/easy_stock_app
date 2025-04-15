// To parse this JSON data, do
//
//     final productMasterLoadModel = productMasterLoadModelFromJson(jsonString);

import 'dart:convert';

ProductMasterLoadModel productMasterLoadModelFromJson(String str) => ProductMasterLoadModel.fromJson(json.decode(str));

String productMasterLoadModelToJson(ProductMasterLoadModel data) => json.encode(data.toJson());

class ProductMasterLoadModel {
    bool isSucess;
    String message;
    Data data;

    ProductMasterLoadModel({
        required this.isSucess,
        required this.message,
        required this.data,
    });

    factory ProductMasterLoadModel.fromJson(Map<String, dynamic> json) => ProductMasterLoadModel(
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
    List<Category> categories;
    List<Tax> tax;
    List<Uom> uom;

    Data({
        required this.categories,
        required this.tax,
        required this.uom,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        tax: List<Tax>.from(json["tax"].map((x) => Tax.fromJson(x))),
        uom: List<Uom>.from(json["uom"].map((x) => Uom.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "tax": List<dynamic>.from(tax.map((x) => x.toJson())),
        "uom": List<dynamic>.from(uom.map((x) => x.toJson())),
    };
}

class Category {
    int categoryId;
    String categoryName;

    Category({
        required this.categoryId,
        required this.categoryName,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["CategoryID"],
        categoryName: json["CategoryName"],
    );

    Map<String, dynamic> toJson() => {
        "CategoryID": categoryId,
        "CategoryName": categoryName,
    };
}

class Tax {
    int taxSlabId;
    String slabType;

    Tax({
        required this.taxSlabId,
        required this.slabType,
    });

    factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        taxSlabId: json["TaxSlabID"],
        slabType: json["SlabType"],
    );

    Map<String, dynamic> toJson() => {
        "TaxSlabID": taxSlabId,
        "SlabType": slabType,
    };
}

class Uom {
    int uomid;
    String uomCode;
    String uomDescription;

    Uom({
        required this.uomid,
        required this.uomCode,
        required this.uomDescription,
    });

    factory Uom.fromJson(Map<String, dynamic> json) => Uom(
        uomid: json["UOMID"]??0,
        uomCode: json["UOMCode"]??'',
        uomDescription: json["UOMDescription"]??'',
    );

    Map<String, dynamic> toJson() => {
        "UOMID": uomid,
        "UOMCode": uomCode,
        "UOMDescription": uomDescription,
    };
}
