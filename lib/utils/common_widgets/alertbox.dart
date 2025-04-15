// ignore_for_file: unused_local_variable

import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:flutter/material.dart';

void showAlertDialog(
    BuildContext context, String txt, double screenHeight, double screenWidth,VoidCallback onPressed) {
  Widget okButton = GestureDetector(
    onTap: onPressed,
    child: Container(
      height: 50,
      width: 80,
      decoration: BoxDecoration(
          color: Colors.black,
          // border: Border.all(width: 1, color: primaryColor),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "Ok",
            style: TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ),
  );

 Widget backtomenuButton = TextButton(
  child: Text(
    "Back to menu",
    style: TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  ),
  onPressed: () {
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomePage()),
    //   (Route<dynamic> route) => false, // Remove all previous routes
    // );
  },
);


  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    backgroundColor: Colors.white.withOpacity(0.6),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 25,
                    color: Colors.black,
                  ))
            ],
          ),
          SizedBox(
            height: screenHeight * 0.2,
            width: screenWidth * 0.8,
            child: Image.asset('assets/images/alert_box_image.png'),
          ),
          const SizedBox(height: 10),
          Text(
            txt,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          // backtomenuButton,
          okButton
        ],
      ),
    ),
  );

  // Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
// okalert box
void okAlertDialog(
  BuildContext context,
  String message,
  double screenHeight,
  double screenWidth,
  VoidCallback onOk,
  String buttonText,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.white.withOpacity(0.8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.black, size: 25),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.2,
              width: screenWidth * 0.8,
              child: Image.asset('assets/images/alert_box_image.png'),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // OK Button
            Center(
              child: buildDialogButton(buttonText, onOk),
            ),
          ],
        ),
      );
    },
  );
}

// Button Builder for OK Dialog Button
Widget buildDialogButton(String buttonText, VoidCallback onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      height: 50,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          buttonText,
          style:TextStyle(
            color: primaryColor, // Replace with primaryColor as needed
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
  );
}
