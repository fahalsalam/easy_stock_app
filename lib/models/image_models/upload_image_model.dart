// To parse this JSON data, do
//
//     final uploadImageModel = uploadImageModelFromJson(jsonString);

import 'dart:convert';

UploadImageModel uploadImageModelFromJson(String str) => UploadImageModel.fromJson(json.decode(str));

String uploadImageModelToJson(UploadImageModel data) => json.encode(data.toJson());

class UploadImageModel {
    String imageUploadStatus;
    String message;
    List<FileDetail> fileDetails;

    UploadImageModel({
        required this.imageUploadStatus,
        required this.message,
        required this.fileDetails,
    });

    factory UploadImageModel.fromJson(Map<String, dynamic> json) => UploadImageModel(
        imageUploadStatus: json["ImageUploadStatus"],
        message: json["Message"],
        fileDetails: List<FileDetail>.from(json["FileDetails"].map((x) => FileDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ImageUploadStatus": imageUploadStatus,
        "Message": message,
        "FileDetails": List<dynamic>.from(fileDetails.map((x) => x.toJson())),
    };
}

class FileDetail {
    String slNo;
    String filename;
    String fileUrl;
    String thumbNailFilename;
    String thumbNailFileUrl;

    FileDetail({
        required this.slNo,
        required this.filename,
        required this.fileUrl,
        required this.thumbNailFilename,
        required this.thumbNailFileUrl,
    });

    factory FileDetail.fromJson(Map<String, dynamic> json) => FileDetail(
        slNo: json["Sl No."],
        filename: json["Filename"],
        fileUrl: json["FileUrl"],
        thumbNailFilename: json["ThumbNailFilename"],
        thumbNailFileUrl: json["ThumbNailFileUrl"],
    );

    Map<String, dynamic> toJson() => {
        "Sl No.": slNo,
        "Filename": filename,
        "FileUrl": fileUrl,
        "ThumbNailFilename": thumbNailFilename,
        "ThumbNailFileUrl": thumbNailFileUrl,
    };
}
