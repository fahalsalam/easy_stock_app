// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:easy_stock_app/controllers/providers/purchase_providers/lpoList_providers/lpoList_provider.dart';
import 'package:easy_stock_app/models/purchase_order/order_details_model.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase/edit_request/edit_order_widgets/editTextfield_widget.dart';
import 'package:easy_stock_app/view/purchase_request/Lpo/add_product_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/common_widgets/background_image_widget.dart';

class LPOEditOrderListPage extends StatefulWidget {
  final String orderId;
  final String editNo;
  const LPOEditOrderListPage(
      {super.key, required this.orderId, required this.editNo});

  @override
  State<LPOEditOrderListPage> createState() => _LPOEditOrderListPageState();
}

class _LPOEditOrderListPageState extends State<LPOEditOrderListPage> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<LpolistProvider>(context, listen: false).fetchProductData();
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
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: CustomAppBar(txt: "Edit Order"),
          ),
          Positioned(
            top: screenHeight * 0.14,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Order List",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(10),
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                // Push to the EditOrderListPage
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LpoAddProductPage(                      
                                        ),
                                  ),
                                );

                                // After returning from EditOrderListPage, fetch new data
                                await Provider.of<LpolistProvider>(context,
                                        listen: false)
                                    .fetchData();
                              } catch (e) {
                                // Handle any errors that occur during navigation or data fetching
                                log("Error occurred: $e");
                                // Optionally show a flushbar or dialog to notify the user
                              }
                            },
                            child: Container(
                              height: screenHeight * 0.035,
                              width: screenWidth * 0.2,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(width: 1, color: primaryColor),
                              ),
                              child: Center(
                                child: Text(
                                  "Add Product",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    isLoading == true
                        ? SizedBox(
                            height: screenHeight * 0.5,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              _buildOrderList(context, lpoListProvider,
                                  screenHeight, screenWidth),
                              SizedBox(height: screenHeight * 0.0082),
                              _buildSummary(context, lpoListProvider,
                                  screenWidth, screenHeight),
                              SizedBox(height: screenHeight * 0.03),
                              _buildActionButtons(context, lpoListProvider,
                                  screenHeight, screenWidth),
                              SizedBox(height: 50),
                            ],
                          ),
                    SizedBox(height: screenHeight * 0.23),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, LpolistProvider provider,
      double screenHeight, double screenWidth) {
    return Container(
      height: screenHeight * 0.63,
      child: provider.details.isEmpty
          ? const Center(
              child: Text(
                "No Product data",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 50),
              itemCount: provider.details.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = provider.details[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildOrderItem(item, index, context, provider,
                      screenHeight, screenWidth),
                );
              },
            ),
    );
  }

  Widget _buildOrderItem(Detail item, int index, BuildContext context,
      LpolistProvider provider, double screenHeight, double screenWidth) {
    return Visibility(
         visible: item.itemStatus!='NoStock',
      child: Container( 
        height: screenHeight * 0.12,
        width: screenWidth * 0.06,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.withOpacity(0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Container(
                height: screenHeight * 0.06,
                width: screenWidth * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image, size: 40, color: Colors.white),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(height: 0.05,),
                SizedBox(
                  // height: screenHeight * 0.05,
                  width: screenWidth * 0.48,
                  child: Text(
                    item.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "${double.parse(item.price).toStringAsFixed(2)} AED",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Row(
                      children: [
                        Text(
                          "Qty: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.25,
                          child: QtyButtonWidget(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            initialQuantity:
                                double.parse(item.qty).toStringAsFixed(2),
                            onSubmit: (value) {
                              if (value.isNotEmpty) {
                                provider.changeQty(index, value, context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ), Text(
                      "${item.itemStatus}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
              ],
            ),
            IconButton(
                onPressed: () {
                  yesnoAlertDialog(
                      context: context,
                      message: 'Do you want to remove?',
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      onNo: () {
                        Navigator.pop(context);
                      },
                      onYes: () {
                        provider.deleteIndex(index, context);
                        Navigator.pop(context);
                      },
                      buttonNoText: 'No',
                      buttonYesText: 'Yes');
                  // provider.deleteIndex(index, context);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 23,
                )),
            const SizedBox(
              width: 0.02,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, LpolistProvider provider,
      double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
      child: Column(
        children: [
          _buildSummaryRow(
              "Total Items", provider.details.length.toStringAsFixed(2)),
          SizedBox(
            height: screenHeight * 0.008,
          ),
          _buildSummaryRow("Total Quantity", provider.getTotalQuantity()),
          SizedBox(
            height: screenHeight * 0.008,
          ),
          _buildSummaryRow("Grand Total", provider.getPrice()),
          // _buildSummaryRow("Grand Total", "2700.00"),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
        const Text(" : "),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, LpolistProvider provider,
      double screenHeight, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton(context, "Cancel", Colors.black, () {
          yesnoAlertDialog(
            context: context,
            message: "Do you want to Cancel Order?",
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            onNo: () {
              Navigator.pop(context);
            },
            onYes: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            buttonNoText: "No",
            buttonYesText: "Yes",
          );
        }, screenHeight, screenWidth),
        _buildButton(context, "Confirm", primaryColor, () {
          yesnoAlertDialog(
            context: context,
            message: "Do you want to Confirm Order?",
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            onNo: () {
              Navigator.pop(context);
            },
            onYes: () {
              provider.confirmFunction(provider.details, context);
              Navigator.pop(context);
            },
            buttonNoText: "No",
            buttonYesText: "Yes",
          );
        }, screenHeight, screenWidth),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String text, Color color,
      VoidCallback onPressed, double screenHeight, double screenWidth) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: screenHeight * 0.045,
          width: screenWidth * 0.38,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: primaryColor),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: color == Colors.black ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
