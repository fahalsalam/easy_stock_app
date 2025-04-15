import 'package:flutter/material.dart';

Widget buttonCircularIndicator() {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
    child: CircularProgressIndicator(
      color: Colors.white,
      strokeWidth: 5,
    ),
  );
}
