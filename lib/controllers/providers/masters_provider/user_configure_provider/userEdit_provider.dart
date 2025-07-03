import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/models/masters/user_master/user_model.dart';
import 'package:easy_stock_app/services/api_services/masters/category_list_api.dart';
import 'package:easy_stock_app/services/api_services/masters/user_master/user_put.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:flutter/material.dart';

class UserEditProvider with ChangeNotifier {
  TextEditingController editUserCodeController = TextEditingController();
  TextEditingController editUserNameController = TextEditingController();

  bool _isPurchase = false;
  bool _isConsolidate = false;
  bool _isMasters = false;
  bool _isDriver = false;
  bool _isShowPassword = false;
  String userID = "";
  String customerName = "";
  String customerID = "";
  bool _isLoading = false;
  get isLoading => _isLoading;
  get isPurchase => _isPurchase;
  get isConsolidate => _isConsolidate;
  get isMasters => _isMasters;
  get isDriver => _isDriver;
  get isShowPassword => _isShowPassword;
  String? selectedVehicleId;

  void selectedVehicles(String vehicleId) {
    selectedVehicleId = vehicleId;
    notifyListeners();
  }

  purchaseToggleCheck() {
    _isPurchase = !_isPurchase;
    notifyListeners();
  }

  consolidateToggleCheck() {
    _isConsolidate = !_isConsolidate;
    notifyListeners();
  }

  mastersToggleCheck() {
    _isMasters = !_isMasters;
    notifyListeners();
  }

  DriverToggleCheck() {
    _isDriver = !_isDriver;
    if (_isDriver) {
      customerID = "-1";
      customerName = "";
    }
    notifyListeners();
  }

  togglePasswordVisibility() {
    _isShowPassword = !_isShowPassword;
    notifyListeners();
  }

  initializeData(User data, List<UserCategory> category) {
    log("-->>initialize");
    editUserCodeController.text = data.userCode;
    editUserNameController.text = data.userName;
    _isPurchase = data.isPurchaseRequest;
    _isConsolidate = data.isConsolidatedPurchase;
    _isMasters = data.isMasters;
    _isDriver = data.isDriver == 0 ? false : true;
    userID = data.userId.toString();
    customerID = data.defaultCustomer.toString();
    customerName = data.customerName ?? "";
    selectedVehicleId = data.vehicleId;
    initializeCategory(category, data.userId);
    notifyListeners();
  }

  List<Map<String, String>> mappedCategories = [];
  List<Map<String, String>> initializeCategory(
      List<UserCategory> categories, String userId) {
    // Filter the list for categories that match the given userId
    List<UserCategory> filteredCategories =
        categories.where((category) => category.userId == userId).toList();

    // Convert the filtered list to List<Map<String, String>>
    List<Map<String, String>> mappedcategories = filteredCategories
        .map((category) => {
              "id": category.categoryId,
              "name": category.categoryName,
            })
        .toList();
// mappedCategories=mappedcategories;
// notifyListeners();
    return mappedcategories;
  }

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool validateForm(BuildContext context) {
    if (editUserCodeController.text.trim().isEmpty) {
      showSnackBarWithsub(
        context,
        "User code is required",
        "Validation Error",
        Colors.red,
      );
      return false;
    }

    if (editUserNameController.text.trim().isEmpty) {
      showSnackBarWithsub(
        context,
        "User name is required",
        "Validation Error",
        Colors.red,
      );
      return false;
    }

    if (!isDriver && customerID.isEmpty) {
      showSnackBarWithsub(
        context,
        "Please select a default customer",
        "Validation Error",
        Colors.red,
      );
      return false;
    }

    if (isDriver && selectedVehicleId == null) {
      showSnackBarWithsub(
        context,
        "Please select a vehicle for the driver",
        "Validation Error",
        Colors.red,
      );
      return false;
    }

    return true;
  }

  userEdit(context, mappedCat) async {
    if (!validateForm(context)) {
      return;
    }

    try {
      List<dynamic> mappedCategoryIds = mappedCat.map((category) {
        return int.parse(category['id'].toString());
      }).toList();

      setLoading(true);

      var res = await putUserMaster(
          userCode: editUserCodeController.text,
          userName: editUserNameController.text,
          defaultCustomer: customerID,
          isPurchase: isPurchase,
          isMasters: isMasters,
          isConsolidate: isConsolidate,
          isDriver: isDriver,
          userID: userID,
          category: mappedCategoryIds,
          vehicleID: selectedVehicleId);

      if (res == 'Success') {
        if (context.mounted) {
          showSnackBarWithsub(
            context,
            "User details updated successfully",
            "Success",
            Colors.green,
          );
          Future.delayed(const Duration(milliseconds: 100), () {
            Navigator.of(context).pop(); // Pop back to previous screen
          });
        }
      } else {
        if (context.mounted) {
          showSnackBarWithsub(
            context,
            "Failed to update user details. Please try again.",
            "Error",
            Colors.red,
          );
        }
      }
    } catch (e) {
      print("Error in userEdit: $e");
      if (context.mounted) {
        showSnackBarWithsub(
          context,
          "An unexpected error occurred. Please try again.",
          "Error",
          Colors.red,
        );
      }
    } finally {
      setLoading(false);
    }
  }

// category
  List<Map<String, dynamic>> categoryList = [];
  TextEditingController categoryController = TextEditingController();
  String errorMessage = '';
  String categoryID = "";
  String categoryName = "";
  // Fetch the categories from the API
  Future<void> fetchCategory() async {
    // isLoading = true;
    errorMessage = ''; // Clear previous error message when fetching
    notifyListeners();

    try {
      var res = await CategoryListAPI();
      if (res != 'Failed') {
        Map<String, dynamic> jsonData = json.decode(res);

        // Check if 'data' is available in the response
        if (jsonData['data'] != null) {
          // CategoryListModel obj = CategoryListModel.fromJson(jsonData);
          categoryList = (jsonData['data'] as List)
              .map<Map<String, dynamic>>((item) => {
                    'id': item['CategoryID'].toString(),
                    'name': item['CategoryName'].toString(),
                  })
              .toList();
        } else {
          categoryList = [];
          errorMessage = 'No categories available';
        }
      } else {
        categoryList = [];
        errorMessage = 'Failed to load categories';
      }
    } catch (e) {
      categoryList = [];
      errorMessage = 'An error occurred: ${e.toString()}';
      print('Error fetching category data: $e');
    } finally {
      // isLoading = false;
      notifyListeners();
    }
  }

  List<String> selectedcategoryIds = [];
  selectedCategories(List<String> selecedCategory) {
    selectedcategoryIds = selecedCategory;
    notifyListeners();
  }

  Future<void> updatePassword(String newPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
