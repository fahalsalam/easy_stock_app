import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase/edit_request/order_list/order_list_page.dart';
import 'package:easy_stock_app/view/purchase/history/history_lpo_list/history_lpo_list_page.dart';
import 'package:easy_stock_app/view/purchase/item_list/new_designs/itemlistpage2.dart';
import 'package:easy_stock_app/view/purchase/purchase_mainmenu/purchase_mainmenu_widgets/mainmenu_widgets.dart';
import 'package:flutter/material.dart';
import '../../../utils/common_widgets/background_image_widget.dart';

class PurchaseMainMenuPage extends StatelessWidget {
  const PurchaseMainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

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
            child: CustomAppBar(txt: "BPO Details"),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.14,
              left: 15,
              right: 15,
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListItem(screenHeight, screenWidth, "Add Item Request",
                        onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ItemListPage2()),
                      );
                    }),
                    ListItem(screenHeight, screenWidth, "Edit Request",
                        onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OrderListpage()),
                      );
                    }),
                    ListItem(screenHeight, screenWidth, "Request History",
                        onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HistoryLpoListPage()),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
