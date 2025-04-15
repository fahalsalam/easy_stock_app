import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:flutter/material.dart';


// Function for Yes/No Dialog
void yesnoAlertDialog(
{ 
  required BuildContext context,
required  String message,
required  double screenHeight,
required  double screenWidth,
required  VoidCallback onYes,
required  VoidCallback onNo,
required  String buttonYesText,
 required String buttonNoText,
 String title1='',
 String title2='',
 }
) {
  bool isYesButtonEnabled = true;
  bool isNoButtonEnabled = true;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
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
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [GestureDetector(
                      onTap: isYesButtonEnabled
                          ? () {
                              setState(() {
                                isYesButtonEnabled = false; // Disable button
                              });
                              onYes();
                            }
                          : null,
                      child: buildDialogButton(
                      title1==''?  'Yes':title1,
                        // buttonYesText,
                        isYesButtonEnabled,
                      ),
                    ),
                    GestureDetector(
                      onTap: isNoButtonEnabled
                          ? () {
                              setState(() {
                                isNoButtonEnabled = false; // Disable button
                              });
                              onNo();
                            }
                          : null,
                      child: buildDialogButton(
                         title2==''?   'No':title2,
                        // buttonNoText,
                        isNoButtonEnabled,
                      ),
                    ),
                    
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// Button Builder for Dialog Buttons
Widget buildDialogButton(String buttonText, bool isEnabled) {
  return Container(
    height: 50,
    width: 80,
    decoration: BoxDecoration(
      color: isEnabled ? Colors.black : Colors.grey, // Change color when disabled
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Text(
        buttonText,
        style: const TextStyle(
          color: primaryColor, // Replace with your primaryColor
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
