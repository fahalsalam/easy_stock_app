// ignore_for_file: unused_local_variable

import 'package:easy_stock_app/utils/constants/colors/colors.dart';


import 'package:flutter/material.dart';

void CustomAlertDialog(
    BuildContext context,
     String txt, double screenHeight, double screenWidth,
     VoidCallback onPressed1,String button1,
   ) {
  Widget okButton = GestureDetector(
    onTap: onPressed1,
    child: Container(
      height: 50,
      width: 80,
      decoration: BoxDecoration(
          color: Colors.black,
          // border: Border.all(width: 1, color: primaryColor),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Text(button1,
            // "Ok",
            style: TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ),
  );

//  Widget backtomenuButton = TextButton(
//   child: Text(
//     button2,
//     // "Back to menu",
//     style: Textstyle(
//       color: Colors.white,
//       fontSize: 12,
//       fontWeight: FontWeight.w400,
//     ),
//   ),
//   onPressed: onPressed2
// );
//  Widget backtomenuButton = GestureDetector(
//     onTap: onPressed2,
//     child: Container(
//       height: 50,
//       width: 80,
//       decoration: BoxDecoration(
//           color: Colors.black,
//           border: Border.all(width: 1, color: primaryColor),
//           borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Center(
//           child: Text(button2,
//             // "Ok",
//             style: Textstyle(
//               color: primaryColor,
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ),
//     ),
//   );

  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    backgroundColor: Colors.white.withOpacity(0.6),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 25,
                    color: Colors.black,
                  ))
            ],
          ),
          SizedBox(
            height: screenHeight * 0.2,
            width: screenWidth * 0.8,
            child: Image.asset('assets/images/alert_box_image.png'),
          ),
          const SizedBox(height: 10),
          Text(
            txt,
            textAlign: TextAlign.center,
            style:TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
               okButton,
              //  backtomenuButton,
            ],
          ),
         
        ],
      ),
    ),
  );

  // Show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
