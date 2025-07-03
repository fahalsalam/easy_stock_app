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

  // Define route builders instead of static routes
  void _navigateToAddItem(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ItemListPage2(),
        transitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _navigateToEditRequest(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OrderListpage(),
        transitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _navigateToHistory(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HistoryLpoListPage(),
        transitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    // Pre-calculate common padding values
    final topPadding = screenHeight * 0.14;
    final horizontalPadding = 15.0;
    final appBarTopPadding = screenHeight * 0.06;
    final appBarHorizontalPadding = screenWidth * 0.02;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(
            image: common_backgroundImage,
          ),
          Positioned(
            top: appBarTopPadding,
            left: appBarHorizontalPadding,
            right: appBarHorizontalPadding,
            child: CustomAppBar(txt: "Item Request"),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: topPadding,
              left: horizontalPadding,
              right: horizontalPadding,
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListItem(
                      screenHeight,
                      screenWidth,
                      "Add Item Request",
                      onPressed: () => _navigateToAddItem(context),
                    ),
                    ListItem(
                      screenHeight,
                      screenWidth,
                      "Edit Request",
                      onPressed: () => _navigateToEditRequest(context),
                    ),
                    ListItem(
                      screenHeight,
                      screenWidth,
                      "Request History",
                      onPressed: () => _navigateToHistory(context),
                    ),
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
