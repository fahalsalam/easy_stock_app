import 'package:easy_stock_app/controllers/providers/masters_provider/user_configure_provider/user_configure_provider.dart';
import 'package:easy_stock_app/utils/common_widgets/background_image_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/masters/user_configure/user_configure_widgets/add_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserMasterAddPage extends StatefulWidget {
  const UserMasterAddPage({super.key});

  @override
  State<UserMasterAddPage> createState() => _UserMasterAddPageState();
}

class _UserMasterAddPageState extends State<UserMasterAddPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserConfigureProvider>(context, listen: false).removeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    final userconfigure_provider = Provider.of<UserConfigureProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        // Refresh the user list when going back
        await Provider.of<UserConfigureProvider>(context, listen: false)
            .fetchData();
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
              child: CustomAppBar(txt: "Add User"),
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
                        child: const AddUserWidget()),
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
