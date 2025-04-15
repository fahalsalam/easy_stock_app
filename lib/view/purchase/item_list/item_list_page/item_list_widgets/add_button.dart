import 'dart:developer';
import 'package:easy_stock_app/controllers/providers/purchase_providers/item_list_provider/itemlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_stock_app/models/purchase_order/productData_model.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';

class AddButtonWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final ProductDatum product;

  const AddButtonWidget({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.product,
  }) : super(key: key);

  @override
  _AddButtonWidgetState createState() => _AddButtonWidgetState();
}

class _AddButtonWidgetState extends State<AddButtonWidget> {
  final Map<String, TextEditingController> _quantityControllers = {};

  TextEditingController _getController(String productId) {
    // Retrieve or create a controller for each product
    if (!_quantityControllers.containsKey(productId)) {
      _quantityControllers[productId] = TextEditingController();
    }
    return _quantityControllers[productId]!;
  }

  @override
  void dispose() {
    // Dispose of all controllers when the widget is removed from the tree
    for (var controller in _quantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider =
        Provider.of<PurchaseItemListProvider>(context, listen: false);
    TextEditingController quantityController =
        _getController(widget.product.productId);

    int index = cartProvider.cartItems.indexWhere(
        (item) => item.productData.productId == widget.product.productId);

    if (index != -1) {
      quantityController.text =
          cartProvider.cartItems[index].quantity.toString();
    } else {
      quantityController.text = ''; // Default value if product is not in cart
    }
  

    void addItemToCart() {
      double enteredQuantity = double.tryParse(quantityController.text) ?? 0;

      if (enteredQuantity > 0) {
        cartProvider.addItemToCart(
          widget.product,
          enteredQuantity,context
        );
    
        showSnackBar(context, "", "Item Added", Colors.white);
        log("add button with quantity: $enteredQuantity");
      } else {
        showSnackBar(context, "", "Enter valid quantity", Colors.red);
      }
    }

    return Consumer<PurchaseItemListProvider>(
        builder: (context, provider, child) {
      return Column(
        children: [
          Container(
            height: widget.screenHeight * 0.032,
            width: widget.screenWidth * 0.33,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                        hintStyle: const TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),
                      ),
                      // onSubmitted: (value) => addItemToCart(),
                    ),
                  ),
                  GestureDetector(
                    onTap: addItemToCart,
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15,)
        ],
      );
    });
  }
}


