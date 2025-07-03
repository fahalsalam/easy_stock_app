// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:easy_stock_app/controllers/providers/purchase_providers/lpoList_providers/lpoList_provider.dart';
import 'package:easy_stock_app/models/purchase_order/order_details_model.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase_request/Lpo/lpoinvoice_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/common_widgets/background_image_widget.dart';

class LpoOrderListpage extends StatefulWidget {
  final String orderId;
  final String editNo;
  final String customerName;
  const LpoOrderListpage({
    super.key,
    required this.orderId,
    required this.editNo,
    required this.customerName,
  });

  @override
  State<LpoOrderListpage> createState() => _LpoOrderListpageState();
}

class _LpoOrderListpageState extends State<LpoOrderListpage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LpolistProvider>(context, listen: false)
          .fetchDetails(orderId: widget.orderId, editNo: widget.editNo)
          .then((_) {
        setState(() {
          isLoading = false;
        });
      });
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
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: CustomAppBar(txt: "LPO No: ${widget.orderId}"),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(screenWidth * 0.04,
                            screenHeight * 0.01, screenWidth * 0.04, 0),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03,
                                  vertical: screenHeight * 0.015),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.white24, width: 1),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.shopping_cart_outlined,
                                      color: primaryColor,
                                      size: screenWidth * 0.05),
                                  SizedBox(width: screenWidth * 0.03),
                                  Text(
                                    "Order List",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenWidth * 0.04,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (!isLoading)
                                    Material(
                                      elevation: 2,
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () async {
                                          try {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LpoinvoicePage(
                                                  dataList:
                                                      lpoListProvider.details,
                                                  header: lpoListProvider
                                                      .header.first,
                                                  lpoNumber:
                                                      widget.orderId.toString(),
                                                  customerName:
                                                      widget.customerName,
                                                ),
                                              ),
                                            );
                                            await Provider.of<LpolistProvider>(
                                                    context,
                                                    listen: false)
                                                .fetchData();
                                          } catch (e) {
                                            log("Error occurred: $e");
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.03,
                                              vertical: screenHeight * 0.008),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.receipt_long,
                                                  color: Colors.black,
                                                  size: screenWidth * 0.035),
                                              SizedBox(
                                                  width: screenWidth * 0.015),
                                              Text(
                                                "Invoice",
                                                style: TextStyle(
                                                  fontSize: screenWidth * 0.03,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Expanded(
                        child: isLoading
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(
                                      color: primaryColor,
                                      strokeWidth: 2.5,
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    Text(
                                      "Loading order details...",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04),
                                child: _buildOrderList(context, lpoListProvider,
                                    screenHeight, screenWidth),
                              ),
                      ),
                      if (!isLoading)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.015),
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24, width: 1),
                          ),
                          child: _buildSummary(context, lpoListProvider,
                              screenWidth, screenHeight),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, LpolistProvider provider,
      double screenHeight, double screenWidth) {
    if (provider.details.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: screenWidth * 0.1,
              color: Colors.white.withOpacity(0.5),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "No Products Found",
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(
          top: screenHeight * 0.01, bottom: screenHeight * 0.02),
      itemCount: provider.details.length,
      itemBuilder: (context, index) {
        final item = provider.details[index];
        return Visibility(
          visible: item.itemStatus != 'NoStock',
          child: Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.01),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.025),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: screenWidth * 0.12,
                      width: screenWidth * 0.12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image,
                            size: screenWidth * 0.06,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.025),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: screenWidth * 0.033,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: screenHeight * 0.006),
                          Row(
                            children: [
                              _buildTag(
                                context,
                                'UOM: ${item.uomCode}',
                                screenWidth,
                                screenHeight,
                                Colors.white.withOpacity(0.1),
                                Colors.white70,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              _buildTag(
                                context,
                                'Qty: ${double.parse(item.qty).toStringAsFixed(2)}',
                                screenWidth,
                                screenHeight,
                                primaryColor.withOpacity(0.2),
                                primaryColor,
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          _buildTag(
                            context,
                            '${double.parse(item.price).toStringAsFixed(2)} AED',
                            screenWidth,
                            screenHeight,
                            Colors.white.withOpacity(0.1),
                            Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTag(BuildContext context, String text, double screenWidth,
      double screenHeight, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.015, vertical: screenHeight * 0.003),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: screenWidth * 0.028,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, LpolistProvider provider,
      double screenWidth, double screenHeight) {
    return Column(
      children: [
        _buildSummaryRow(
          "Total Items",
          provider.details.length.toString(),
          Icons.inventory_2_outlined,
          screenWidth,
          screenHeight,
        ),
        Divider(color: Colors.white24, height: screenHeight * 0.025),
        _buildSummaryRow(
          "Total Quantity",
          provider.getTotalQuantity(),
          Icons.shopping_cart_outlined,
          screenWidth,
          screenHeight,
        ),
        Divider(color: Colors.white24, height: screenHeight * 0.025),
        _buildSummaryRow(
          "Grand Total",
          provider.getPrice(),
          Icons.payments_outlined,
          screenWidth,
          screenHeight,
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon,
      double screenWidth, double screenHeight,
      {bool isTotal = false}) {
    return Row(
      children: [
        Icon(icon,
            color: isTotal ? primaryColor : Colors.white70,
            size: screenWidth * 0.045),
        SizedBox(width: screenWidth * 0.03),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isTotal ? primaryColor : Colors.white,
            fontSize: screenWidth * 0.035,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isTotal ? primaryColor : Colors.white,
            fontSize: screenWidth * 0.035,
          ),
        ),
      ],
    );
  }
}
