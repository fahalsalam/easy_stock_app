import 'package:flutter/material.dart';

ListItem(screenHeight, screenWidth, txt, {onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      height: screenHeight * 0.052,
      width: screenWidth * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.5, color: Colors.white.withOpacity(0.5)),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        txt,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    ),
  );
}
