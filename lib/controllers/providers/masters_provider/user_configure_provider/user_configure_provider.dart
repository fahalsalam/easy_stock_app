import 'dart:convert';
import 'package:easy_stock_app/models/masters/user_master/user_model.dart';
import 'package:easy_stock_app/services/api_services/masters/category_list_api.dart';
import 'package:easy_stock_app/services/api_services/masters/user_master/user_get.dart';
import 'package:easy_stock_app/services/api_services/masters/user_master/user_post.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:flutter/material.dart';

class UserConfigureProvider with ChangeNotifier {
// for selecting index
  int selectedIndex = 0;
  bool _isshowPassword = false;
  bool _isConfirmPassword = false;
  bool get isConfirmPassword => _isConfirmPassword;
  bool get isshowPassword => _isshowPassword;
  String customerName = "";
  String customerID = "";
  bool _isLoading = false;
  get isLoading => _isLoading;
  TextEditingController userCodeController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  void toggleConfirmPasswordVisibility() {
    _isConfirmPassword = !_isConfirmPassword;
    notifyListeners();
  }

  addCustomer(String id, String name) {
    customerID = id;
    customerName = name;
    notifyListeners();
  }

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  removeData() {
    userCodeController.clear();
    userNameController.clear();
    userPasswordController.clear();
    customerID = "";
    customerName = "";
  }

  void togglePasswordVisibility() {
    _isshowPassword = !_isshowPassword;
    notifyListeners();
  }

  selectIndex(index) {
    selectedIndex = index;
    notifyListeners();
  }

  bool _isMasters = false;

  bool get isMasters => _isMasters;
  bool _isPurchase = false;

  bool get isPurchase => _isPurchase;
  bool _isRequest = false;

  bool get isRequest => _isRequest;
  bool _isDriver = false;

  bool get isDriver => _isDriver;
  void toggleMasters() {
    _isMasters = !_isMasters;
    notifyListeners();
  }

  void togglePurchase() {
    _isPurchase = !_isPurchase;
    notifyListeners();
  }

  void toggleRequest() {
    _isRequest = !_isRequest;
    notifyListeners();
  }

  void toggleDriver() {
    _isDriver = !_isDriver;
    notifyListeners();
  }

  List<User> userData = [];
  List<UserCategory> userCategory = [];
  fetchData() async {
    var res = await getUserMaster();
    if (res != 'Failed') {
      Map<String, dynamic> jsonData = json.decode(res);
      UserMasterModel obj = UserMasterModel.fromJson(jsonData);
      print(" Length ${obj.data.users.length}");
      userData = obj.data.users;
      userCategory = obj.data.userCategory;
      notifyListeners();
    } else {
      userData = [];
      notifyListeners();
      return;
    }
  }

  userSave(context) {
    setLoading(true);
    print("-------------->>>>");
    if (isDriver) {
      if (selectedVehicleIds == '') {
        showSnackBar(context, "Please select a vehicle", "Error", Colors.red);
        return;
      }
    }
    // Future.delayed(Duration(seconds: 2));

    var res = postUserMaster(
        userCode: userCodeController.text,
        userName: userNameController.text,
        password: userPasswordController.text,
        defaultCustomer: customerID,
        isPurchase: isMasters,
        isMasters: isPurchase,
        isConsolidate: isRequest,
        isDriver: isDriver,
        category: selectedcategoryIds,
        vehicleID: selectedVehicleIds);

    if (res != 'Failed') {
      clearAll();
      showSnackBar(
          context, "User added successfully", "User Added", Colors.white);
      Navigator.pop(context);
      print("post done");
    } else {
      showSnackBar(context, "Please try again!", "Error", Colors.red);
      Navigator.pop(context);
      print("post Failed");
    }
    setLoading(false);
  }

  clearAll() {
    userCodeController.clear();
    userNameController.clear();
    userPasswordController.clear();
    customerID = "";
    _isMasters = false;
    _isPurchase = false;
    _isRequest = false;
    notifyListeners();
  } // category

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

  String _selectedVehicleIds = '';
  String get selectedVehicleIds => _selectedVehicleIds;

  void selectedVehicles(String vehicleIds) {
    _selectedVehicleIds = vehicleIds;
    notifyListeners();
  }
}
