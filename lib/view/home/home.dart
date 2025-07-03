import 'package:easy_stock_app/controllers/providers/purchase_providers/item_list_provider/itemlist_provider.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/home/home_widgets/custom_appbar/custom_appbar_widget.dart';
import 'package:easy_stock_app/view/home/home_widgets/custom_grid_view_widget/custom_grid_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String appVersion = '';
  String? userName;
  String? tenantName;

  @override
  void initState() {
    super.initState();
    _getAppVersion();
    getUserName();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PurchaseItemListProvider>(context, listen: false)
          .fetchCategories()
          .then((value) {
        print("categories fetched");
      }).whenComplete(() {
        // setState(() {
        //   // isLoading = false;
        // });
      });
    });
  }

  getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('username');
    tenantName = prefs.getString('userCode');
  }

  Future<void> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = packageInfo.version;
      });
    } catch (e) {
      setState(() {
        appVersion = 'Unknown version';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(common_backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.035,
            left: 0,
            right: 0,
            child: SizedBox(
              height: screenHeight - 20, // Provide a bounded height
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom App Bar
                    CustomAppBarWidget(userName: tenantName ?? ''),
                    Text(
                      'Welcome ${tenantName ?? ''}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),

                    // Select Action Title
                    SizedBox(height: screenHeight * 0.05),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Select Action",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Grid View for items
                    SizedBox(
                      height: screenHeight * 0.55,
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CustomGridView(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.05,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                'Version: $appVersion',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                '${userName ?? ''}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
