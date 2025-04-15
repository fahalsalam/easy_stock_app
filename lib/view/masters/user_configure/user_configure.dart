// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/masters/user_configure/user_add_page.dart';
import 'package:easy_stock_app/view/masters/user_configure/user_configure_widgets/user_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/providers/masters_provider/user_configure_provider/user_configure_provider.dart';
import '../../../utils/common_widgets/background_image_widget.dart';

class MastersUserConfigurePage extends StatefulWidget {
  const MastersUserConfigurePage({super.key});

  @override
  State<MastersUserConfigurePage> createState() =>
      _MastersUserConfigurePageState();
}

class _MastersUserConfigurePageState extends State<MastersUserConfigurePage> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserConfigureProvider>(context, listen: false)
          .fetchData()
          .then((_) {
            setState(() {
              isLoading=false;
            });
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final userconfigureProvider = Provider.of<UserConfigureProvider>(context);
    return Scaffold(
        body: Stack(
          children: [
            BackgroundImageWidget(image: common_backgroundImage),
            Positioned(
              top: screenHeight * 0.06,
              left: screenWidth * 0.02,
              right: screenWidth * 0.02,
              child: CustomAppBar(txt: "User Configure"),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.142, left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isLoading
                        ? Center(
                          child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                        )
                        : UserListWidget(data: userconfigureProvider.userData),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor.withOpacity(0.5),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserMasterAddPage(),
              ),
            ).then((_) {
              setState(() {
                Provider.of<UserConfigureProvider>(context, listen: false)
                    .fetchData();
              });
            });
          },
        ));
  }
}
