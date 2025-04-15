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

  TextEditingController _getController(String productId) {
    if (!_quantityControllers.containsKey(productId)) {
      _quantityControllers[productId] = TextEditingController();
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

    // Set initial quantity value if the product is in the cart
    int index = cartProvider.cartItems.indexWhere(
        (item) => item.productData.productId == widget.product.productId);
    if (index != -1) {
      quantityController.text =
          cartProvider.cartItems[index].quantity.toString();
    } else {
      quantityController.text = ''; // Default value
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
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Stack(
        children: [
          Positioned(
            top: widget.screenHeight * 0.00,
            right: 0,
            child: Container(
              width: widget.screenWidth * 0.35,
              height: widget.screenHeight * 0.2,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: cartProvider.cartItems.any((item) =>
                          item.productData.productId ==
                          widget.product.productId)
                      ? primaryColor
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cartProvider.cartItems.any((item) =>
                              item.productData.productId ==
                              widget.product.productId)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      yesnoAlertDialog(
                                          context: context,
                                          message:
                                              'Do you want to remove this product?',
                                          screenHeight: widget.screenHeight,
                                          screenWidth: widget.screenWidth,
                                          onNo: () {
                                            Navigator.pop(context);
                                          },
                                          onYes: () {
                                            cartProvider.removeItemFromCart(
                                                widget.product);
                                            Navigator.pop(context);
                                          },
                                          buttonNoText: 'No',
                                          buttonYesText: 'yes');
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(
                              height: 5,
                            ),
                      Center(
                        child: Container(
                          height: widget.screenHeight * 0.095,
                          width: widget.screenWidth * 0.35,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: widget.screenHeight * 0.095,
                                width: widget.screenWidth * 0.35,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Opacity(
                                    opacity: 0.6,
                                    child: Image.network(
                                      widget.product.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.image,
                                                  size: 40,
                                                  color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  addItemToCart();
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                left: 4,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.black,
                                  child: Text(
                                    widget.product.uomCode,
                                    style: const TextStyle(
                                      fontSize: 10,
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
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: widget.screenWidth * 0.3,
                              child: Text(
                                widget.product.productName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: widget.screenWidth * 0.3,
                              child: Text(
                                "${double.parse(widget.product.price).toStringAsFixed(2)} AED",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                           SizedBox(height: widget.screenHeight * 0.03),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 5),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       // Quantity TextField
                      //       Container(
                      //         height: widget.screenHeight * 0.032,
                      //         width: widget.screenWidth * 0.28,
                      //         margin: const EdgeInsets.only(top: 0),
                      //         decoration: BoxDecoration(
                      //           color: Colors.grey.withOpacity(0.8),
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         child: SizedBox(
                      //           width: widget.screenWidth *0.1,
                      //           child: TextField(
                      //             controller: quantityController,
                      //             keyboardType: TextInputType.number,
                      //             style: const TextStyle(
                      //               fontSize: 15,
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.white,
                      //             ),
                      //             textAlign: TextAlign.center,
                      //             decoration: const InputDecoration(
                      //               border: InputBorder.none,
                      //               hintText: '0',
                      //               hintStyle:
                      //                   TextStyle(color: Colors.white,fontSize: 15,
                      //               fontWeight: FontWeight.bold,),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: widget.screenHeight * 0.0229,
            child: Container(
              height: widget.screenHeight * 0.032,
              width: widget.screenWidth * 0.32,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: widget.screenWidth * 0.1,
                child: TextField(
                  cursorColor: primaryColor,
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
