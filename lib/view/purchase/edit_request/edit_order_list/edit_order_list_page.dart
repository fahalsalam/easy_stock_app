// ignore_for_file: prefer_const_constructors

import 'package:easy_stock_app/controllers/providers/purchase_providers/lpoList_providers/lpoList_provider.dart';
import 'package:easy_stock_app/models/purchase_order/order_details_model.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase/edit_request/edit_order_widgets/editTextfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/common_widgets/background_image_widget.dart';

class EditOrderListPage extends StatefulWidget {
  final String orderId;
  final String editNo;
  const EditOrderListPage(
      {super.key, required this.orderId, required this.editNo});

  @override
  State<EditOrderListPage> createState() => _EditOrderListPageState();
}

class _EditOrderListPageState extends State<EditOrderListPage> {
  bool isLoading = true;
  int initialDetailsLength = 0;
  Map<int, String> initialQuantities =
      {}; // Add map to track initial quantities

  // Function to check if quantities have changed
  bool _haveQuantitiesChanged(LpolistProvider provider) {
    for (int i = 0; i < provider.details.length; i++) {
      if (initialQuantities[i] != provider.details[i].qty) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<LpolistProvider>(context, listen: false)
          .fetchDetails(orderId: widget.orderId, editNo: widget.editNo)
          .then((_) {
        final provider = Provider.of<LpolistProvider>(context, listen: false);
        setState(() {
          isLoading = false;
          initialDetailsLength = provider.details.length;
          // Store initial quantities
          for (int i = 0; i < provider.details.length; i++) {
            initialQuantities[i] = provider.details[i].qty;
          }
        });
      });
    });
  }

  Future<bool> _handleBackPress(LpolistProvider provider) async {
    if (provider.isChanged) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Unsaved Changes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'You have unsaved changes. Are you sure you want to leave?',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'No',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                provider.resetChanged();
                Navigator.of(context).pop(true);
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final lpoListProvider = Provider.of<LpolistProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () => _handleBackPress(lpoListProvider),
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundImageWidget(image: common_backgroundImage),
            Positioned(
              top: screenHeight * 0.06,
              left: screenWidth * 0.02,
              right: screenWidth * 0.02,
              child: Container(
                height: screenHeight * 0.06,
                width: screenWidth * 0.9,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        final canPop = await _handleBackPress(lpoListProvider);
                        if (canPop && mounted) {
                          Navigator.pop(context,
                              true); // Return true to indicate refresh needed
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Edit Order #${widget.orderId}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.13,
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isLoading == true
                            ? SizedBox(
                                height: screenHeight * 0.5,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                    strokeWidth: 3,
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  _buildOrderList(context, lpoListProvider,
                                      screenHeight, screenWidth),
                                  SizedBox(height: screenHeight * 0.02),
                                  _buildSummary(context, lpoListProvider,
                                      screenWidth, screenHeight),
                                  SizedBox(height: screenHeight * 0.02),
                                  _buildActionButtons(context, lpoListProvider,
                                      screenHeight, screenWidth),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, LpolistProvider provider,
      double screenHeight, double screenWidth) {
    return Container(
      height: screenHeight * 0.5,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: provider.details.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 42, color: Colors.white.withOpacity(0.5)),
                  const SizedBox(height: 14),
                  const Text(
                    "No Products Found",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: provider.details.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = provider.details[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildOrderItem(item, index, context, provider,
                      screenHeight, screenWidth),
                );
              },
            ),
    );
  }

  Widget _buildOrderItem(Detail item, int index, BuildContext context,
      LpolistProvider provider, double screenHeight, double screenWidth) {
    return Container(
      height: screenHeight * 0.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Container(
              height: screenHeight * 0.07,
              width: screenWidth * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image, size: 30, color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "${double.parse(item.price).toStringAsFixed(2)} AED",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Text(
                        "Qty: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                          fontSize: 13,
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
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              yesnoAlertDialog(
                context: context,
                message: 'Do you want to remove this product?',
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
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, LpolistProvider provider,
      double screenWidth, double screenHeight) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            "Total Items",
            provider.details.length.toStringAsFixed(2),
            Icons.shopping_bag_outlined,
          ),
          const Divider(color: Colors.white24, height: 20),
          _buildSummaryRow(
            "Total Quantity",
            provider.getTotalQuantity(),
            Icons.inventory_2_outlined,
          ),
          const Divider(color: Colors.white24, height: 20),
          _buildSummaryRow(
            "Grand Total",
            provider.getPrice(),
            Icons.payments_outlined,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon,
      {bool isTotal = false}) {
    return Row(
      children: [
        Icon(
          icon,
          color: isTotal ? primaryColor : Colors.white70,
          size: 18,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isTotal ? primaryColor : Colors.white,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isTotal ? primaryColor : Colors.white,
            fontSize: 15,
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
        _buildButton(
          context: context,
          text: "Cancel",
          onPressed: () {
            yesnoAlertDialog(
              context: context,
              message: "Do you want to Cancel Order?",
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              onNo: () {
                Navigator.pop(context, true);
                Navigator.pop(context, true);
              },
              onYes: () {
                provider.cancelOrder(context);
                Navigator.pop(context, true);
                Navigator.pop(context, true);
              },
              buttonNoText: "No",
              buttonYesText: "Yes",
            );
          },
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          icon: Icons.close,
          color: Colors.red,
        ),
        _buildButton(
          context: context,
          text: "Confirm",
          onPressed: () {
            yesnoAlertDialog(
              context: context,
              message: "Do you want to Confirm Order?",
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              onNo: () => Navigator.pop(context, true),
              onYes: () {
                provider.confirmFunction(provider.details, context);
                Navigator.pop(context, true);
              },
              buttonNoText: "No",
              buttonYesText: "Yes",
            );
          },
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          icon: Icons.check_circle_outline,
          color: primaryColor,
          isPrimary: true,
        ),
      ],
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    required double screenHeight,
    required double screenWidth,
    required IconData icon,
    required Color color,
    bool isPrimary = false,
  }) {
    final provider = Provider.of<LpolistProvider>(context);
    final bool isConfirmButton = text == "Confirm";
    final bool isDisabled = isConfirmButton && provider.details.isEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: screenHeight * 0.055,
          width: screenWidth * 0.4,
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.grey.withOpacity(0.2)
                : isPrimary
                    ? color
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1.5,
              color: isDisabled ? Colors.grey : color,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isDisabled
                    ? Colors.white.withOpacity(0.5)
                    : isPrimary
                        ? Colors.white
                        : color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDisabled
                      ? Colors.white.withOpacity(0.5)
                      : isPrimary
                          ? Colors.white
                          : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
