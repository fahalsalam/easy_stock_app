

import 'dart:convert';

CategoryListModel categoryListModelFromJson(String str) => CategoryListModel.fromJson(json.decode(str));

String categoryListModelToJson(CategoryListModel data) => json.encode(data.toJson());

class CategoryListModel {
    bool isSucess;
    String message;
    List<CategoryData> data;

    CategoryListModel({
        required this.isSucess,
        required this.message,
        required this.data,
    });

    factory CategoryListModel.fromJson(Map<String, dynamic> json) => CategoryListModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<CategoryData>.from(json["data"].map((x) => CategoryData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class CategoryData {
    int categoryId;
    String categoryName;
    String imageUrl;
    bool isActive;

    CategoryData({
        required this.categoryId,
        required this.categoryName,
        required this.imageUrl,
        required this.isActive,
    });

    factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        categoryId: json["CategoryID"],
        categoryName: json["CategoryName"]??"",
        imageUrl: json["ImageUrl"]??"",
        isActive: json["IsActive"]??"",
    );

    Map<String, dynamic> toJson() => {
        "CategoryID": categoryId,
        "CategoryName": categoryName,
        "ImageUrl": imageUrl,
        "IsActive": isActive,
    };
}
