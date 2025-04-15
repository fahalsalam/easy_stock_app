// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:io';
import 'package:easy_stock_app/services/api_services/image/image_delete_api.dart';
import 'package:easy_stock_app/services/api_services/image/image_upload_api.dart';
import 'package:easy_stock_app/services/api_services/masters/add_category_api.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/constants/loginConstants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryProvider with ChangeNotifier {
  File? _selectedImage;
  String? _categoryName;
  String filename = "";
    bool _isimageLoading = false;
  File? get selectedImage => _selectedImage;
  String? get categoryName => _categoryName;
    bool get isimageLoading => _isimageLoading;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  get isLoading => _isLoading;
  TextEditingController categoryNameController=TextEditingController();
  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
     _setLoading(true);
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      log("pickedimage:${_selectedImage.toString()}");
      uploadImage(_selectedImage!);

      notifyListeners();
    }else {
      _setLoading(false); // Reset loading state if no file picked
    }
  }

  removeImage() {
    filename = "";
    _selectedImage = null;
    notifyListeners();
  }

  Future<void> uploadImage(File urll) async {
    if (_selectedImage == null) return;
    log("upload Image: ${urll}");
    String res = await uploadImageApi(image:urll,clientID: customerID,imageClassification: 'category');
   if (res != 'Failed') {
      extractFileName(res);
    } else {
      log("Image upload failed");
    };_setLoading(false);
  }
Future<void> deleteImage1() async {
    List<String> parts = filename.split('/');
    String fileName = parts.last;
    log("Deleting image: $fileName");

    var res = await deleteImageApi(
        fileName: fileName, classification: 'category', clientId: customerID);
    if (res != 'Failed') {
      removeImage(); // Remove image locally if deletion successful
    }
  }
  Future<void> deleteImage(String url) async {
    List<String> parts = url.split('/');

    String fileName = parts.last;
    print("filename:${fileName}");
    await deleteImageApi(fileName:fileName,classification: 'category',clientId: customerID);
  }

  changeLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  void extractFileName(String fileUrl) {
    print('Extracted file name: $fileUrl');
    filename = fileUrl;
    notifyListeners();
  }

  // Pick image from camera
  Future<void> pickImageFromCamera() async { _setLoading(true);
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
     log("pickedimage:${_selectedImage.toString()}");
      uploadImage(_selectedImage!);

      notifyListeners();
    }else {
      _setLoading(false); // Reset loading state if no file picked
    }
  }

  // Set category name
  void setCategoryName(String name) {
    _categoryName = name;
    categoryNameController.text=name;
    notifyListeners();
  }

  // Function to send image URL and category name to API
  Future<String> submitCategory(imageUrl, context) async {
    changeLoading(true);
    print("Category Name: $_categoryName");
    await Future.delayed(const Duration(seconds: 3));
    print("Image Path: ${_selectedImage?.path},imageurl :$imageUrl");
    if (_categoryName!.isEmpty) {
      print("Image or Category Name is missing");
      changeLoading(false);
      showSnackBar(context, "Please fill all the fields", "Error", Colors.red);
      return 'Failed';
    } else {
      var res = AddCategoryAPI(_categoryName, imageUrl);
      if (res != "Failed") {
        showSnackBar(context, "Category added succesfully", "Category Added",
            Colors.white);
        changeLoading(false);
        removeImage();
        Navigator.pop(context);
        return 'Success';
      } else {
        showSnackBar(context, "Please try Again!", "Error", Colors.red);
        changeLoading(false);
        return "Failed";
      }
    }
  }void _setLoading(bool value) {
    _isimageLoading = value;
    notifyListeners();
  }

}
