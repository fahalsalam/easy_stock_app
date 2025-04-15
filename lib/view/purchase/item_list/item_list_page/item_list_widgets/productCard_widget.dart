import 'package:easy_stock_app/controllers/providers/purchase_providers/item_list_provider/itemlist_provider.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/view/purchase/item_list/item_list_page/item_list_widgets/add_button_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_stock_app/models/purchase_order/productData_model.dart';
import 'add_button.dart';

Widget buildProductCard(
  ProductDatum product,
  double screenHeight,
  double screenWidth,
  BuildContext context,
) {
  final cartProvider = Provider.of<PurchaseItemListProvider>(context);

  // Check if the product is in the cart
  bool isProductInCart = cartProvider.cartItems.any(
    (item) => item.productData.productId == product.productId,
  );

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6.0),
    child: Stack(
      children: [
        Positioned(
          top: screenHeight * 0.031,
          right: 0,
          child: Container(
            width: screenWidth * 0.35,
            height: screenHeight * 0.18,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isProductInCart
                    ? primaryColor
                    : Colors
                        .transparent, // Change to green if product is in cart
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SingleChildScrollView(
                // Wrapping the Column
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isProductInCart
                        ? Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    yesnoAlertDialog(
                                        context: context,
                                        message:
                                            'Do you want to remove this product?',
                                        screenHeight: screenHeight,
                                        screenWidth: screenWidth,
                                        onNo: () {
                                          Navigator.pop(context);
                                        },
                                        onYes: () {
                                          cartProvider
                                              .removeItemFromCart(product);
                                          Navigator.pop(context);
                                        },
                                        buttonNoText: 'No',
                                        buttonYesText: 'yes');
                                  },
                                  child: Icon(
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
                        height: screenHeight * 0.07,
                        width: screenWidth * 0.18,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),

                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image,
                                    size: 40, color: Colors.white),
                          ),
                        ),

                        // child: ClipOval(
                        //   child: Image.network(
                        //     product.imageUrl,
                        //     fit: BoxFit
                        //         .cover, // Ensures the image covers the circular area
                        //     errorBuilder: (context, error, stackTrace) =>
                        //         const Icon(
                        //       Icons.image,
                        //       size: 50,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      product.productName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      // {product.unit}
                      "Uom: ${product.uomCode}  ${double.parse(product.price).toStringAsFixed(2)} AED",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.08),
                    // Add button
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            left: screenWidth * 0.016,
            child: AddButtonWidget(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              product: product, // Pass your product data here
            )

            //  buildAddButton(
            //   screenHeight,
            //   screenWidth,
            //   context,
            //   product,
            // ),
            )
      ],
    ),
  );
}

