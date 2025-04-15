// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<String> deleteImageApi(
    {required String fileName,
    required String classification,
    required String clientId}) async {
  log("image delete api call $fileName");
  Uri url = Uri.parse('https://fileserver.sacrosys.net/api/1234/DeleteImages');
  String token =
      'w^0V6jJamvLyaBy5VEYQ2x4gzwrx5BifP6wjB/hQDNmDFSJ2//4/4oze7iJuiFrd';
  String clientID = clientId;
  String imageClassification = classification;

  final data = {
    "fileNames": [fileName]
  };
  final jsonBody = jsonEncode(data);
  Map<String, String>? headers = {
    'Token': token,
    'clientID': clientID,
    'imageClassification': imageClassification,
    'Content-Type': 'application/json'
  };
  try {
    final response = await http.delete(
      url,
      headers: headers,
      body: jsonBody,
    );

    print('Response status code: ${response.statusCode}');
    print('Response status code: ${response.body}');

    if (response.statusCode == 200) {
      print('Upload successful: ${response.body}');
      return 'Success';
    } else {
      print('Upload failed with status: ${response.statusCode}');
       return 'Failed';
    }
  } catch (e) {
    print('An error occurred: $e');
     return 'Failed';
  }
}
