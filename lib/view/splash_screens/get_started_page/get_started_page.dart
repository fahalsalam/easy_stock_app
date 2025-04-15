
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/login/signIn/signIn_page.dart';
import 'package:easy_stock_app/view/splash_screens/welcome_screens/wecome_screen_widgets/button_widget.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors/colors.dart';
import '../../../utils/constants/fontStyle/fontstyle.dart';


class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});
 @override
  Widget build(BuildContext context) {
  var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(children: [
        // Background Image
        Container(
          height: screenHeight,
          width: screenWidth,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(loginbackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.08, horizontal: screenWidth * 0.08),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenWidth * 0.07,
                  ),
                  SizedBox(
                    height: screenHeight * 0.1,
                    width: screenWidth * 0.5,
                    child: Image.asset(
                      easystockLogo,
                      fit: BoxFit.cover,
                    ),
                  ),
                  
                ],
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Container(
                height: screenHeight * 0.4,
                width: screenWidth * 0.9,
                // color: Colors.red,
                child: Image.asset(
                 getstarted_Image,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                "Market Analysis and Reserach",
                style: poppins20W400,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Text(
                "We always provide best market analysis \nand research for you ",
                style: poppins12W400,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      height: screenHeight * 0.007,
                      width: screenWidth * 0.09,
                      decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      height: screenHeight * 0.007,
                      width: screenWidth * 0.09,
                      decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      height: screenHeight * 0.007,
                      width: screenWidth * 0.09,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              // button
              ButtonWidget(
                txt: "Get Start",
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignInPage()),
                  );
                },
              )
            ],
          ),
        ),
      ]),
    );
  }
}
