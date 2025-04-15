// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

Future<String> uploadImageApi({
  required File image,
  required String clientID,
  required String imageClassification,
}) async {
  print("image api call");
  String token =
      'w^0V6jJamvLyaBy5VEYQ2x4gzwrx5BifP6wjB/hQDNmDFSJ2//4/4oze7iJuiFrd';
  String url = 'https://fileserver.sacrosys.net/api/1234/UploadImages';

  try {
    // Create the request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    request.headers.addAll({
      'Token': token,
      'clientID': clientID,
      'imageClassification': imageClassification,
    });
    print("Request Headers: ${request.headers}");

    // Attach image file
    var file = await http.MultipartFile.fromPath(
      'imageFiles', // Field name expected by the API
      image.path,
      filename: basename(image.path), // Use the basename of the file
    );
    request.files.add(file);
    print("Attached file: ${file.filename}");

    // Send the request
    print("Sending request to $url...");
    var response = await request.send();

    // Print status code
    print('Response status code: ${response.statusCode}');

    // Handle the response
    if (response.statusCode == 200) {
      var responseBody = await http.Response.fromStream(response);
      print('Upload successful: ${responseBody.body}');

      // Optionally, parse the response JSON
      var responseData = jsonDecode(responseBody.body);
      print('Parsed response: $responseData');
      return handleResponse(responseBody.body.toString());
    } else {
      print('Upload failed with status: ${response.statusCode}');
      var responseBody = await http.Response.fromStream(response);
      print('Error response: ${responseBody.body}');
      return 'Failed';
    }
  } catch (e) {
    // Catch any error and print the details
    print('An error occurred: $e');
    return 'Failed';
  }
}

String handleResponse(String jsonResponse) {
  // Parse the JSON response
  final Map<String, dynamic> parsedResponse = jsonDecode(jsonResponse);

  // Check if upload was successful
  if (parsedResponse['ImageUploadStatus'] == 'true') {
    // Accessing the 'FileDetails' list
    List<dynamic> fileDetails = parsedResponse['FileDetails'];

    // Fetch the 'FileUrl' from the first file detail
    String fileUrl = fileDetails[0]['FileUrl'];

    // Log the file URL
    print('Uploaded file URL: $fileUrl');
    return fileUrl;
  } else {
    print('File upload failed: ${parsedResponse['Message']}');
    return 'Failed';
  }
}

