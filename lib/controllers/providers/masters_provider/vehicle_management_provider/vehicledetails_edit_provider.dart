
import 'dart:io';
import 'dart:developer';
import 'package:easy_stock_app/models/masters/vehicle_masters/vehicleDetailModel.dart';
import 'package:easy_stock_app/utils/constants/loginConstants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_stock_app/services/api_services/image/image_upload_api.dart';
import 'package:easy_stock_app/services/api_services/image/image_delete_api.dart';
import 'package:easy_stock_app/services/api_services/masters/vehicle_master_apis/put_vehicle_details.dart';

class EditVehicleDetailsProvider with ChangeNotifier {
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController vehicleNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String filename = "";
  bool _isLoading = false;

  File? get selectedImage => _selectedImage;
  bool get isLoading => _isLoading;

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    _setLoading(true);
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      await uploadImage(_selectedImage!);
    } else {
      _setLoading(false);
    }
    notifyListeners();
  }

  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    _setLoading(true);
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      await uploadImage(_selectedImage!);
    } else {
      _setLoading(false);
    }
    notifyListeners();
  }

  // Upload image
  Future<void> uploadImage(File file) async {
    log("Uploading image: $file");
    final res = await uploadImageApi(
      image: file,
      clientID: customerID,
      imageClassification: 'vehicle',
    );
    if (res != 'Failed') {
      extractFileName(res);
    } else {
      log("Image upload failed");
    }
    _setLoading(false);
  }
Future<void> deleteImage1() async {   _setLoading(true);
    List<String> parts = filename.split('/');
    String fileName = parts.last;
    log("Deleting image: $fileName");

    var res = await deleteImageApi(
        fileName: fileName, classification: 'vehicle', clientId: customerID);
    if (res != 'Failed') {
      removeImage(); // Remove image locally if deletion successful
    }   _setLoading(false);
  }

  // Delete image
  Future<void> deleteImage(String url) async {
    final fileName = url.split('/').last;
    log("Deleting image: $fileName");
    final res = await deleteImageApi(
      fileName: fileName,
      classification: 'vehicle',
      clientId: customerID,
    );
    if (res != 'Failed') {
      removeImage();
    } else {
      log("Image deletion failed");
    }
  }

  // Local deletion of selected image
  void removeImage() {
    filename = "";
    _selectedImage = null;
    notifyListeners();
  }

  // Extract and store file name from URL
  void extractFileName(String fileUrl) {
    filename = fileUrl;
    notifyListeners();
  }

  // Edit vehicle details
 editVehicleDetail(
      String vehicleId, String imageUrl, BuildContext context,categorylist)  {
    log("Editing vehicle ID: $vehicleId");
     EditVehicleDetailsAPI(
      vehicleID: vehicleId,
      driverName: driverNameController.text,
      contactNo: contactNumberController.text,
      vehicleName: vehicleNameController.text,
      vehicleNumber: vehicleNumberController.text,
      imgUrl: filename.isEmpty ? imageUrl : filename,
      category:categorylist 
    );
  }

  // Initialize data in controllers
  void initializeData(VehicleDatum data) {
    driverNameController.text = data.driverName;
    vehicleNameController.text = data.vehicleName;
    contactNumberController.text = data.contactNo;
    vehicleNumberController.text = data.vehicleNumber;
  }
}



