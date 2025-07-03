import 'dart:developer';

import 'package:easy_stock_app/controllers/providers/purchase_providers/item_list_provider/itemlist_provider.dart';
import 'package:easy_stock_app/models/purchase_order/productData_model.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCardRow extends StatefulWidget {
  final ProductDatum product;
  final double screenHeight;
  final double screenWidth;

  const ProductCardRow({
    Key? key,
    required this.product,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  _ProductCardRowState createState() => _ProductCardRowState();
}

class _ProductCardRowState extends State<ProductCardRow> {
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, bool> _isUserTyping =
      {}; // Track if user is actively typing

  TextEditingController _getController(String productId) {
    if (!_quantityControllers.containsKey(productId)) {
      _quantityControllers[productId] = TextEditingController();
      _isUserTyping[productId] = false;
    }
    return _quantityControllers[productId]!;
  }

  @override
  void dispose() {
    for (var controller in _quantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<PurchaseItemListProvider>(context);
    TextEditingController quantityController =
        _getController(widget.product.productId);

    // Only update text controller if user is not actively typing
    int index = cartProvider.cartItems.indexWhere(
        (item) => item.productData.productId == widget.product.productId);

    // Only sync with cart if user is not typing
    if (!(_isUserTyping[widget.product.productId] ?? false)) {
      if (index != -1) {
        // Item is in cart
        String cartQuantity = cartProvider.cartItems[index].quantity.toString();
        if (quantityController.text != cartQuantity) {
          quantityController.text = cartQuantity;
        }
      } else {
        // Item not in cart
        if (quantityController.text.isNotEmpty) {
          double currentValue = double.tryParse(quantityController.text) ?? 0;
          if (currentValue == 0) {
            quantityController.text = '';
          }
        }
      }
    }

    void addItemToCart() {
      double enteredQuantity = double.tryParse(quantityController.text) ?? 0;
      if (enteredQuantity > 0.00) {
        cartProvider.addItemToCart(widget.product, enteredQuantity, context);
        showSnackBar(context, "", "Item Added", Colors.white);
        log("Add button with quantity: $enteredQuantity");
      } else {
        showSnackBar(context, "", "Enter valid quantity", Colors.red);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0), // Better outer padding
      child: Container(
        width: widget.screenWidth * 0.42, // Better width
        height:
            widget.screenHeight * 0.30, // Increased height to prevent overflow
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: cartProvider.cartItems.any((item) =>
                    item.productData.productId == widget.product.productId)
                ? primaryColor
                : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding:
                  const EdgeInsets.all(10.0), // Reduced padding from 12 to 10
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top spacing for delete icon
                  const SizedBox(height: 12), // Reduced from 14 to 12

                  // Product Image Section
                  Expanded(
                    flex: 5, // Increased flex for image section
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                widget.product.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.white54,
                                ),
                              ),
                            ),

                            // UOM Badge
                            Positioned(
                              top: 6,
                              left: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  widget.product.uomCode,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 4), // Reduced from 6 to 4

                  // Product Details
                  Expanded(
                    flex: 4, // Increased flex for text content
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.product.productName,
                          style: const TextStyle(
                            fontSize: 12, // Reduced font size
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.1, // Reduced line height
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 2), // Reduced from 3 to 2

                        Text(
                          "${double.parse(widget.product.price).toStringAsFixed(2)} AED",
                          style: TextStyle(
                            fontSize: 14, // Reduced font size
                            fontWeight: FontWeight.w700,
                            color: cartProvider.cartItems.any((item) =>
                                    item.productData.productId ==
                                    widget.product.productId)
                                ? primaryColor
                                : Colors.white,
                          ),
                        ),

                        // const SizedBox(height: 4), // Reduced from 6 to 4
                        Spacer(),
                        // Quantity Input
                        SizedBox(
                          child: Container(
                            width: double.infinity,
                            height: 30,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.15),
                                  Colors.white.withOpacity(0.08),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: cartProvider.cartItems.any((item) =>
                                        item.productData.productId ==
                                        widget.product.productId)
                                    ? primaryColor.withOpacity(0.6)
                                    : Colors.white.withOpacity(0.4),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Quantity input field
                                Expanded(
                                  child: TextField(
                                    controller: quantityController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '0',
                                      hintStyle: TextStyle(
                                        color: Colors.white38,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 8,
                                      ),
                                    ),
                                    onTap: () {
                                      _isUserTyping[widget.product.productId] =
                                          true;
                                    },
                                    onChanged: (value) {
                                      _isUserTyping[widget.product.productId] =
                                          true;
                                    },
                                  ),
                                ),

                                // Add button
                                GestureDetector(
                                  onTap: () {
                                    _isUserTyping[widget.product.productId] =
                                        false;
                                    double enteredQuantity = double.tryParse(
                                            quantityController.text) ??
                                        0;

                                    if (enteredQuantity > 0) {
                                      int index = cartProvider.cartItems
                                          .indexWhere((item) =>
                                              item.productData.productId ==
                                              widget.product.productId);

                                      if (index == -1) {
                                        cartProvider.addItemToCart(
                                            widget.product,
                                            enteredQuantity,
                                            context);
                                        showSnackBar(context, "",
                                            "Item Added to Cart", Colors.white);
                                      } else {
                                        cartProvider.updateQuantity(
                                            widget.product,
                                            enteredQuantity,
                                            context);
                                        showSnackBar(context, "",
                                            "Quantity Updated", Colors.white);
                                      }
                                    } else {
                                      showSnackBar(context, "",
                                          "Enter valid quantity", Colors.red);
                                    }
                                  },
                                  child: Container(
                                    width: 60,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Add",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Delete Icon (Sticky)
            if (cartProvider.cartItems.any((item) =>
                item.productData.productId == widget.product.productId))
              Positioned(
                top: 6, // Reduced position
                right: 6, // Reduced position
                child: GestureDetector(
                  onTap: () {
                    yesnoAlertDialog(
                        context: context,
                        message: 'Do you want to remove this product?',
                        screenHeight: widget.screenHeight,
                        screenWidth: widget.screenWidth,
                        onNo: () {
                          Navigator.pop(context);
                        },
                        onYes: () {
                          cartProvider.removeItemFromCart(widget.product);
                          quantityController
                              .clear(); // Clear the quantity input
                          Navigator.pop(context);
                        },
                        buttonNoText: 'No',
                        buttonYesText: 'Yes');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6), // Reduced padding
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4, // Reduced blur
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 16, // Reduced icon size
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
