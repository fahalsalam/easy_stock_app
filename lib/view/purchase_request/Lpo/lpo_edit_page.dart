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
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomAppBar(txt: "LPO No: ${widget.orderId}"),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24, width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.shopping_cart_outlined,
                                  color: primaryColor, size: 24),
                              const SizedBox(width: 12),
                              const Text(
                                "Order List",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  onTap: () async {
                                    try {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LpoAddProductPage(),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.add_circle_outline,
                                            color: Colors.black, size: 16),
                                        SizedBox(width: 8),
                                        Text(
                                          "Add Product",
                                          style: TextStyle(
                                            fontSize: 14,
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
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: isLoading
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(
                                      color: primaryColor,
                                      strokeWidth: 3,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Loading order details...",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: _buildOrderList(context, lpoListProvider,
                                    screenHeight, screenWidth),
                              ),
                      ),
                      if (!isLoading) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24, width: 1),
                          ),
                          child: _buildSummary(context, lpoListProvider,
                              screenWidth, screenHeight),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: _buildActionButtons(context, lpoListProvider,
                              screenHeight, screenWidth),
                        ),
                        const SizedBox(height: 16),
                      ],
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
              size: 48,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              "No Products Found",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: provider.details.length,
      itemBuilder: (context, index) {
        final item = provider.details[index];
        return _buildOrderItem(
            item, index, context, provider, screenHeight, screenWidth);
      },
    );
  }

  Widget _buildOrderItem(Detail item, int index, BuildContext context,
      LpolistProvider provider, double screenHeight, double screenWidth) {
    return Visibility(
      visible: item.itemStatus != 'NoStock',
      child: Container(
        height: screenHeight * 0.08,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                height: screenHeight * 0.04,
                width: screenWidth * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${double.parse(item.price).toStringAsFixed(2)} AED',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Qty: ",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                              Expanded(
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                yesnoAlertDialog(
                  context: context,
                  message: 'Do you want to remove?',
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  onNo: () => Navigator.pop(context),
                  onYes: () {
                    provider.deleteIndex(index, context);
                    Navigator.pop(context);
                  },
                  buttonNoText: 'No',
                  buttonYesText: 'Yes',
                );
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 18,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
          ],
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
        ),
        const Divider(color: Colors.white24, height: 24),
        _buildSummaryRow(
          "Total Quantity",
          provider.getTotalQuantity(),
          Icons.shopping_cart_outlined,
        ),
        const Divider(color: Colors.white24, height: 24),
        _buildSummaryRow(
          "Grand Total",
          provider.getPrice(),
          Icons.payments_outlined,
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon,
      {bool isTotal = false}) {
    return Row(
      children: [
        Icon(icon, color: isTotal ? primaryColor : Colors.white70, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isTotal ? primaryColor : Colors.white,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isTotal ? primaryColor : Colors.white,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, LpolistProvider provider,
      double screenHeight, double screenWidth) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildButton(
              context,
              "Cancel",
              Colors.black,
              () {
                yesnoAlertDialog(
                  context: context,
                  message: "Do you want to Cancel Order?",
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  onNo: () => Navigator.pop(context),
                  onYes: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  buttonNoText: "No",
                  buttonYesText: "Yes",
                );
              },
              screenHeight,
              screenWidth,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildButton(
              context,
              "Confirm",
              primaryColor,
              () {
                yesnoAlertDialog(
                  context: context,
                  message: "Do you want to Confirm Order?",
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  onNo: () => Navigator.pop(context),
                  onYes: () {
                    provider.confirmFunction(provider.details, context);
                    Navigator.pop(context);
                  },
                  buttonNoText: "No",
                  buttonYesText: "Yes",
                );
              },
              screenHeight,
              screenWidth,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Color color,
      VoidCallback onPressed, double screenHeight, double screenWidth) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color == Colors.black ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
