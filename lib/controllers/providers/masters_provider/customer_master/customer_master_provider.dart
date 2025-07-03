import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/models/masters/customer_model/customer_model.dart';
import 'package:easy_stock_app/services/api_services/masters/customer_master_apis/customer_master_get_api.dart';
import 'package:easy_stock_app/services/api_services/masters/customer_master_apis/customer_post_api.dart';
import 'package:easy_stock_app/services/api_services/masters/customer_master_apis/customer_put_api.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:flutter/material.dart';

class CustomerManagementProvider with ChangeNotifier {
  TextEditingController customerName = TextEditingController();
  TextEditingController customerID = TextEditingController();
  TextEditingController customerGroup = TextEditingController();

  TextEditingController customerCity = TextEditingController();
  TextEditingController vehicleId_controller = TextEditingController();
  TextEditingController vehicle_controller = TextEditingController();
  TextEditingController customer_controller = TextEditingController();

// edit controllers
  TextEditingController editcustomerNameController = TextEditingController();
  TextEditingController editcustomerIdController = TextEditingController();
  TextEditingController editcustomerCodeController = TextEditingController();
  TextEditingController editcustomerGroupController = TextEditingController();
  TextEditingController editcustomerCityController = TextEditingController();
  TextEditingController editvehicleController = TextEditingController();
  TextEditingController editvehicleIDController = TextEditingController();
  List<CustomerData> data = [];
  List<Map<String, dynamic>> customers = [];
  bool _isLoading = false;
  get isLoading => _isLoading;

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  initializeData(
    String Id,
    String Code,
    String Name,
    String group,
    String city,
  ) {
    editcustomerCodeController.text = Code;
    editcustomerIdController.text = Id;
    editcustomerNameController.text = Name;
    editcustomerGroupController.text = group;
    editcustomerCityController.text = city;
    // editvehicleIDController.text = vehicleID;
  }

  clearEditControllers() {
    editcustomerNameController.clear();
    editcustomerIdController.clear();
    editcustomerCodeController.clear();
    editcustomerGroupController.clear();
    editcustomerCityController.clear();
    editvehicleController.clear();
    editvehicleIDController.clear();
  }

  fetchData() async {
    log("fetchdata-->>");
    var res = await getCustomerMaster();
    if (res != 'Failed') {
      Map<String, dynamic> jsonData = json.decode(res);
      CustomerMasterModel obj = CustomerMasterModel.fromJson(jsonData);
      data = obj.data;
      log("---->>>> customer data len:${data}");
      notifyListeners();
      customers = (jsonData['data'] as List)
          .map<Map<String, dynamic>>((item) => {
                'id': item['CustomerID'].toString(),
                'name': item['CustomerName'].toString(),
              })
          .toList();
    } else {
      data = [];
      notifyListeners();
      return;
    }
    setLoading(false);
    notifyListeners();
  }

  initiliseData() {}
  Future<void> CustomerSave(BuildContext context, vehicleIds) async {
    setLoading(true);
    log('ids: ${vehicleIds}');
    // Log the input fields for debugging
    log("Vehicle ID: ${vehicleId_controller.text}");
    log("Customer Name: ${customerName.text}");
    log("Customer ID: ${customerID.text}");
    log("Customer Group: ${customerGroup.text}");
    log("Customer City: ${customerCity.text}");

    await Future.delayed(const Duration(seconds: 1));

    // Validate required fields
    if (customerName.text.isEmpty) {
      showSnackBarWithsub(
          context, "Please Enter Customer Name", "Error", Colors.red);
      setLoading(false);
      return;
    }

    if (customerID.text.isEmpty) {
      showSnackBarWithsub(
          context, "Please Enter Customer ID", "Error", Colors.red);
      setLoading(false);
      return;
    }

    try {
      // Call the API with customer details
      var res = await customerPostAPI(customerID.text, customerName.text,
          customerGroup.text, customerCity.text, vehicleIds
          // vehicleId_controller.text,
          );

      if (res != 'Failed') {
        clearAll();
        Navigator.pop(context);
        showSnackBar(context, "Customer Added", "Success", Colors.white);
      } else {
        showSnackBar(context, "Please try again!", "Error", Colors.red);
      }
      await fetchData();
    } catch (e) {
      print("Exception caught: $e");
      showSnackBar(
          context, "An error occurred, please try again.", "Error", Colors.red);
    } finally {
      setLoading(false);
    }
  }

  customerEdit(context, Set<int> selectedVehicles) async {
    setLoading(true);

    await Future.delayed(const Duration(seconds: 1));
    if (editcustomerCodeController.text.isEmpty) {
      showSnackBarWithsub(
        context,
        "Please Enter Customer Name",
        "Error",
        Colors.red,
      );
      setLoading(false);
      return; // Exit early if validation fails
    }

    if (editcustomerIdController.text.isEmpty) {
      showSnackBarWithsub(
        context,
        "Please Enter Customer ID",
        "Error",
        Colors.red,
      );
      setLoading(false);
      return; // Exit early if validation fails
    }
    {
      try {
        {
          var res = await updateCustomer(
            customerCode: editcustomerCodeController.text,
            customerName: editcustomerNameController.text,
            group: editcustomerGroupController.text,
            city: editcustomerCityController.text,
            vehicleIds: selectedVehicles,
            //  editvehicleIDController.text,
            customerID: editcustomerIdController.text,
          );
          print("----->>>>> res:$res");
          if (res != 'Failed') {
            clearEditControllers();
            Navigator.pop(context);
            showSnackBar(context, "Customer Updated", "Updated", Colors.white);
          } else {
            showSnackBar(context, "Please try again!", "Error", Colors.red);
          }
        }
      } catch (e) {
        print("caught exception $e");
      }
    }

    setLoading(false);
  }

  clearAll() {
    vehicle_controller.clear();
    vehicleId_controller.clear();
    customerName.clear();
    customerGroup.clear();
    customerCity.clear();
    customerID.clear();
  }
}
