import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/models/masters/item_model/item_model.dart';
import 'package:easy_stock_app/models/purchase_order/lpoModel.dart';
import 'package:easy_stock_app/models/purchase_order/order_details_model.dart';
import 'package:easy_stock_app/services/api_services/masters/itemMaster_apis/itemmaster_get_api.dart';
import 'package:easy_stock_app/services/api_services/purchase_order/edit_purchase_order_api.dart';
import 'package:easy_stock_app/services/api_services/purchase_order/get_purchase_order_api.dart';
import 'package:easy_stock_app/services/api_services/purchase_order/po/get_po_order_api.dart';
import 'package:easy_stock_app/services/api_services/purchase_order/purchase_order_details_byid.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:flutter/material.dart';

class PoProvider with ChangeNotifier {
  String CustmrID = "";
  String CustmrName = "";
  List<lpoDatum> lpoData = [];
  TextEditingController searchController = TextEditingController();
  // Fetch purchase order data
   String companyname='';
  String country='';
  String state='';
  String trnno='';
  fetchData() async {
    try {
      var res = await getPoApi();
      if (res != 'Failed') {
        Map<String, dynamic> jsonData = json.decode(res);
        PurchaseOrderLpoModel obj = PurchaseOrderLpoModel.fromJson(jsonData);
        print("lpo Length ${obj.data.length}");
        lpoData = obj.data;
            if(obj.data.isNotEmpty){
companyname=obj.data.first.companyname;
country=obj.data.first.country;
state=obj.data.first.state;
trnno=obj.data.first.trnno;
      }
        notifyListeners();
      } else {
        lpoData = [];
        notifyListeners();
        return;
      }
    } catch (e) {
      log("Error fetching data: $e");
      lpoData = [];
      notifyListeners();
    }
  }


}
