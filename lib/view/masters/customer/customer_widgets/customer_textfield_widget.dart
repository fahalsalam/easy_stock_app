









import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors/colors.dart';

class CustomerTextfield extends StatelessWidget {
  final String txt, hintText;
  final Widget suffixIcon;
  final Color color;
  final TextEditingController? controller;
final bool mandatory;
  const CustomerTextfield({
    super.key,
    this.controller,
    this.color = Colors.black,
    required this.txt,
    required this.hintText,
    required this.suffixIcon,
   this.mandatory=false
  });

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: screenHeight * 0.056,
        decoration: BoxDecoration(
          color: color,
          border: Border.all( color:mandatory? Colors.red:Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: TextFormField(
            controller: controller,
            cursorColor: primaryColor,
            style: TextStyle(fontSize: 15, color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
              hintText: hintText,
              suffixIcon: suffixIcon,
              hintStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}



