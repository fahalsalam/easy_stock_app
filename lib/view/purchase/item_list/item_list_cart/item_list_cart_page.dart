import 'package:easy_stock_app/controllers/providers/purchase_providers/item_list_provider/itemlist_provider.dart';
import 'package:easy_stock_app/models/purchase_order/productData_model.dart';
import 'package:easy_stock_app/utils/common_widgets/alertbox.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/common_widgets/background_image_widget.dart';
import '../item_list_widgets/qtyButton.dart';

class ItemlistCartPage extends StatefulWidget {
  const ItemlistCartPage({super.key});

  @override
  State<ItemlistCartPage> createState() => _ItemlistCartPageState();
}

class _ItemlistCartPageState extends State<ItemlistCartPage> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<PurchaseItemListProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),

          // Main layout with sticky bottom sections
          Column(
            children: [
              // Top spacing for status bar
              SizedBox(height: screenHeight * 0.06),

              // Custom App Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Shopping Cart",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "${cartProvider.cartItems.length} items",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Scrollable Cart Items Section
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Header
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Order Summary",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Review your items before placing order",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // Scrollable Cart Items List
                      Expanded(
                        child: cartProvider.cartItems.isEmpty
                            ? _buildEmptyCart(screenHeight, screenWidth)
                            : SingleChildScrollView(
                                child: Column(
                                  children: cartProvider.cartItems
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int index = entry.key;
                                    var cartItem = entry.value;
                                    return _buildModernCartItem(
                                      cartItem.productData,
                                      cartItem.quantity,
                                      index,
                                      cartProvider,
                                      screenHeight,
                                      screenWidth,
                                    );
                                  }).toList(),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Sticky Order Summary Card
              Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child:
                    _buildOrderSummary(cartProvider, screenHeight, screenWidth),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Sticky Action Buttons
              Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: _buildActionButtons(
                    context, cartProvider, screenHeight, screenWidth),
              ),

              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(double screenHeight, double screenWidth) {
    return Container(
      height: screenHeight * 0.4,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Your cart is empty",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Add some products to get started",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernCartItem(
    ProductDatum product,
    double quantity,
    int index,
    PurchaseItemListProvider cartProvider,
    double screenHeight,
    double screenWidth,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.1),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_outlined,
                  size: 35,
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Unit: ${product.uomCode}",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${double.parse(product.price).toStringAsFixed(2)} AED",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Quantity Controls
                Row(
                  children: [
                    const Text(
                      "Qty:",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (quantity > 1) {
                                cartProvider.updateQuantity(
                                    product, quantity - 1, context);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.remove,
                                size: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              quantity.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              cartProvider.updateQuantity(
                                  product, quantity + 1, context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delete Button
          GestureDetector(
            onTap: () {
              yesnoAlertDialog(
                context: context,
                message: 'Remove this item from cart?',
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                onNo: () => Navigator.pop(context),
                onYes: () {
                  cartProvider.removeItemFromCart(product);
                  Navigator.pop(context);
                },
                buttonNoText: 'Cancel',
                buttonYesText: 'Remove',
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.delete_outline,
                size: 20,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(
    PurchaseItemListProvider cartProvider,
    double screenHeight,
    double screenWidth,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                "Order Summary",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryRow(
              "Total Items", cartProvider.cartItems.length.toString()),
          const SizedBox(height: 8),
          _buildSummaryRow("Total Quantity",
              double.parse(cartProvider.getTotalCartQty()).toStringAsFixed(2)),
          const SizedBox(height: 8),
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                "${double.parse(cartProvider.getTotalPrice()).toStringAsFixed(2)} AED",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    PurchaseItemListProvider cartProvider,
    double screenHeight,
    double screenWidth,
  ) {
    return Row(
      children: [
        // Cancel Button
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (cartProvider.cartItems.isNotEmpty) {
                yesnoAlertDialog(
                  context: context,
                  message: "Cancel this order?",
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  onNo: () => Navigator.pop(context),
                  onYes: () {
                    cartProvider.cancelFunction(cartProvider.cartItems);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  buttonNoText: "Keep",
                  buttonYesText: "Cancel",
                );
              } else {
                Navigator.pop(context);
              }
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Confirm Button
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              if (cartProvider.cartItems.isNotEmpty) {
                yesnoAlertDialog(
                  context: context,
                  message: "Confirm this order?",
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  onNo: () => Navigator.pop(context),
                  onYes: () {
                    cartProvider.confirmFunction(
                        cartProvider.cartItems, context);
                  },
                  buttonNoText: "Review",
                  buttonYesText: "Confirm",
                );
              } else {
                okAlertDialog(
                  context,
                  'Cart is Empty!\nPlease add products to cart',
                  screenHeight,
                  screenWidth,
                  () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  'OK',
                );
              }
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "Confirm Order",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
