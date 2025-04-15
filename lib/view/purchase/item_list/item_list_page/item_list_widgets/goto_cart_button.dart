import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GotoCartButton extends StatelessWidget {
  double screenHeight, screenWidth;
  String txt;
  int length;
  VoidCallback onPressed;

  GotoCartButton({
    super.key,
    required this.txt,
    required this.length,
    required this.screenHeight,
    required this.screenWidth,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.orange, Colors.deepOrange],
          ),
          borderRadius:
              BorderRadius.circular(20), // Rounded edges for the button
        ),
        child: Center(
          child: Text(
            '$txt ($length)',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16, // Increased font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
