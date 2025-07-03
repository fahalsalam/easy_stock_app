// ignore_for_file: unused_local_variable

import 'package:easy_stock_app/controllers/providers/masters_provider/user_configure_provider/user_configure_provider.dart';
import 'package:easy_stock_app/models/masters/user_master/user_model.dart';
import 'package:easy_stock_app/utils/common_widgets/background_image_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/masters/user_configure/user_configure_widgets/edit_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserMasterEditPage extends StatefulWidget {
  final User data;
  final List<UserCategory> category;

  const UserMasterEditPage(
      {super.key, required this.data, required this.category});

  @override
  State<UserMasterEditPage> createState() => _UserMasterEditPageState();
}

class _UserMasterEditPageState extends State<UserMasterEditPage> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final userconfigure_provider = Provider.of<UserConfigureProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        // Refresh data before popping
        await userconfigure_provider.fetchData();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundImageWidget(image: common_backgroundImage),
            Positioned(
              top: screenHeight * 0.06,
              left: screenWidth * 0.02,
              right: screenWidth * 0.02,
              child: CustomAppBar(txt: "Edit User"),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.142, left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: userconfigure_provider.selectedIndex == 0,
                      child: EditUserWidget(
                          data: widget.data, category: widget.category),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
