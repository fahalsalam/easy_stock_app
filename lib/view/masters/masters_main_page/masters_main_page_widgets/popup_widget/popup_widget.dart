import 'package:easy_stock_app/view/masters/item_master/add_item/item_master_add_itempage.dart';
import 'package:flutter/material.dart';


import '../../../../../utils/constants/colors/colors.dart';


ItemMasterPopup(BuildContext context, screenHeight, screenWidth) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        // contentPadding: EdgeInsets.zero, // Removes default padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Container(
          padding: EdgeInsets.all(15),
          width: screenWidth * 0.85,
          height: screenHeight * 0.253,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(width: 0.2, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize
                  .min, // Makes the dialog content take only as much space as needed
              children: [
                Padding(
                  padding:
                      const EdgeInsets.all(8.0), // Adds padding around the text
                  child: Text(
                    "SELECT ONE",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //              ItemMasterEditItemPage()));
                  },
                  child: Container(
                    height: screenHeight * 0.055,
                    width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                        child: Text(
                      "Edit",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white),
                    )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ItemMasterAddItemPage()));
                  },
                  child: Container(
                    height: screenHeight * 0.055,
                    width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                        child: Text(
                      "Add",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: primaryColor),
                    )),
                  ),
                )
                // Add additional widgets or buttons here if needed
              ],
            ),
          ),
        ),
      );
    },
  );
}
