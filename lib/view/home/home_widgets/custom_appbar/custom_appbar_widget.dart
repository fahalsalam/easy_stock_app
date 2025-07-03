import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/view/login/signIn/signIn_page.dart';
import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatelessWidget {
  final String userName;
  const CustomAppBarWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Text(
          //   userName ?? '',
          //   style: TextStyle(
          //     fontWeight: FontWeight.w600,
          //     fontSize: 11,
          //     color: Colors.white,
          //   ),
          // ),
          SizedBox(width: screenWidth * 0.2),
          const Text(
            "Easy Stock",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              yesnoAlertDialog(
                  context: context,
                  message: 'Do you  want to LogOut?',
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  onYes: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                  onNo: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  buttonYesText: 'Yes',
                  buttonNoText: 'No');
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
