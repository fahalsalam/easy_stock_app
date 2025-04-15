import 'dart:convert';
import 'dart:developer';

import 'package:easy_stock_app/models/purchase_order/bpo_customer_model.dart';
import 'package:easy_stock_app/models/purchase_order/bpo_vehicle_details_model.dart';
import 'package:easy_stock_app/models/purchase_order/vehiclebybpo_model.dart';
import 'package:easy_stock_app/models/purchase_order/vehiclesummarymodel.dart';
import 'package:easy_stock_app/services/api_services/purchase_order/vehicles/bpoCustomer_api.dart';
import 'package:easy_stock_app/services/api_services/purchase_order/vehicles/bpo_vehicledetails_Api.dart';
import 'package:easy_stock_app/services/api_services/purchase_order/vehicles/get_bpo_vehicleapi.dart';
import 'package:easy_stock_app/services/api_services/purchase_order/vehicles/get_product_summary_api.dart';
import 'package:flutter/widgets.dart';

class BpoVehicleProvider with ChangeNotifier {
  List<VehiclebybpoData> data = [];
  fetchData() async {
    log("vehicle by bpo fetchdata-->>");
    var res = await getBpoByVehicles();
    if (res != 'Failed') {
      Map<String, dynamic> jsonData = json.decode(res);
      VehiclebybpoModel obj = VehiclebybpoModel.fromJson(jsonData);
      data = obj.data;

      print("${obj.data.length}");
      notifyListeners();
    } else {
      data = [];
      notifyListeners();
      return;
    }
  }

  List<bpoVehicleDatum> vehicleData = [];
  fetchVehicleData(vehicleID) async {
    log("vehicle by bpo fetchdata-->>");
    var res = await getBpoByVehiclesDetails(vehicleID: vehicleID);
    if (res != 'Failed') {
      Map<String, dynamic> jsonData = json.decode(res);
      BpovehicleDetailsmodel obj = BpovehicleDetailsmodel.fromJson(jsonData);
      vehicleData = obj.data;

      print("${obj.data.length}");
      notifyListeners();
    } else {
      data = [];
      notifyListeners();
      return;
    }
  }

  List<bpoCustomerDatum> customerData = [];
  fetchCustomerData(customerID) async {
    log("---->>>customer  by bpo fetchdata-->>");
    var res = await getBpoBycustomer(customerID: customerID);
    if (res != 'Failed') {
      Map<String, dynamic> jsonData = json.decode(res);
      Bpocustomermodel obj = Bpocustomermodel.fromJson(jsonData);
      customerData = obj.data;

      print(" cus ${obj.data.length}");
      notifyListeners();
    } else {
      data = [];
      notifyListeners();
      return;
    }
  }
List<ProductSummaryDatum> productData = [];
  fetchProductSummary(id) async {
    var res = await getProductSummary(productID: id);

    if (res != 'Failed') {
      Map<String, dynamic> jsonData = json.decode(res);
      ProductSummaryModel obj = ProductSummaryModel.fromJson(jsonData);
     productData = obj.data;

      print(" pro ${obj.data.length}");
      notifyListeners();
    } else {
      data = [];
      notifyListeners();
      return;
    }
  }
}
