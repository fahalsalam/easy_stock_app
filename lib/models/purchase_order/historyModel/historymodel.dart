// To parse this JSON data, do
//
//     final historyModel = historyModelFromJson(jsonString);

import 'dart:convert';

HistoryModel historyModelFromJson(String str) => HistoryModel.fromJson(json.decode(str));

String historyModelToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel {
    bool isSucess;
    String message;
    List<HistoryDatum> data;

    HistoryModel({
        required this.isSucess,
        required this.message,
        required this.data,
    });

    factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        isSucess: json["isSucess"],
        message: json["message"],
        data: List<HistoryDatum>.from(json["data"].map((x) => HistoryDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSucess": isSucess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class HistoryDatum {
    String timeRange;
    List<HistoryRecord> records;

    HistoryDatum({
        required this.timeRange,
        required this.records,
    });

    factory HistoryDatum.fromJson(Map<String, dynamic> json) => HistoryDatum(
        timeRange: json["timeRange"],
        records: List<HistoryRecord>.from(json["records"].map((x) => HistoryRecord.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "timeRange": timeRange,
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
    };
}

class HistoryRecord {
    String customerName;
    String orderId;
   String editNo;

    HistoryRecord({
        required this.customerName,
        required this.orderId,
        required this.editNo,
    });

    factory HistoryRecord.fromJson(Map<String, dynamic> json) => HistoryRecord(
        customerName: json["customerName"],
        orderId: json["orderID"].toString(),
        editNo: json["editNo"].toString(),
    );

    Map<String, dynamic> toJson() => {
        "customerName": customerName,
        "orderID": orderId,
        "editNo": editNo,
    };
}
