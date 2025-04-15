// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class BackgroundImageWidget extends StatelessWidget {
  String image;
   BackgroundImageWidget({super.key,required this.image});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
          height: screenHeight,
          width: screenWidth,
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        );
  }
}