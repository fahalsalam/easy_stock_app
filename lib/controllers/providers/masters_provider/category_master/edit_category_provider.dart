import 'dart:developer';
import 'dart:io';

import 'package:easy_stock_app/services/api_services/image/image_delete_api.dart';
import 'package:easy_stock_app/services/api_services/image/image_upload_api.dart';
import 'package:easy_stock_app/services/api_services/masters/edit_category_api.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/constants/loginConstants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditCategoryProvider with ChangeNotifier {
  String editedCategoryName = "";
  bool _isLoading = false;
  get isLoading => _isLoading;
  bool _isimageLoading = false;
  get isimageLoading => _isimageLoading;
  File? _selectedImage;
  String filename = "";
  File? get selectedImage => _selectedImage;
TextEditingController editCategoryNameController=TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    _setLoading(true);
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      uploadImage(_selectedImage!);
      notifyListeners();
    } else {
      _setLoading(false); // Reset loading state if no file picked
    }
  }

  void removeSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> deleteImage(String url) async {    _setLoading(true);
    List<String> parts = url.split('/');

    String fileName = parts.last;
    print("filename:${fileName}");
    var res =  await deleteImageApi(
        fileName: fileName, classification: 'category', clientId: customerID);
    if (res != 'Failed') {
      removeImage(); // Remove image locally if deletion successful
    } 
     _setLoading(false);
  }

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    _setLoading(true);
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      uploadImage(_selectedImage!);
      notifyListeners();
    } else {
      _setLoading(false); // Reset loading state if no file picked
    }
  }

  void _setLoading(bool value) {
    _isimageLoading = value;
    notifyListeners();
  }
 Future<void> deleteImage1() async {    _setLoading(true);
    List<String> parts = filename.split('/');
    String fileName = parts.last;
    log("Deleting image: $fileName");

    var res = await deleteImageApi(
        fileName: fileName, classification: 'category', clientId: customerID);
    if (res != 'Failed') {
      removeImage(); // Remove image locally if deletion successful
    }    _setLoading(false);
  }
  void removeImage() {
    
    filename = "";
    _selectedImage = null;
    notifyListeners();
  }
  Future<void> uploadImage(File urll) async {
    if (_selectedImage == null) return;
    log("upload Image: ${urll}");
    String res = await uploadImageApi(
        image: urll, clientID: customerID, imageClassification: 'category');
    if (res != 'Failed') {
      extractFileName(res);
    } else {
      log("Image upload failed");
    }

    _setLoading(false);
  }

  void extractFileName(String fileUrl) {
    print('Extracted file name: $fileUrl');
    filename = fileUrl;
    notifyListeners();
  }

  EditCategory({categoryID, categoryName, isActive, context, image}) async {
    setLoading(true);
    await Future.delayed(Duration(seconds: 2));

    var res = EditCategoryAPI(
        categoryID: categoryID,
        categoryName:
            editedCategoryName.isEmpty ? categoryName : editedCategoryName,
        isActive: isActive,
        imageUrl: filename.isEmpty ? image.toString() : filename);
    if (res != 'Failed') {
      showSnackBar(context, "", "Updated", Colors.white);
      Navigator.pop(context);
      setLoading(false);
    } else {
      showSnackBar(context, "Please try again!", "Error", Colors.red);
      setLoading(false);
    }
    // showSnackBar(context, "Please try again!", "Error", Colors.red);
    setLoading(false);
  }
}
