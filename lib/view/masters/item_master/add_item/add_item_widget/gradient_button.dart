import 'package:flutter/material.dart';

Widget gradientElevatedButton({
  required Widget child,
  required VoidCallback onPressed,
  required double width,
  required double height,
}) {
  return InkWell(
    onTap: onPressed, // Handle button tap
    child: Container(
      height: height,
      width: width, // Full width button
      padding: const EdgeInsets.symmetric(vertical: 4), // Button height
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 213, 210, 4),
            Color.fromARGB(255, 210, 136, 0),
          ], // Gradient colors
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(4), // Rounded corners
      ),
      child: Center(
        child: child,
      ),
    ),
  );
}
