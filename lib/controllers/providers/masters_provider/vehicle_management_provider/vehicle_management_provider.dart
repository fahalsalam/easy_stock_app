import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/models/masters/category_list_model.dart';
import 'package:easy_stock_app/models/masters/vehicle_masters/vehicleDetailModel.dart';
import 'package:easy_stock_app/services/api_services/masters/category_list_api.dart';
import 'package:easy_stock_app/services/api_services/masters/vehicle_master_apis/get_vehicle_details.dart';
import 'package:easy_stock_app/services/api_services/masters/vehicle_master_apis/vehicle_details_save_api.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VehicleManagementProvider with ChangeNotifier {
  XFile? _selectedImage;
  bool isLoading = false;
  XFile? get selectedImage => _selectedImage;

  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController vehicleNameControler = TextEditingController();
  TextEditingController vehicleContactController = TextEditingController();
  TextEditingController driverContactController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();
  List<VehicleDatum> data = [];

  List<Map<String, dynamic>> vehicles = [];
  List<VehicleDatum> vehicleList = [];
  fetchData() async {
    log("fetchdata-->>");
    var res = await vehicleMasterGetAPI();

    if (res != 'Failed') {
      Map<String, dynamic> jsonData = json.decode(res);
      VehicleMastermodel obj = VehicleMastermodel.fromJson(jsonData);
      data = obj.data;

      // Only try to access data if it's not empty
      if (data.isNotEmpty) {
        log("First vehicle ID: ${obj.data.first.vehicleId}");
      }

      notifyListeners();

      // Update vehicles list only if there's data
      if (jsonData['data'] != null && jsonData['data'] is List) {
        vehicles = (jsonData['data'] as List)
            .map<Map<String, dynamic>>((item) => {
                  'id': item['vehicleID'].toString(),
                  'name': item['vehicleName'].toString(),
                })
            .toList();
        vehicleList = obj.data;
      } else {
        vehicles = [];
        vehicleList = [];
      }
    } else {
      data = [];
      vehicles = [];
      vehicleList = [];
      notifyListeners();
    }
  }

  initialiseData() {
    clearAll();
    clearImage();
    fetchCategory();
  }

  vehicleSave(String? url, context, selectedCategory) async {
    setLoading(true);
    log("number:${{vehicleNumberController.text}}");
    log("name:${{vehicleNameControler.text}}");
    log("contact:${{vehicleContactController.text}}");
    log("filename: $url");
    await Future.delayed(const Duration(seconds: 3));
    try {
      var res = await AddVehileDetailsAPI(
          vehicleName: vehicleNameControler.text,
          vehicleNumber: vehicleNumberController.text,
          contactNo: vehicleContactController.text,
          imageUrl: url,
          driverName: driverContactController.text,
          category: selectedCategory);

      if (res != 'Failed') {
        showSnackBar(context, "", "Saved", Colors.white);
        clearAll();
        Navigator.pop(context);
      } else {
        showSnackBar(context, "Please try again!", "Error", Colors.red);
      }
    } catch (e) {
      print("Exception caught $e");
    }
    setLoading(false);
  }

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  clearAll() {
    vehicleContactController.clear();
    vehicleNumberController.clear();
    driverContactController.clear();
    vehicleNameControler.clear();
  }

  // Function to pick an image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedImage = await _picker.pickImage(source: source);

      if (pickedImage != null) {
        _selectedImage = pickedImage;
        notifyListeners(); // Notify listeners to update the UI
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Function to clear the selected image
  void clearImage() {
    _selectedImage = null;
    notifyListeners();
  }

  // --
// for selecting index
  int selectedIndex = 0;

  selectIndex(index) {
    selectedIndex = index;
    notifyListeners();
  }

  List<CategoryData> categoryList = [];
  Future<void> fetchCategory() async {
    isLoading = true;
    categoryList = [];
    // Clear previous error message when fetching
    notifyListeners();

    try {
      var res = await CategoryListAPI();
      if (res != 'Failed') {
        Map<String, dynamic> jsonData = json.decode(res);

        // Check if 'data' is available in the response
        if (jsonData['data'] != null) {
          CategoryListModel obj = CategoryListModel.fromJson(jsonData);
          categoryList = obj.data;
        } else {
          categoryList = [];
        }
      } else {
        categoryList = [];
      }
    } catch (e) {
      categoryList = [];

      print('Error fetching category data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
