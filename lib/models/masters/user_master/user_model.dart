// To parse this JSON data, do
//
//     final userMasterModel = userMasterModelFromJson(jsonString);

import 'dart:convert';

UserMasterModel userMasterModelFromJson(String str) => UserMasterModel.fromJson(json.decode(str));

String userMasterModelToJson(UserMasterModel data) => json.encode(data.toJson());

class UserMasterModel {
    bool isSucess;
    String message;
    UserData data;

    UserMasterModel({
        required this.isSucess,
        required this.message,
        required this.data,
    });

    factory UserMasterModel.fromJson(Map<String, dynamic> json) => UserMasterModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: UserData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": data.toJson(),
    };
}

class UserData {
    List<User> users;
    List<UserCategory> userCategory;

   UserData({
        required this.users,
        required this.userCategory,
    });

    factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
        userCategory: List<UserCategory>.from(json["userCategory"].map((x) => UserCategory.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "userCategory": List<dynamic>.from(userCategory.map((x) => x.toJson())),
    };
}

class UserCategory {
    String userId;
    String categoryId;
    String categoryName;

    UserCategory({
        required this.userId,
        required this.categoryId,
        required this.categoryName,
    });

    factory UserCategory.fromJson(Map<String, dynamic> json) => UserCategory(
        userId: json["UserID"].toString(),
        categoryId: json["CategoryID"].toString(),
        categoryName: json["CategoryName"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "CategoryID": categoryId,
        "CategoryName": categoryName,
    };
}

class User {
    String userId;
    String userCode;
    String userName;
    String defaultCustomer;
    String customerName;
    bool isPurchaseRequest;
    bool isMasters;
    bool isConsolidatedPurchase;
    int isDriver;

    User({
        required this.userId,
        required this.userCode,
        required this.userName,
        required this.defaultCustomer,
        required this.customerName,
        required this.isPurchaseRequest,
        required this.isMasters,
        required this.isConsolidatedPurchase,
        required this.isDriver,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["UserID"].toString(),
        userCode: json["UserCode"],
        userName: json["UserName"],
        defaultCustomer: json["DefaultCustomer"].toString(),
        customerName: json["CustomerName"],
        isPurchaseRequest: json["IsPurchaseRequest"],
        isMasters: json["IsMasters"],
        isConsolidatedPurchase: json["IsConsolidatedPurchase"],
        isDriver: json["IsDriver"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "UserCode": userCode,
        "UserName": userName,
        "DefaultCustomer": defaultCustomer,
        "CustomerName": customerName,
        "IsPurchaseRequest": isPurchaseRequest,
        "IsMasters": isMasters,
        "IsConsolidatedPurchase": isConsolidatedPurchase,
        "IsDriver": isDriver,
    };
}









// // // To parse this JSON data, do
// // //
// // //     final userMasterModel = userMasterModelFromJson(jsonString);

// // import 'dart:convert';

// // UserMasterModel userMasterModelFromJson(String str) => UserMasterModel.fromJson(json.decode(str));

// // String userMasterModelToJson(UserMasterModel data) => json.encode(data.toJson());

// // class UserMasterModel {
// //     bool isSucess;
// //     String message;
// //     List<UserData> data;

// //     UserMasterModel({
// //         required this.isSucess,
// //         required this.message,
// //         required this.data,
// //     });

// //     factory UserMasterModel.fromJson(Map<String, dynamic> json) => UserMasterModel(
// //         isSucess: json["isSucess"],
// //         message: json["message"],
// //         data: List<UserData>.from(json["data"].map((x) => UserData.fromJson(x))),
// //     );

// //     Map<String, dynamic> toJson() => {
// //         "isSucess": isSucess,
// //         "message": message,
// //         "data": List<dynamic>.from(data.map((x) => x.toJson())),
// //     };
// // }

// // class UserData {
// //     int userId;
// //     String userCode;
// //     String userName;
// //     int defaultCustomer;
// //     bool isPurchaseRequest;
// //     bool isMasters;
// //    int isDriver;
// //     bool isConsolidatedPurchase;
// //     String customerName;

// //     UserData({
// //       required this.customerName,
// //         required this.userId,
// //         required this.userCode,
// //         required this.userName,
// //         required this.defaultCustomer,
// //         required this.isPurchaseRequest,
// //         required this.isMasters,
// //         required this.isConsolidatedPurchase,
// //         required this.isDriver
// //     });

// //     factory UserData.fromJson(Map<String, dynamic> json) => UserData(
// //         userId: json["UserID"],
// //         userCode: json["UserCode"],
// //         userName: json["UserName"],
// //         defaultCustomer: json["DefaultCustomer"],
// //         isPurchaseRequest: json["IsPurchaseRequest"],
// //         isMasters: json["IsMasters"],
// //         isConsolidatedPurchase: json["IsConsolidatedPurchase"],
// //         customerName: json["CustomerName"],
// //         isDriver: json["IsDriver"]    );

// //     Map<String, dynamic> toJson() => {
// //         "UserID": userId,
// //         "UserCode": userCode,
// //         "UserName": userName,
// //         "DefaultCustomer": defaultCustomer,
// //         "IsPurchaseRequest": isPurchaseRequest,
// //         "IsMasters": isMasters,
// //         "IsConsolidatedPurchase": isConsolidatedPurchase,
// //         "CustomerName":customerName,
// //         "IsDriver":isDriver
// //     };
// // }
