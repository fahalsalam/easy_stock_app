import 'dart:convert';
import 'dart:developer';

import 'package:easy_stock_app/models/masters/uom_master/uom_master_model.dart';
import 'package:easy_stock_app/services/api_services/masters/uom_master_api/uom_master_add_api.dart';
import 'package:easy_stock_app/services/api_services/masters/uom_master_api/uom_master_edit_api.dart';
import 'package:easy_stock_app/services/api_services/masters/uom_master_api/uom_master_get_api.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:flutter/material.dart';

class UomMasterProvider with ChangeNotifier {
  bool isLoading = false;
  final TextEditingController uomProductnameController =
      TextEditingController();
  final TextEditingController uomProductDescriptionController =
      TextEditingController();
  final TextEditingController uomEditProductnameController =
      TextEditingController();
  final TextEditingController uomEditProductDescriptionController =
      TextEditingController();
  Future<void> addFunction(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    log("name: ${uomProductnameController.text}");
    log("desc: ${uomProductDescriptionController.text}");
    if (uomProductDescriptionController.text.isNotEmpty &&
        uomProductnameController.text.isNotEmpty) {
      var res = await uomAddAPI(
        uomCode: uomProductnameController.text,
        uomDescription: uomProductDescriptionController.text,
      );
      log("------>>>>>>>>>>res: $res");
      if (res != 'Failed') {
        isLoading = false;
        uomProductDescriptionController.clear();
        uomProductnameController.clear();
        notifyListeners();

        showSnackBar(
          context,
          "Unit added successfully",
          "Unit Added",
          Colors.white,
        );

        Navigator.pop(context);
      } else {
        showSnackBar(context, "Please try again!", "Error", Colors.red);
        isLoading = false;
        notifyListeners();
      }
    } else {
      showSnackBar(context, "Please fill all the fields", "Error", Colors.red);
      isLoading = false;
      notifyListeners();
    }
  }

  editFunction(uomID, context,) {
    log("name:${uomEditProductnameController.text},des:${uomEditProductDescriptionController.text} ");
    isLoading = true;
    notifyListeners();
    // initialiseData(unitName, unitDesc);
    var res = uomEditAPI(
        uomCode:uomEditProductnameController.text,
        uomDescription: uomEditProductDescriptionController.text,
        uomID: uomID);
    if (res != 'Failed') {
      isLoading = false;

      notifyListeners();
      showSnackBar(context, " ", "Updated", Colors.white);
      uomEditProductDescriptionController.clear();
      uomEditProductnameController.clear();
      Navigator.pop(context);
    } else {
      showSnackBar(context, "Please try again", "Error", Colors.white);
    }
  }

  initialiseData(unitName, unitDesc) {
    uomProductDescriptionController.text = unitDesc;
    uomProductnameController.text = unitName;
    notifyListeners();
  }

  List<UomData> UomList = [];
  Future<void> fetchData() async {
    try {
      var res = await uomGETAPI();
      if (res != 'Failed') {
        Map<String, dynamic> jsonData = json.decode(res);
        UomMasterModel obj = UomMasterModel.fromJson(jsonData);
        UomList = obj.data;
        notifyListeners();
      }
    } catch (e) {
      log("Error fetching data: $e");
    }
  }

 
}
