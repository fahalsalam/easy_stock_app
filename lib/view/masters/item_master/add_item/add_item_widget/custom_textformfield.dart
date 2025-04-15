import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors/colors.dart';

class CustomTextfield extends StatelessWidget {
  final String txt;
  final String hintText;
  final Widget suffixIcon;
  final Color color;
  final TextEditingController? controller;
  final bool mandatory;
  final String? initialValue;
  final Function(String)? onChanged;
  final TextInputType textInput;

  CustomTextfield({
    super.key,
    required this.txt,
    required this.hintText,
    required this.suffixIcon,
    this.color = Colors.black,
    this.initialValue,
    this.onChanged,
    this.controller,
    this.mandatory = false,
    this.textInput=TextInputType.text
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Text(
            txt,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: color,
            border: mandatory
                ? Border.all(
                    width: 1.5,
                    color: Colors.red,
                  )
                : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            keyboardType: textInput,
            controller: controller,
            initialValue: initialValue,
            cursorColor: primaryColor,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
              hintText: hintText,
              suffixIcon: suffixIcon,
              hintStyle: const TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
