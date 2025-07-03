import 'dart:ui';

import 'package:easy_stock_app/utils/common_widgets/background_image_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/masters/category_master/category_master_page.dart';
import 'package:easy_stock_app/view/masters/customer/master_customerpage.dart';
import 'package:easy_stock_app/view/masters/general_settings/general_settings.dart';
import 'package:easy_stock_app/view/masters/item_master/itemlist_page.dart';
import 'package:easy_stock_app/view/masters/uom_master/uom_master_page.dart';
import 'package:easy_stock_app/view/masters/user_configure/user_configure.dart';
import 'package:easy_stock_app/view/masters/vehicle_management/vehicle_management_page.dart';
import 'package:flutter/material.dart';

class MastersMainPage extends StatefulWidget {
  const MastersMainPage({super.key});

  @override
  _MastersMainPageState createState() => _MastersMainPageState();
}

class _MastersMainPageState extends State<MastersMainPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("UI build complete, you can proceed with further actions.");
    });
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
            child: CustomAppBar(txt: "Masters"),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.13,
            left: 15,
            right: 15,
            child: Column(
              children: [
                // const SearchBarWidget(),
                GridView.builder(
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 10,
                    left: 20,
                    right: 20,
                  ),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 6 / 4,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    List<String> titleList = [
                      "Item Master",
                      'Category Master',
                      "UOM Master",
                      "User Configure",
                      "Vehicle \nManagement",
                      "Customer",
                      // "General Settings"
                    ];
                    final pages = [
                      const MastersProductListPage(),
                      CategoryMasterListPage(),
                      UOMMasterListPage(),
                      const MastersUserConfigurePage(),
                      const MastersVehicleManagementPage(),
                      const MastersCustomerPage(),
                      // GeneralSettingsuPage(),
                    ];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => pages[index]));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                elevation: 3,
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      titleList[index],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
