// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:developer';
import 'package:another_flushbar/flushbar.dart';
import 'package:easy_stock_app/services/api_services/login_api.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/view/home/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider with ChangeNotifier {
  // Controllers for user code, username, and password
  final TextEditingController userCodeController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Password visibility
  bool _obscureText = true;

  bool get obscureText => _obscureText;

  bool isMasters = false;
  bool isOrder = false;
  bool isPurchase = false;

// remember me function
  bool _isRemembered = false;

  bool get isRemembered => _isRemembered;

  void toggleRememberMe(bool value) {
    _isRemembered = value;
    notifyListeners(); // Notifies all listening widgets to rebuild
  }

  void togglePasswordVisibility() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  // Checkbox state
  bool _isChecked = false;

  bool get isChecked => _isChecked;

  void toggle() {
    _isChecked = !_isChecked;
    notifyListeners();
  }

  // Loading state
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Save credentials to device storage
  Future<void> saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('userCode', userCodeController.text);
    if (_isChecked) {
      await prefs.setString('password', passwordController.text);
      await prefs.setBool('isChecked', true);
    } else {
      await prefs.remove('username');
      await prefs.remove('userCode');
      await prefs.remove('password');
      await prefs.setBool('isChecked', false);
    }
  }

  // Load credentials from device storage
  Future<void> loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isChecked = prefs.getBool('isChecked') ?? false;

    if (_isChecked) {
      usernameController.text = prefs.getString('username') ?? '';
      userCodeController.text = prefs.getString('userCode') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
    }
    notifyListeners();
  }

  Future<void> saveLoginDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('userCode', userCodeController.text);
    if (_isRemembered) {
      // Save user credentials to SharedPreferences

      await prefs.setString('password', passwordController.text);
      await prefs.setBool('isRememberMe', true);
    } else {
      // Clear saved credentials if "Remember Me" is unchecked
      await prefs.remove('username');
      await prefs.remove('userCode');
      await prefs.remove('password');
      await prefs.setBool('isRememberMe', false);
    }
  }

  // Simulate an API call (can be replaced with your actual sign-in API call)
  Future<void> signIn(BuildContext context) async {
    setLoading(true); // Show a loading indicator
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('userCode', userCodeController.text);
    try {
      // Await the API call to get the actual String result
      String res = await LoginAPI(
        tenantName: usernameController.text,
        userName: userCodeController.text,
        password: passwordController.text,
      );

      log("login res=$res");

      if (res != 'Failed') {
        // Save credentials if "Remember Me" is checked
        // await saveCredentials();
        if (isRemembered) {
          await saveLoginDetails();
        }

        // Navigate to home page, replacing the current screen
        navigatetoHome(context);
      } else {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          title: "Error",
          titleColor: Colors.red,
          message: "Invalid Login Credentials!",
          duration: Duration(seconds: 3),
        ).show(context);
        // Show an error message if the login failed
        // showSnackBar(context, "Please try again", "Error", Colors.red);
      }
    } catch (e) {
      log("Caught exception: $e");
      showSnackBar(context, "An error occurred. Please try again later.",
          "Error", Colors.red);
    } finally {
      setLoading(false); // Hide the loading indicator
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers
    userCodeController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  authData(bool masterValue, bool orderValue, bool purchaseValue) {
    isMasters = masterValue;
    isOrder = orderValue;
    isPurchase = purchaseValue;
    notifyListeners();
  }

  navigatetoHome(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
}
