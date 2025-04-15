import 'dart:developer';

import 'package:easy_stock_app/models/purchase/pending/bpo_pending_model.dart';
import 'package:easy_stock_app/models/purchase/pending/pending_details_model.dart';
import 'package:easy_stock_app/services/api_services/purchase_request/pending/pending_api.dart';
import 'package:easy_stock_app/services/api_services/purchase_request/pending/pending_details_api.dart';
import 'package:flutter/material.dart';


class NostockProvider with ChangeNotifier {
 List<PendingData> pendingBPOs = [];
  List<PendingDetailsData> pendingDetails = [];
  bool _isLoading = false;
  // bool _isLoadingDetails = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoadingDetails => _isLoading;
  String? get errorMessage => _errorMessage;
  Future<void> initializeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      BpoPendingModel bpoModel = await getPendingBPO(
        pending: "false", completed: "false", noStock: "true");
      pendingBPOs = bpoModel.data;
       log("pendingBPOs: ${pendingBPOs.length}");
      _errorMessage = null; // Clear previous error
    } catch (e) {
      _errorMessage = e.toString(); // Set error message
      log("Error fetching data: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI to update
    }
  }
   initializeDetails({required String orderID, required String editNo}) async {
    // _isLoadingDetails = true;
    // notifyListeners();

    try {
      BpoPendingDetailsModel bpoModel = await fetchPendingBPODetails(
        pending: 'false',
        completed: 'false',
        noStock: 'true',
        orderID: orderID,
        editNo: editNo,
      );
      pendingDetails = bpoModel.data;
      log("pendingBPOs: ${pendingDetails.length}");
      _errorMessage = null; 
    } catch (e) {
      _errorMessage = e.toString(); 
      log("Error fetching data: $_errorMessage");
    } finally {
      // _isLoadingDetails = false;
      // notifyListeners();
    }
  }
}
