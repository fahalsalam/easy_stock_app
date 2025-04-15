import 'package:flutter/material.dart';

class DropdownProvider with ChangeNotifier {
  String? _selectedValue;
  List<String> _items = [];

  String? get selectedValue => _selectedValue;
  List<String> get items => _items;

  void initialize(List<String> items, String? selectedValue) {
    _items = items;
    _selectedValue = selectedValue;
    notifyListeners();
  }

  void setSelectedValue(String? value) {
    _selectedValue = value;
    notifyListeners();
  }
}


// import 'package:flutter/material.dart';

// class DropdownProvider with ChangeNotifier {
//   String? _selectedValue;
//   List<String> _items = [];

//   String? get selectedValue => _selectedValue;
//   List<String> get items => _items;

//   // Initialize only if the provider hasn't been initialized before
//   void initialize(List<String> items, String? selectedValue) {
//     _items = items;
//     _selectedValue = selectedValue;
//     notifyListeners();
//   }

//   void setSelectedValue(String? value) {
//     _selectedValue = value;
//     notifyListeners();
//   }
// }