Widget buildProductCardTab(
  ProductDatum product,
  double screenHeight,
  double screenWidth,
  BuildContext context,
) {
  final cartProvider = Provider.of<PurchaseItemListProvider>(context);

  // Check if the product is in the cart
  bool isProductInCart = cartProvider.cartItems.any(
    (item) => item.productData.productId == product.productId,
  );

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6.0),
    child: Column(
      children: [
        Container(
          width: screenWidth * 0.35,
          height: screenHeight * 0.23,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isProductInCart
                  ? primaryColor
                  : Colors.transparent, // Change to green if product is in cart
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SingleChildScrollView(
              // Wrapping the Column
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isProductInCart
                      ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  yesnoAlertDialog(
                                      context: context,
                                      message:
                                          'Do you want to remove this product?',
                                      screenHeight: screenHeight,
                                      screenWidth: screenWidth,
                                      onNo: () {
                                        Navigator.pop(context);
                                      },
                                      onYes: () {
                                        cartProvider
                                            .removeItemFromCart(product);
                                        Navigator.pop(context);
                                      },
                                      buttonNoText: 'No',
                                      buttonYesText: 'yes');
                                },
                                child: Icon(
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
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.18,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image,
                                  size: 40, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  // Center(
                  //   child: Container(
                  //     height: screenHeight * 0.1,
                  //     width: screenWidth * 0.1,
                  //     decoration: const BoxDecoration(
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: ClipOval(
                  //       child: Image.network(
                  //         product.imageUrl,
                  //         fit: BoxFit
                  //             .cover, // Ensures the image covers the circular area
                  //         errorBuilder: (context, error, stackTrace) =>
                  //             const Icon(
                  //           Icons.image,
                  //           size: 50,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          "Uom: ${product.uomCode} ${product.price} AED",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),
                  AddButtonTabWidget(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      product: product)
                  // buildAddButtonTab(
                  //   screenHeight,
                  //   screenWidth,
                  //   context,
                  //   product,
                  // )
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// Widget buildProductCardRow(
//   ProductDatum product,
//   double screenHeight,
//   double screenWidth,
//   BuildContext context,
// ) {
//   final cartProvider = Provider.of<PurchaseItemListProvider>(context);

//   // Check if the product is in the cart
//   bool isProductInCart = cartProvider.cartItems.any(
//     (item) => item.productData.productId == product.productId,
//   );

//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 6.0),
//     child: Stack(
//       children: [
//         Positioned(
//           top: screenHeight * 0.00,
//           right: 0,
//           child: Container(
//             width: screenWidth * 0.35,
//             height: screenHeight * 0.2,
//             decoration: BoxDecoration(
//               color: Colors.grey.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(15),
//               border: Border.all(
//                 color: isProductInCart
//                     ? primaryColor
//                     : Colors
//                         .transparent, // Change to green if product is in cart
//                 width: 2,
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical:5),
//               child: SingleChildScrollView(
//                 // Wrapping the Column
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     isProductInCart
//                         ? Padding(
//                             padding: EdgeInsets.all(0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     yesnoAlertDialog(
//                                         context: context,
//                                         message:
//                                             'Do you want to remove this product?',
//                                         screenHeight: screenHeight,
//                                         screenWidth: screenWidth,
//                                         onNo: () {
//                                           Navigator.pop(context);
//                                         },
//                                         onYes: () {
//                                           cartProvider
//                                               .removeItemFromCart(product);
//                                           Navigator.pop(context);
//                                         },
//                                         buttonNoText: 'No',
//                                         buttonYesText: 'yes');
//                                   },
//                                   child: Icon(
//                                     Icons.delete,
//                                     color: Colors.white,
//                                     size: 18,
//                                   ),
//                                 )
//                               ],
//                             ),
//                           )
//                         : const SizedBox(
//                             height: 5,
//                           ),
//                     Center(
//                       child: Container(
//                         height: screenHeight * 0.095,
//                         width: screenWidth * 0.35,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                         ),
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             // Background image with reduced opacity
//                             Container(
//                               height: screenHeight * 0.095,
//                               width: screenWidth * 0.35,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(5),
//                                 child: Opacity(
//                                   opacity:
//                                       0.6, // Set the opacity to make the image less opaque
//                                   child: Image.network(
//                                     product.imageUrl,
//                                     fit: BoxFit.cover,
//                                     errorBuilder:
//                                         (context, error, stackTrace) =>
//                                             const Icon(Icons.image,
//                                                 size: 40, color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             // Center Icon
//                             const Icon(
//                               Icons
//                                   .add, // Replace this with the icon you want in the center
//                               size: 30,
//                               color: Colors.white,
//                             ),
//                             // Positioned CircleAvatar at the top left
//                             Positioned(
//                               top: 4,
//                               left: 4,
//                               child: CircleAvatar(
//                                 radius: 12,
//                                 // Replace with desired image URL or placeholder
//                                 backgroundColor: Colors.black,
//                                 child: Text(
//                                   product.uomCode,
//                                   style: TextStyle(
//                                       fontSize: 10,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Center(
//                     //   child: Container(
//                     //     height: screenHeight * 0.095,
//                     //   width: screenWidth * 0.35,
//                     //     decoration: const BoxDecoration(
//                     //       shape: BoxShape.circle,
//                     //     ),

//                     //     child: Stack(
//                     //       children: [
//                     //         ClipRRect(
//                     //           borderRadius:
//                     //               BorderRadius.circular(10), // Rounded corners
//                     //           child: Image.network(
//                     //             product.imageUrl,
//                     //             fit: BoxFit.cover,
//                     //             errorBuilder: (context, error, stackTrace) =>
//                     //                 const Icon(Icons.image,
//                     //                     size: 40, color: Colors.white),
//                     //           ),
//                     //         ),
//                     //       ],
//                     //     ),

//                     //   ),
//                     // ),

//                     const SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 5, vertical: 3),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             width: screenWidth * 0.3,
//                             child: Text(
//                               product.productName,
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.white,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           SizedBox(
//                             width: screenWidth * 0.3,
//                             child: Text(
//                               // {product.unit}
//                               "${double.parse(product.price).toStringAsFixed(2)} AED",
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.white,
//                               ),overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           SizedBox(height: screenHeight * 0.08),
//                         ],
//                       ),
//                     ),

//                     // Add button
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: screenHeight*0.16,
//             // bottom: 0,
//             left: screenWidth * 0.016,
//             child: AddButtonWidget(
//               screenHeight: screenHeight,
//               screenWidth: screenWidth,
//               product: product, // Pass your product data here
//             )
//             )

//         //  buildAddButton(
//         //   screenHeight,
//         //   screenWidth,
//         //   context,
//         //   product,
//         // ),
//         // )
//       ],
//     ),
//   );
// }
