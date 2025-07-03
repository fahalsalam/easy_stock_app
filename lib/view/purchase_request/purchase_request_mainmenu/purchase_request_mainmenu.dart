import 'dart:ui';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase_request/Bpo/bpo_itemList_page.dart';
import 'package:easy_stock_app/view/purchase_request/Lpo/lpo_list_page.dart';
import 'package:easy_stock_app/view/purchase_request/no_stock/no_stock_page.dart';
import 'package:easy_stock_app/view/purchase_request/pending/pending_page.dart';
import 'package:easy_stock_app/view/purchase_request/po/po_page.dart';
import 'package:easy_stock_app/view/purchase_request/vehicle_details/vehicle_list_page/vehicle_list_page.dart';
import 'package:flutter/material.dart';
import '../../../utils/common_widgets/background_image_widget.dart';
import '../completed/completed_page/completed_page.dart';

class RequestMainMenu extends StatefulWidget {
  final String isDriver;

  RequestMainMenu({super.key, required this.isDriver});

  @override
  State<RequestMainMenu> createState() => _RequestMainMenuState();
}

class _RequestMainMenuState extends State<RequestMainMenu> {
  late List<String> titleList;
  late List<Color> colorList;
  late List<Widget> pages;
  late var imageicon;

  @override
  void initState() {
    super.initState();
    initialiseGrid();
  }

  void initialiseGrid() {
    if (widget.isDriver == 'true') {
      titleList = ["Vehicle Details"];
      colorList = [Colors.white];
      pages = [const VehicleListPage()];
      imageicon = ['assets/icons/vehicle_icon.png'];
    } else {
      titleList = ["BPO", "Pending", "Completed", "No Stock", "PO", "LPO"];

      colorList = [
        Colors.white,
        Colors.white,
        Colors.green,
        Colors.red,
        Colors.white,
        Colors.white,
      ];

      pages = [
        const BpoItemListPage(),
        RequestPendingPage(),
        const RequestCompletdPage(),
        RequestNoStockPage(),
        const PoPage(),
        const LpoListpage(),
      ];
      imageicon = [
        'assets/icons/bpo_icon.png',
        'assets/icons/pending_icon.png',
        'assets/icons/completed_icon.png',
        'assets/icons/nostock_icon.png',
        'assets/icons/po_icon.png',
        'assets/icons/lpo_icon.png',
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: CustomAppBar(txt: "BPO"),
          ),
          Positioned(
            top: screenWidth >= 600 ? screenHeight * 0.15 : screenHeight * 0.1,
            left: 30,
            right: 30,
            child: Column(
              children: [
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in grid
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: 5.3 / 3.2, // Aspect ratio of each item
                  ),
                  itemCount: titleList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to different pages
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => pages[index],
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: 10.0, sigmaY: 10.0), // Blur effect
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(
                                  0.2), // Semi-transparent background
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              elevation: 3,
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(imageicon[index]),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    titleList[index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: colorList[index],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
