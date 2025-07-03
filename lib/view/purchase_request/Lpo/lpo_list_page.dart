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
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "LPO List",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "You can edit allowed times only",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: lpoListProvider.lpoData.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 48,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "No LPO Data",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: lpoListProvider.lpoData.length,
                            itemBuilder: (context, index) {
                              final lpodata = lpoListProvider.lpoData[index];
                              return buildLpoItem(
                                context,
                                lpodata,
                                screenHeight,
                                screenWidth,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLpoItem(
    BuildContext context,
    lpoDatum lpodata,
    double screenHeight,
    double screenWidth,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      lpodata.customerName.isEmpty
                          ? ""
                          : lpodata.customerName[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lpodata.customerName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('hh:mm a').format(lpodata.orderDate),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "LPO: #${lpodata.orderId}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () async {
                    log("${lpodata.orderId}, ${lpodata.editNo}");
                    try {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LPOEditOrderListPage(
                            orderId: lpodata.orderId.toString(),
                            editNo: lpodata.editNo.toString(),
                          ),
                        ),
                      );
                      await Provider.of<LpolistProvider>(context, listen: false)
                          .fetchData();
                    } catch (e) {
                      log("Error occurred: $e");
                    }
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: primaryColor,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
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
                  icon: const Icon(
                    Icons.visibility_outlined,
                    color: primaryColor,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
