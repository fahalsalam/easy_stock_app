// ignore_for_file: non_constant_identifier_names

import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase/purchase_mainmenu/purchase_mainmenu_widgets/mainmenu_widgets.dart';
import 'package:easy_stock_app/view/report/overall_bussiness_configure/user_configure_page.dart';
import 'package:easy_stock_app/view/report/purchase_report/purchase_report_page.dart';
import 'package:flutter/material.dart';
import '../../../utils/common_widgets/background_image_widget.dart';
import '../requisition_report/requisition_report_page.dart';
import '../stock_order_report/stock_order_report_page.dart';

class ReportMainMenuPage extends StatelessWidget {
  const ReportMainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // Access SplashProvider to trigger navigation after a delay

    return Scaffold(
        body: Stack(
      children: [
        BackgroundImageWidget(
          image: common_backgroundImage,
        ),
        Positioned(
          top: screenHeight * 0.06,
          left: screenWidth * 0.02,
          right: screenWidth * 0.02,
          child: CustomAppBar(txt: "Report"),
        ),
        Padding(
          padding:
              EdgeInsets.only(top: screenHeight * 0.142, left: 15, right: 15),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListItem(screenHeight, screenWidth, "Purchase Report",
                      onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PurchaseReportPage()));
                  }),
                  ListItem(screenHeight, screenWidth, "Requisition Report ",
                      onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequisitionReportPage()));
                  }),
                  ListItem(screenHeight, screenWidth, "Stock Report",
                      onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StockOrderReportPage()));
                  }),
                  ListItem(screenHeight, screenWidth, "Overall Business Report",
                      onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserConfigurePage()));
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
