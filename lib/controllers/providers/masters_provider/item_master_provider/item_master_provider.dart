import 'dart:convert';

import 'package:easy_stock_app/models/masters/item_model/item_model.dart';
import 'package:easy_stock_app/services/api_services/masters/itemMaster_apis/itemmaster_get_api.dart';
import 'package:flutter/material.dart';

class ItemMasterProvider with ChangeNotifier {
  List<ItemData> itemdata = [];
  fetchData() async {
    var res = await ItemMasterGetAPI(searchText: "null");
    if (res != 'Failed') {
      Map<String, dynamic> jsonData = json.decode(res);
      ItemModel obj = ItemModel.fromJson(jsonData);
      print("Product data Length ${obj.data.length}");
      itemdata = obj.data;
      notifyListeners();
    } else {
      itemdata = [];
      notifyListeners();
      return;
    }
  }
  // search functions

  List<ItemData> _filteredItems = [];

  String _searchQuery = '';

  List<ItemData> get items => _searchQuery.isEmpty ? itemdata : _filteredItems;

  String get searchQuery => _searchQuery;

  void updateSearchQuery(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredItems = [];
    } else {
      _filteredItems = itemdata
          .where((item) =>
              item.productName.toLowerCase().contains(query.toLowerCase()) ||
              item.productCode
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredItems = [];
    notifyListeners();
  }
}
