import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:flutter/material.dart';




Future<String?> showAlertBoxWithTextField(BuildContext context) async {
  TextEditingController textController =
      TextEditingController(); // Controller for TextField

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey.withOpacity(0.5),
        content: TextField(
          controller: textController,
          cursorColor: primaryColor, // Change cursor color
          style: TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: '',
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.grey, width: 2.0), // Border when not focused
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: primaryColor, width: 2.0), // Border when focused
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              Navigator.of(context).pop(null); // Return null if canceled
            },
          ),
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              String enteredText = textController.text;
              Navigator.of(context).pop(enteredText); // Return the entered text
            },
          ),
        ],
      );
    },
  );
}



