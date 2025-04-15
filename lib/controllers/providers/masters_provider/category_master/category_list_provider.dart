// import 'dart:convert';
// import 'package:easy_stock_app/models/masters/category_list_model.dart';
// import 'package:easy_stock_app/services/api_services/masters/category_list_api.dart';
// import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:easy_stock_app/models/masters/category_list_model.dart';
import 'package:easy_stock_app/services/api_services/masters/category_list_api.dart';
import 'package:flutter/material.dart';

class CategoryListProvider with ChangeNotifier {
  List<CategoryData> categoryList = [];
  bool isLoading = false;
  String errorMessage = '';

  // Fetch the categories from the API
  Future<void> fetchCategory() async {
    isLoading = true;
    errorMessage = ''; // Clear previous error message when fetching
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
      isLoading = false;
      notifyListeners();
    }
  }
}

// class CategoryListProvider with ChangeNotifier {
//   List<CategoryData> categoryList = [];
//   bool isLoading = false;
//   String errorMessage = '';

//   Future<void> fetchCategory() async {
//     isLoading = true;
//     errorMessage = ''; // Clear previous error message
//     notifyListeners();

//     try {
//       var res = await CategoryListAPI();
//       if (res != 'Failed') {
//         Map<String, dynamic> jsonData = json.decode(res);
//         CategoryListModel obj = CategoryListModel.fromJson(jsonData);
        
//         print("Category Length ${obj.data.length}");
//         categoryList = obj.data;
//       } else {
//         categoryList = [];
//         errorMessage = 'Failed to load categories';
//       }
//     } catch (e) {
//       categoryList = [];
//       errorMessage = 'An error occurred: ${e.toString()}';
//       print('Error fetching category data: $e');
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }
