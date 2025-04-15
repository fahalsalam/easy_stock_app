
import 'package:easy_stock_app/controllers/providers/purchase_providers/item_list_provider/itemlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_stock_app/models/purchase_order/productData_model.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';

class QuantityButtonWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final ProductDatum product;

  const QuantityButtonWidget({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.product,
  }) : super(key: key);

  @override
  _QuantityButtonWidgetState createState() => _QuantityButtonWidgetState();
}

class _QuantityButtonWidgetState extends State<QuantityButtonWidget> {
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    quantityController = TextEditingController();

    // Initialize the quantity in the cart if available
    final cartProvider = Provider.of<PurchaseItemListProvider>(context, listen: false);
    int index = cartProvider.cartItems.indexWhere(
      (item) => item.productData.productId == widget.product.productId,
    );
    if (index != -1) {
      quantityController.text = cartProvider.cartItems[index].quantity.toString();
    }
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  void addItemToCart() {
    final cartProvider = Provider.of<PurchaseItemListProvider>(context, listen: false);
    double enteredQuantity = double.tryParse(quantityController.text) ?? 0;

    if (enteredQuantity > 0) {
      cartProvider.updateQuantity(widget.product, enteredQuantity, context);
    
      showSnackBar(context, "", "Item Added", Colors.white);
      // log("add button with quantity: $enteredQuantity");
    } else {
      showSnackBar(context, "", "Enter valid quantity", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PurchaseItemListProvider>(builder: (context, provider, child) {
      return Container(
        height: widget.screenHeight * 0.032,
        width: widget.screenWidth * 0.32,
        margin: const EdgeInsets.only(top: 0),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // TextField to input quantity
              Expanded(
                child: TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    hintText: '0',
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                  // onSubmitted: (value) {
                  //   addItemToCart();
                  // },
                ),
              ),
               GestureDetector(
                onTap: () {
                  addItemToCart();
                },
                child: const Text(
                  'ADD',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
