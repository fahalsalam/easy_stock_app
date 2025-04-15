import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:flutter/material.dart';
import '../../../utils/common_widgets/background_image_widget.dart';
import '../../../utils/constants/colors/colors.dart';


class RequisitionReportPage extends StatelessWidget {
  RequisitionReportPage({super.key});

  // Sample data for demonstration
  final List<double> percentages = [65, 34, 76, 50, 85, 40,90];

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil
   
final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(
            image: common_backgroundImage,
          ),
          Positioned( top: screenHeight * 0.06,
            left: screenWidth * 0.05,
            child: CustomAppBar(
              txt: "Requisition Report ",
            ),
          ),
          Positioned(
        top: screenHeight * 0.142,
            left: screenWidth * 0.08,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Top Requesting Customers",
                  style: TextStyle(
                    fontSize: 16, // Using ScreenUtil for font size
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                SizedBox(
                  height:screenHeight * 0.02,
                ),
                Container(
                  height:screenHeight * 0.28,
                  width:screenWidth * 0.82,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 0.2, color: Colors.white),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            itemCount: percentages
                                .length, // Use the length of the data list
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final percentage = percentages[index];
                             double dynamicHeight = (percentage / 100) * (screenHeight * 0.2); // Calculate dynamic height

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "${percentages[index]}%",
                                    style: TextStyle(
                                      fontSize: 12
                                         , // Using ScreenUtil for font size
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight *.01,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 9.0),
                                    child: Container(
                                      width: 22,
                                      height: dynamicHeight,
                                      // margin: EdgeInsets.only(bottom: 0.h), // Spacing between items
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height:screenHeight* 0.04,
                ),
                Text(
                  "Top",
                  style: TextStyle(
                    fontSize: 16, // Using ScreenUtil for font size
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "TAl Madina Sharjah",
                    style: TextStyle(
                      fontSize: 13, // Using ScreenUtil for font size
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  "Average",
                  style: TextStyle(
                    fontSize: 16, // Using ScreenUtil for font size
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "AL Madina",
                    style: TextStyle(
                      fontSize: 13, // Using ScreenUtil for font size
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  "Need to Improve",
                  style: TextStyle(
                    fontSize: 16, // Using ScreenUtil for font size
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "Taj Al Madina Group",
                    style: TextStyle(
                      fontSize: 13, // Using ScreenUtil for font size
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
