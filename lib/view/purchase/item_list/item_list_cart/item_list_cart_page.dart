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
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: CustomAppBar(txt: "Cart"),
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
                    const Text(
                      "Total Item List",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18, // Slightly increase the size for clarity
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    const Text(
                      "Note : Purchase Order",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14, // Increase the size slightly
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    SizedBox(
                      height: screenHeight * 0.48,
                      child: cartProvider.cartItems.isEmpty
                          ? const Center(
                              child: Text(
                                "No products in Cart",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 15),
                              itemCount: cartProvider.cartItems.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                ProductDatum cartData =
                                    cartProvider.cartItems[index].productData;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    height: screenHeight * 0.15,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey.withOpacity(0.3),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle),
                                          child: ClipOval(
                                            // borderRadius:
                                            //     BorderRadius.circular(10),
                                            child: Image.network(
                                              cartData.imageUrl,
                                              height: screenHeight * 0.12,
                                              width: screenWidth * 0.25,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(
                                                Icons.image,
                                                size: 45,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.04,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                cartData.productName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              // SizedBox(height: 0.02.sh,),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: screenHeight * 0.02,
                                                    bottom: 2),
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      "Unit: KG",
                                                      style:
                                                        TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  0.1),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      "Price: ${double.parse(cartData.price).toStringAsFixed(2)} AED",
                                                      style:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  0.1),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Row(
                                                children: [
                                                  const Text(
                                                    "Quantity: ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        letterSpacing: 0.8),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.01,
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.3,
                                                    child: QuantityButtonWidget(
                                                      screenHeight:
                                                          screenHeight,
                                                      screenWidth: screenWidth,
                                                      product: cartData,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            yesnoAlertDialog( context: context,
                                              message:
                                                  'Do you want to remove this product?',
                                              screenHeight: screenHeight,
                                              screenWidth: screenWidth,
                                              // 'No' button callback
                                              onNo: () {
                                                Navigator.pop(
                                                    context); // Dismisses the dialog without any action
                                              },
                                              // 'Yes' button callback
                                              onYes: () async {
                                                // Remove the item from the cart
                                                cartProvider.removeItemFromCart(
                                                    cartData);
                                                Navigator.pop(
                                                    context); // Close the 'Yes/No' dialog
                                              },
                                              buttonNoText: 'No',
                                              buttonYesText: 'Yes',
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Consumer<PurchaseItemListProvider>(
                      builder: (context, cartProvider, child) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.3,
                                  child: const Text(
                                    "Total Items",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  cartProvider.cartItems.length.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Row(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.3,
                                  child: const Text(
                                    "Total Quantity",
                                    style:TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  double.parse(cartProvider.getTotalCartQty())
                                      .toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Row(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.3,
                                  child: const Text(
                                    "Total Amount",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  double.parse(cartProvider.getTotalPrice())
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(context, "Cancel", Colors.black,
                            primaryColor, cartProvider,
                            isConfirm: false,
                            screenHeight: screenHeight,
                            screenWidth: screenWidth),
                        _buildActionButton(context, "Confirm", primaryColor,
                            Colors.black, cartProvider,
                            isConfirm: true,
                            screenHeight: screenHeight,
                            screenWidth: screenWidth),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    Color bgColor,
    Color borderColor,
    PurchaseItemListProvider cartProvider, {
    required bool isConfirm,
    required double screenHeight,
    required double screenWidth,
  }) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(5),
      child: GestureDetector(
        onTap: () {
          if (cartProvider.cartItems.isNotEmpty) {
            if (text == "Confirm") {
              yesnoAlertDialog( context: context,
                message: "Do you want to Confirm Order?",
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                onNo: () {
                  Navigator.pop(context);
                },
                onYes: () {
                  if (isConfirm) {
                    cartProvider.confirmFunction(
                        cartProvider.cartItems, context);
                  }
                  // Future.delayed(const Duration(seconds: 2)).then((_) {
                  //   Navigator.pop(context);
                  //   Navigator.pop(context);
                  //   // Navigator.pop(context);
                  // });
                },
                buttonYesText: "No",
                buttonNoText: "Yes",
              );
            } else {
              yesnoAlertDialog( context: context,
                message: "Do you want to Cancel Order?",
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                onNo: () {
                  Navigator.pop(context);
                },
                onYes: () {
                  cartProvider.cancelFunction(
                    cartProvider.cartItems,
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                buttonNoText: "No",
                buttonYesText: "Yes",
              );
            }
          } else {
            okAlertDialog(
              context,
              'Cart is Empty! \nPlease add products in cart',
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
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.35,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: borderColor),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: bgColor == Colors.black ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
