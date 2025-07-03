import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:flutter/material.dart';

// Function for Yes/No Dialog
void yesnoAlertDialog({
  required BuildContext context,
  required String message,
  required double screenHeight,
  required double screenWidth,
  required VoidCallback onYes,
  required VoidCallback onNo,
  required String buttonYesText,
  required String buttonNoText,
  String title1 = '',
  String title2 = '',
}) {
  bool isYesButtonEnabled = true;
  bool isNoButtonEnabled = true;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              width: screenWidth * 0.85,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.95),
                    Colors.white.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with close button
                  Padding(
                    padding: const EdgeInsets.only(top: 16, right: 16),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Icon/Image Section
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor.withOpacity(0.2),
                                primaryColor.withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.help_outline_rounded,
                            size: 40,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Message Text
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        // No/Cancel Button
                        Expanded(
                          child: GestureDetector(
                            onTap: isNoButtonEnabled
                                ? () {
                                    setState(() {
                                      isNoButtonEnabled = false;
                                    });
                                    onNo();
                                  }
                                : null,
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: isNoButtonEnabled
                                    ? Colors.transparent
                                    : Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isNoButtonEnabled
                                      ? Colors.grey.withOpacity(0.4)
                                      : Colors.grey.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  title2 == '' ? 'No' : title2,
                                  style: TextStyle(
                                    color: isNoButtonEnabled
                                        ? Colors.grey[700]
                                        : Colors.grey[400],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Yes/Confirm Button
                        Expanded(
                          child: GestureDetector(
                            onTap: isYesButtonEnabled
                                ? () {
                                    setState(() {
                                      isYesButtonEnabled = false;
                                    });
                                    onYes();
                                  }
                                : null,
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: isYesButtonEnabled
                                    ? LinearGradient(
                                        colors: [
                                          primaryColor,
                                          primaryColor.withOpacity(0.8),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : LinearGradient(
                                        colors: [
                                          Colors.grey.withOpacity(0.5),
                                          Colors.grey.withOpacity(0.3),
                                        ],
                                      ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isYesButtonEnabled
                                    ? [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  title1 == '' ? 'Yes' : title1,
                                  style: TextStyle(
                                    color: isYesButtonEnabled
                                        ? Colors.white
                                        : Colors.grey[400],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// Button Builder for Dialog Buttons (kept for backward compatibility)
Widget buildDialogButton(String buttonText, bool isEnabled) {
  return Container(
    height: 50,
    width: 80,
    decoration: BoxDecoration(
      color: isEnabled ? Colors.black : Colors.grey,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Text(
        buttonText,
        style: const TextStyle(
          color: primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
