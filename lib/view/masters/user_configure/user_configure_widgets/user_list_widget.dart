import 'package:easy_stock_app/controllers/providers/masters_provider/user_configure_provider/user_configure_provider.dart';
import 'package:easy_stock_app/models/masters/user_master/user_model.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/view/masters/user_configure/user_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListWidget extends StatefulWidget {
  List<User> data;
  UserListWidget({super.key, required this.data});

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserConfigureProvider>(context, listen: false).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userManagementProvider = Provider.of<UserConfigureProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.015),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
          child: Text(
            "Manage User",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Center(
          child: Container(
            width: screenWidth * 0.9,
            height: screenHeight * 0.75,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5),
              child: widget.data.isEmpty
                  ? const Center(
                      child: Text(
                        "No Data",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.051),
                      shrinkWrap: true,
                      // reverse: true,
                      itemCount: widget.data.length,
                      itemBuilder: (context, index) {
                        User user = (userManagementProvider.userData[index]);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 15),
                          child: Container(
                            height: screenHeight * 0.075,
                            width: screenWidth * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: primaryColor,
                                    child: Text(
                                      // 'U',
                                      user.userName != ""
                                          ? user.userName[0].toString()
                                          : 'U',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(
                                    user.userId.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  user.userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserMasterEditPage(
                                          data: user,
                                          category: userManagementProvider
                                              .userCategory,
                                        ),
                                      ),
                                    ).then((_) {
                                      setState(() {
                                        Provider.of<UserConfigureProvider>(
                                                context,
                                                listen: false)
                                            .fetchData();
                                      });
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.05),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.1),
      ],
    );
  }
}
