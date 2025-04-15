import 'dart:io';
import 'dart:developer';

import 'package:easy_stock_app/utils/constants/loginConstants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_stock_app/services/api_services/image/image_delete_api.dart';
import 'package:easy_stock_app/services/api_services/image/image_upload_api.dart';

class Vehicleimagepicker extends ChangeNotifier {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String filename = "";
  bool _isLoading = false;

  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;

  // Method to pick image from specified source
  Future<void> pickImage(
      ImageSource source, BuildContext context, String Classification) async {
    _setLoading(true);
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      log("Picked image: ${_selectedImage.toString()}");

      await uploadImage(_selectedImage!, Classification);
    } else {
      _setLoading(false); // Reset loading state if no file picked
    }
  }

  // Method to upload image to the API
  Future<void> uploadImage(File imageFile, String Classification) async {
    if (_selectedImage == null) return;

    log("Uploading image: $imageFile");
    String response = await uploadImageApi(
        image: imageFile,
        imageClassification: Classification,
        clientID: customerID);

    if (response != 'Failed') {
      extractFileName(response);
    } else {
      log("Image upload failed");
    }

    _setLoading(false); // Reset loading state after upload attempt
  }

  // Method to delete image from the server
  Future<void> deleteImage(String url) async {    _setLoading(true);
    List<String> parts = url.split('/');
    String fileName = parts.last;
    log("Deleting image: $fileName");

    var res = await deleteImageApi(
        fileName: fileName, classification: 'products', clientId: customerID);
    if (res != 'Failed') {
      removeImage(); // Remove image locally if deletion successful
    }_setLoading(false);
  }

  Future<void> deleteImage1() async {    _setLoading(true);
    List<String> parts = filename.split('/');
    String fileName = parts.last;
    log("Deleting image: $fileName");

    var res = await deleteImageApi(
        fileName: fileName, classification: 'products', clientId: customerID);
    if (res != 'Failed') {
      removeImage(); // Remove image locally if deletion successful
    }_setLoading(false);
  }

  // Remove image from local selection
  void removeImage() {
    filename = "";
    _selectedImage = null;
    notifyListeners();
  }

  // Extract and save file name from API response URL
  void extractFileName(String fileUrl) {
    filename = fileUrl;
    notifyListeners();
  }

  // Private method to manage loading state and notify listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}



// // Import additional package to format file size if needed
// import 'dart:io';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:easy_stock_app/services/api_services/image/image_delete_api.dart';
// import 'package:easy_stock_app/services/api_services/image/image_upload_api.dart';


// class ImagePickerProvider extends ChangeNotifier {
//   File? _selectedImage;
//   final ImagePicker _picker = ImagePicker();
//   String filename = "";
//   File? get selectedImage => _selectedImage;
//   bool _isLoading = false;
//   get isLoading => _isLoading;

//   Future<void> pickImage(ImageSource source, context) async {
//     _isLoading = true;
//     notifyListeners();
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       File imageFile = File(pickedFile.path);

//       _selectedImage = imageFile;
//       log("Picked image: ${_selectedImage.toString()}");

//       await uploadImage(_selectedImage!);

//       notifyListeners();
//     }
//   }

//   // Function to upload image to the API
//   Future<void> uploadImage(File imageFile) async {
//     if (_selectedImage == null) return;
//     log("Uploading image: $imageFile");
//     String res = await uploadImageApi(imageFile);
//     if (res != 'Failed') {
//       _isLoading = false;
//       notifyListeners();
//     }
//     extractFileName(res);
//   }

//   Future<void> deleteImage(String url) async {
//     List<String> parts = url.split('/');
//     String fileName = parts.last;
//     log("Deleting image: $fileName");
//     await deleteImageApi(fileName);
//   }

//   // Remove image from selection
//   void removeImage() {
//     filename = "";
//     _selectedImage = null;
//     notifyListeners();
//   }

//   // Extract file name from URL
//   void extractFileName(String fileUrl) {
//     filename = fileUrl;
//     notifyListeners();
//   }
// }
