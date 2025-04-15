import 'dart:developer';
import 'package:easy_stock_app/controllers/providers/purchase_providers/lpoList_providers/lpoList_provider.dart';
import 'package:easy_stock_app/models/purchase_order/lpoModel.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase_request/Lpo/lpoList_edit_page.dart';
import 'package:easy_stock_app/view/purchase_request/Lpo/lpo_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../utils/common_widgets/background_image_widget.dart';

class LpoListpage extends StatefulWidget {
  const LpoListpage({super.key});

  @override
  State<LpoListpage> createState() => _LpoListpageState();
}

class _LpoListpageState extends State<LpoListpage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LpolistProvider>(context, listen: false).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lpoListProvider = Provider.of<LpolistProvider>(context);
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
            child: CustomAppBar(txt: "View Order"),
          ),
          Positioned(
            top: screenHeight * 0.13,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "LPO List",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "You can edit allowed times only",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: screenHeight * 0.8,
                      child: lpoListProvider.lpoData.isEmpty
                          ? const Center(
                              child: Text(
                                "No Product Data",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.only(bottom: 20),
                              itemCount: lpoListProvider.lpoData.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final lpodata = lpoListProvider.lpoData[index];
                                return buildLpoItem(context, lpodata,
                                    screenHeight, screenWidth);
                              }),
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

  Widget buildLpoItem(BuildContext context, lpoDatum lpodata,
      double screenHeight, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          log("${lpodata.orderId}, ${lpodata.editNo}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LpoOrderListpage(
                orderId: lpodata.orderId.toString(),
                editNo: lpodata.editNo.toString(),
                customerName:
                    lpodata.customerName.isEmpty ? "" : lpodata.customerName,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          height: screenHeight * 0.072,
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: primaryColor,
                  child: Text(
                    lpodata.customerName.isEmpty
                        ? ""
                        : lpodata.customerName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth * 0.45,
                    child: Text(
                      lpodata.customerName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "LPO: #${lpodata.orderId}",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    DateFormat('hh:mm a').format(lpodata.orderDate),
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  log("${lpodata.orderId}, ${lpodata.editNo}");

                  try {
                    // Push to the EditOrderListPage
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LPOEditOrderListPage(
                          orderId: lpodata.orderId.toString(),
                          editNo: lpodata.editNo.toString(),
                        ),
                      ),
                    );

                    // After returning from EditOrderListPage, fetch new data
                    await Provider.of<LpolistProvider>(context, listen: false)
                        .fetchData();
                  } catch (e) {
                    // Handle any errors that occur during navigation or data fetching
                    log("Error occurred: $e");
                    // Optionally show a flushbar or dialog to notify the user
                  }
                },
                child: const Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.white,
                ),
              ), SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  log("${lpodata.orderId}, ${lpodata.editNo}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LpoOrderListpage(
                        orderId: lpodata.orderId.toString(),
                        editNo: lpodata.editNo.toString(),
                        customerName: lpodata.customerName.isEmpty
                            ? ""
                            : lpodata.customerName,
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.visibility,
                  size: 20,
                  color: Colors.white,
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
