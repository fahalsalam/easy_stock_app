// Helper method to build content text with consistent style
  import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../utils/constants/colors/colors.dart';

Widget buildContentText(String label, String value, double screenWidth) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(width: screenWidth * 0.08),
      ],
    );
  }