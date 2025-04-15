import 'package:easy_stock_app/utils/token_manager/token_manager.dart';
import 'package:flutter/material.dart';

class HomepageProvider with ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  String message = '';

  // Constructor that calls an initialization function
  HomePageProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    TokenManager tokenobj= TokenManager();
    tokenobj.getAccessToken();
  }
}
