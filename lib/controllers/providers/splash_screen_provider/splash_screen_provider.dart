// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:easy_stock_app/services/api_services/login_api.dart';
import 'package:easy_stock_app/view/home/home.dart';
import 'package:easy_stock_app/view/login/signIn/signIn_page.dart';
import 'package:easy_stock_app/view/splash_screens/welcome_screens/welcome_screen1/welcome_screen1.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:another_flushbar/flushbar.dart';

class SplashProvider extends ChangeNotifier {
  SplashProvider(BuildContext context) {
    navigate(context);
  }

  Future<void> navigate(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isRemembered = prefs.getBool('isRememberMe') ?? false;
    bool? isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    String? username = prefs.getString('username');
    String? userCode = prefs.getString('userCode');
    await Future.delayed(const Duration(seconds: 3));

    // Ensure context is still valid before navigating
    if (!context.mounted) return;

    if (isFirstLaunch) {
      prefs.setBool('isFirstLaunch', false); // Update flag
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen1()),
        );
      }
    } else if (isRemembered) {
      String? password = prefs.getString('password');

      if (username != null && userCode != null && password != null) {
        String res = await LoginAPI(
          tenantName: username,
          userName: userCode,
          password: password,
        );

        if (res != 'Failed') {
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        } else {
          _showErrorFlushbar(context, "Login Failed", "Please try again.");
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignInPage()),
            );
          }
        }
      } else if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      }
    } else if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
  }

  void _showErrorFlushbar(BuildContext context, String title, String message) {
    if (context.mounted) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: title,
        message: message,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.black,
      ).show(context);
    }
  }
}
