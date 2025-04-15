import 'dart:ui';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/utils/constants/loginConstants.dart';
import 'package:easy_stock_app/view/masters/masters_main_page/masters_main_page.dart';
import 'package:easy_stock_app/view/purchase/purchase_mainmenu/purchase_main_menu_page.dart';
import 'package:easy_stock_app/view/purchase_request/purchase_request_mainmenu/purchase_request_mainmenu.dart';
import 'package:easy_stock_app/view/purchase_request/vehicle_details/vehicle_list_page/vehicle_list_page.dart';
import 'package:flutter/material.dart';


class CustomGridView extends StatefulWidget {
  const CustomGridView({
    super.key,
  });

  @override
  State<CustomGridView> createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<CustomGridView> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMenuValues();
  }

  Future<void> fetchMenuValues() async {
    // await Future.delayed(Duration(seconds: 2));
    if (isMaster != "" && isOrder != "" && isPurchase != ""&&isDriver!="")
      setState(() {
        isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    List<Map<String, dynamic>> items = [
      {
        'image': purchase_order_image,
        'page': const PurchaseMainMenuPage(),
        'title': 'Purchase Order',
        'showItem': isOrder,
      },
      {
        'image': isDriver.toLowerCase() == 'true'
            ? vehicle_details_img
            : purchase_request_image,
        'page': isDriver.toLowerCase() == 'true'
            ? const VehicleListPage()
            : RequestMainMenu(
                isDriver: 'false',
              ),
        'title': isDriver.toLowerCase() == 'true'
            ? 'Vehicle Details'
            : 'Purchase Request',
        'showItem': isPurchase,
      },
      {
        'image': masters_image,
        'page': const MastersMainPage(),
        'title': 'Masters',
        'showItem': isMaster,
      },
      // {
      //   'image': report_image,
      //   'page': const ReportMainMenuPage(),
      //   'title': 'Report',
      //   'showItem': isMaster,
      // },
    ];

    List<Map<String, dynamic>> filteredList =
        items.where((items) => items['showItem'] == 'true').toList();

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 6.6 / 7,
      ),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => filteredList[index]['page']),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Material(
                  color: Colors.transparent,
                  elevation: 3,
                  borderRadius: BorderRadius.circular(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            filteredList[index]['image'],
                            height: 80,
                            width: 80,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        filteredList[index]['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.white,
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
    );
  }
}
