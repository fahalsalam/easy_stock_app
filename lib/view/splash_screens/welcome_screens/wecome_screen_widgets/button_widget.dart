import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatelessWidget {
  double screenHeight, screenWidth;
  String txt;
  VoidCallback onPressed;
  ButtonWidget(
      {super.key,
      required this.txt,
      required this.screenHeight,
      required this.screenWidth,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: screenHeight * 0.06,
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange[600]!, Colors.orange[400]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.orangeAccent.withOpacity(0.4),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          // child: Container(
          //   height: screenHeight * 0.058,
          //   width: screenWidth * 0.9,
          //   decoration: BoxDecoration(
          //       gradient: const LinearGradient(colors: [
          //         primaryColor, Colors.orangeAccent,
          //         Colors.orangeAccent,
          //         Color.fromARGB(255, 116, 67, 7)
          //       ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          //       borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Text(
              txt,
              style: TextStyle(
                fontSize: screenHeight * 0.025,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.0, // Modern look for text
              ),
              // style: Textstyle(color: Colors.white,
              //     fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }
}
