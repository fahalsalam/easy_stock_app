import 'dart:convert';

BpoPendingModel bpoPendingModelFromJson(String str) =>
    BpoPendingModel.fromJson(json.decode(str));

String bpoPendingModelToJson(BpoPendingModel data) =>
    json.encode(data.toJson());

class BpoPendingModel {
  bool isSucess;
  String message;
  List<PendingData> data;

  BpoPendingModel({
    required this.isSucess,
    required this.message,
    required this.data,
  });

  factory BpoPendingModel.fromJson(Map<String, dynamic> json) =>
      BpoPendingModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<PendingData>.from(
            json["data"].map((x) => PendingData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}


class PendingData {
  String orderId;
  String editNo;
  String customerId;
  String customerName;
  String totalItems;
  String companyname;
  String country;
  String state;
  String trnno;

  PendingData(
      {required this.orderId,
      required this.editNo,
      required this.customerId,
      required this.customerName,
      required this.totalItems,
      required this.companyname,
      required this.state,
      required this.country,
      required this.trnno
      });

  factory PendingData.fromJson(Map<String, dynamic> json) => PendingData(
        orderId: json["OrderID"].toString(),
        editNo: json["EditNo"].toString(),
        customerId: json["CustomerID"].toString(),
        customerName: json["CustomerName"].toString(),
        totalItems: json["TotalItems"].toString(),
        companyname: json["PrintHeader"].toString(),
        country: json["Country"].toString(),
        state: json["State"].toString(),
        trnno: json["TRNNo"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "OrderID": orderId,
        "EditNo": editNo,
        "CustomerID": customerId,
        "CustomerName": customerName,
        "TotalItems": totalItems,
        "PrintHeader": companyname,
        "Country": companyname,
        "State": state,
        "TRNNo": trnno
      };
}
