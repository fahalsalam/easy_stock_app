import 'dart:developer';

import 'package:easy_stock_app/controllers/providers/purchase_request/bpo/bpoProvider.dart';
import 'package:easy_stock_app/models/purchase/bpo_details_model.dart';
import 'package:easy_stock_app/models/purchase/bpo_model.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/common_widgets/background_image_widget.dart';
import '../../../../utils/constants/colors/colors.dart';

class BpoDetailsPage extends StatefulWidget {
  String productID;
  Item data;
  bool isLast;
  BpoDetailsPage(
      {super.key,
      required this.productID,
      required this.data,
      required this.isLast});

  @override
  State<BpoDetailsPage> createState() => _BpoDetailsPageState();
}

class _BpoDetailsPageState extends State<BpoDetailsPage> {
  bool isLoading = true;
  int? selectedIndex;
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool isvisible = false;
  int visibleindex = -1;
  Set<int> selectedItems = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<BpoProvider>(context, listen: false)
          .productDetails(widget.productID)
          .then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final bpodetailsProvider = Provider.of<BpoProvider>(context);

    Widget _editQuantity(int index) {
      TextEditingController quantityController = TextEditingController(
        text: double.parse(bpodetailsProvider.details[index].qty)
            .toStringAsFixed(2),
      );
      TextEditingController priceController = TextEditingController(
        text: double.parse(bpodetailsProvider.details[index].total)
            .toStringAsFixed(2),
      );

      // Show custom dialog using showDialog

      return Container(
        width: screenWidth * 0.85,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: screenWidth * 0.23,
                  height: screenHeight * 0.05,
                  child: TextField(
                    controller: quantityController,
                    cursorColor: primaryColor,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    keyboardType: TextInputType.number,
                    onSubmitted: (value) {
                      yesnoAlertDialog(
                        context: context,
                        message: "Do you want to Update?",
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        onNo: () {
                          Navigator.pop(context);
                        },
                        onYes: () {
                          bpodetailsProvider.updateData(
                            widget.productID,
                            bpodetailsProvider.details[index].orderId,
                            quantityController.text,
                            false,
                            false,
                            context,
                            priceController.text,
                            bpodetailsProvider.details[index].editNo,
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        buttonNoText: "No",
                        buttonYesText: "Yes",
                      );
                    },
                    decoration: InputDecoration(
                      label: const Text('Quantity'),
                      labelStyle: const TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                      hintText: 'Enter new quantity',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white24, width: 1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: screenWidth * 0.23,
                  height: screenHeight * 0.05,
                  child: TextField(
                    controller: priceController,
                    cursorColor: primaryColor,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    keyboardType: TextInputType.number,
                    onSubmitted: (value) {
                      yesnoAlertDialog(
                        context: context,
                        message: "Do you want to Update?",
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        onNo: () {
                          Navigator.pop(context);
                        },
                        onYes: () {
                          bpodetailsProvider.updateData(
                            widget.productID,
                            bpodetailsProvider.details[index].orderId,
                            quantityController.text,
                            false,
                            false,
                            context,
                            priceController.text,
                            bpodetailsProvider.details[index].editNo,
                          );
                          if (widget.isLast) {
                            Navigator.pop(context);
                          }
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        buttonNoText: "No",
                        buttonYesText: "yes",
                      );
                    },
                    decoration: InputDecoration(
                      label: const Text('Price'),
                      labelStyle: const TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                      hintText: 'Enter new price',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white24, width: 1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),

                // Update Button
                SizedBox(
                  width: screenWidth * 0.2,
                  height: screenHeight * 0.05,
                  child: GestureDetector(
                    onTap: () {
                      yesnoAlertDialog(
                        context: context,
                        message: "Do you want to Update?",
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        onNo: () {
                          bpodetailsProvider.updateData(
                            widget.productID,
                            bpodetailsProvider.details[index].orderId,
                            quantityController.text,
                            true,
                            false,
                            context,
                            priceController.text,
                            bpodetailsProvider.details[index].editNo,
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        onYes: () {
                          bpodetailsProvider.updateData(
                            widget.productID,
                            bpodetailsProvider.details[index].orderId,
                            quantityController.text,
                            false,
                            true,
                            context,
                            priceController.text,
                            bpodetailsProvider.details[index].editNo,
                          );
                          if (widget.isLast) {
                            Navigator.pop(context);
                          }
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        buttonNoText: "NoStock",
                        buttonYesText: "Completed",
                        title2: "NoStock",
                        title1: "Complete",
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: primaryColor, width: 1),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Update",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    //   if (result != null && result.isNotEmpty) {
    //     setState(() {
    //       bpodetailsProvider.details[index].qty = result;
    //     });
    //   }
    // }

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          // Positioned(
          //     top: screenHeight * 0.05,
          //     left: screenWidth * 0.05,
          //     child: CustomAppBar(txt: "BPO Details")),
          Positioned(
            top: screenHeight * 0.05,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back,
                                color: Colors.white, size: 22)),
                        const SizedBox(width: 6),
                        const Text(
                          "BPO Details",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shopping_bag_outlined,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.data.productName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${double.parse(widget.data.qty).toStringAsFixed(2)} ${widget.data.uomCode}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'AED ${double.parse(widget.data.price).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Consumer<BpoProvider>(
                    builder: (context, provider, child) {
                      return Container(
                          height: screenHeight * 0.54,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24, width: 1),
                          ),
                          child: isLoading || bpodetailsProvider.isLoading
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
                                        "Loading details...",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : provider.details.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.shopping_cart_outlined,
                                            size: 48,
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            "No Details Found",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.all(12),
                                      itemCount: provider.details.length,
                                      itemBuilder: (context, index) {
                                        BpoDetailsDatum detail =
                                            provider.details[index];
                                        bool isChecked =
                                            selectedItems.contains(index);

                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: Colors.white24,
                                                  width: 1),
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // ✅ Checkbox Column
                                                      Column(
                                                        children: [
                                                          Checkbox(
                                                            value: isChecked,
                                                            activeColor:
                                                                primaryColor,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                if (value ==
                                                                    true) {
                                                                  selectedItems
                                                                      .add(
                                                                          index);
                                                                } else {
                                                                  selectedItems
                                                                      .remove(
                                                                          index);
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(width: 8),
                                                      // ✅ Text & Data Column
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              detail
                                                                  .customerName,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 8),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.1),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(4),
                                                                  ),
                                                                  child: Text(
                                                                    '${double.parse(detail.qty).toStringAsFixed(2)} ${detail.uomCode}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color:
                                                                          primaryColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 8),
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: primaryColor
                                                                        .withOpacity(
                                                                            0.2),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(4),
                                                                  ),
                                                                  child: Text(
                                                                    'AED ${double.parse(detail.total).toStringAsFixed(2)}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color:
                                                                          primaryColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // ✅ Edit Button
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedIndex =
                                                                (selectedIndex ==
                                                                        index)
                                                                    ? null
                                                                    : index;
                                                            quantityController
                                                                .text = double
                                                                    .parse(detail
                                                                        .qty)
                                                                .toStringAsFixed(
                                                                    2);
                                                            priceController
                                                                .text = double
                                                                    .parse(detail
                                                                        .total)
                                                                .toStringAsFixed(
                                                                    2);
                                                            isvisible =
                                                                !isvisible;
                                                          });
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 6),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white24,
                                                                width: 1),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              const Text(
                                                                'Edit',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 4),
                                                              Icon(
                                                                Icons
                                                                    .edit_outlined,
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.7),
                                                                size: 16,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (selectedIndex == index)
                                                  _editQuantity(index),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )

                          // : ListView.builder(
                          //     padding: const EdgeInsets.all(12),
                          //     itemCount: provider.details.length,
                          //     itemBuilder: (context, index) {
                          //       BpoDetailsDatum detail =
                          //           provider.details[index];
                          //       return Padding(
                          //         padding:
                          //             const EdgeInsets.only(bottom: 12),
                          //         child: Container(
                          //           decoration: BoxDecoration(
                          //             color:
                          //                 Colors.white.withOpacity(0.1),
                          //             borderRadius:
                          //                 BorderRadius.circular(12),
                          //             border: Border.all(
                          //                 color: Colors.white24,
                          //                 width: 1),
                          //           ),
                          //           child: Column(
                          //             children: [
                          //               Padding(
                          //                 padding:
                          //                     const EdgeInsets.all(16),
                          //                 child: Row(
                          //                   crossAxisAlignment:
                          //                       CrossAxisAlignment.start,
                          //                   children: [
                          //                     Expanded(
                          //                       child: Column(
                          //                         crossAxisAlignment:
                          //                             CrossAxisAlignment
                          //                                 .start,
                          //                         children: [
                          //                           Text(
                          //                             detail.customerName,
                          //                             style:
                          //                                 const TextStyle(
                          //                               fontSize: 16,
                          //                               fontWeight:
                          //                                   FontWeight
                          //                                       .w600,
                          //                               color:
                          //                                   Colors.white,
                          //                             ),
                          //                           ),
                          //                           const SizedBox(
                          //                               height: 8),
                          //                           Row(
                          //                             children: [
                          //                               Container(
                          //                                 padding: const EdgeInsets
                          //                                     .symmetric(
                          //                                     horizontal:
                          //                                         8,
                          //                                     vertical:
                          //                                         4),
                          //                                 decoration:
                          //                                     BoxDecoration(
                          //                                   color: Colors
                          //                                       .white
                          //                                       .withOpacity(
                          //                                           0.1),
                          //                                   borderRadius:
                          //                                       BorderRadius
                          //                                           .circular(
                          //                                               4),
                          //                                 ),
                          //                                 child: Text(
                          //                                   '${double.parse(detail.qty).toStringAsFixed(2)} ${detail.uomCode}',
                          //                                   style:
                          //                                       const TextStyle(
                          //                                     fontSize:
                          //                                         14,
                          //                                     fontWeight:
                          //                                         FontWeight
                          //                                             .w500,
                          //                                     color:
                          //                                         primaryColor,
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                               const SizedBox(
                          //                                   width: 8),
                          //                               Container(
                          //                                 padding: const EdgeInsets
                          //                                     .symmetric(
                          //                                     horizontal:
                          //                                         8,
                          //                                     vertical:
                          //                                         4),
                          //                                 decoration:
                          //                                     BoxDecoration(
                          //                                   color: primaryColor
                          //                                       .withOpacity(
                          //                                           0.2),
                          //                                   borderRadius:
                          //                                       BorderRadius
                          //                                           .circular(
                          //                                               4),
                          //                                 ),
                          //                                 child: Text(
                          //                                   'AED ${double.parse(detail.total).toStringAsFixed(2)}',
                          //                                   style:
                          //                                       const TextStyle(
                          //                                     fontSize:
                          //                                         14,
                          //                                     fontWeight:
                          //                                         FontWeight
                          //                                             .w500,
                          //                                     color:
                          //                                         primaryColor,
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                             ],
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                     GestureDetector(
                          //                       onTap: () {
                          //                         setState(() {
                          //                           if (selectedIndex ==
                          //                               index) {
                          //                             selectedIndex =
                          //                                 null;
                          //                           } else {
                          //                             selectedIndex =
                          //                                 index;
                          //                           }
                          //                         });
                          //                         setState(() {
                          //                           quantityController
                          //                               .text = double.parse(
                          //                                   bpodetailsProvider
                          //                                       .details[
                          //                                           index]
                          //                                       .qty)
                          //                               .toStringAsFixed(
                          //                                   2);
                          //                           priceController
                          //                               .text = double.parse(
                          //                                   bpodetailsProvider
                          //                                       .details[
                          //                                           index]
                          //                                       .total)
                          //                               .toStringAsFixed(
                          //                                   2);
                          //                           isvisible =
                          //                               !isvisible;
                          //                         });
                          //                       },
                          //                       child: Container(
                          //                         padding:
                          //                             const EdgeInsets
                          //                                 .symmetric(
                          //                                 horizontal: 12,
                          //                                 vertical: 6),
                          //                         decoration:
                          //                             BoxDecoration(
                          //                           color: Colors.white
                          //                               .withOpacity(0.1),
                          //                           borderRadius:
                          //                               BorderRadius
                          //                                   .circular(6),
                          //                           border: Border.all(
                          //                               color: Colors
                          //                                   .white24,
                          //                               width: 1),
                          //                         ),
                          //                         child: Row(
                          //                           mainAxisSize:
                          //                               MainAxisSize.min,
                          //                           children: [
                          //                             const Text(
                          //                               'Edit',
                          //                               style: TextStyle(
                          //                                 color:
                          //                                     primaryColor,
                          //                                 fontWeight:
                          //                                     FontWeight
                          //                                         .w500,
                          //                                 fontSize: 14,
                          //                               ),
                          //                             ),
                          //                             const SizedBox(
                          //                                 width: 4),
                          //                             Icon(
                          //                               Icons
                          //                                   .edit_outlined,
                          //                               color: Colors
                          //                                   .white
                          //                                   .withOpacity(
                          //                                       0.7),
                          //                               size: 16,
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //               if (selectedIndex == index)
                          //                 _editQuantity(index),
                          //             ],
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          );
                    },
                  ),
                  if (bpodetailsProvider.price.isNotEmpty && !isLoading)
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.shopping_cart_outlined,
                                  color: Colors.white70, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                "Total Items:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${bpodetailsProvider.details.length}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.payments_outlined,
                                  color: primaryColor, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                "Total Amount:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                bpodetailsProvider.price,
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  if (!isLoading)
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              yesnoAlertDialog(
                                context: context,
                                message: "Do you want to mark as No Stock?",
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                                onNo: () {
                                  Navigator.pop(context);
                                },
                                onYes: () {
                                  bpodetailsProvider.updateData(
                                    widget.productID,
                                    '-1',
                                    '0',
                                    true,
                                    false,
                                    context,
                                    '0',
                                    '-1',
                                  );
                                  if (widget.isLast) {
                                    Navigator.pop(context);
                                  }
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                buttonNoText: "No",
                                buttonYesText: "Yes",
                              );
                              setState(() {
                                isLoading = true;
                              });
                              Provider.of<BpoProvider>(context, listen: false)
                                  .productDetails(widget.productID)
                                  .then((_) {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            },
                            child: Container(
                              height: screenHeight * 0.06,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red, width: 1),
                              ),
                              child: const Center(
                                child: Text(
                                  "No Stock",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              yesnoAlertDialog(
                                context: context,
                                message: "Do you want to mark as Completed?",
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                                onNo: () {
                                  Navigator.pop(context);
                                },
                                onYes: () {
                                  bpodetailsProvider.updateData(
                                    widget.productID,
                                    '-1',
                                    '0',
                                    false,
                                    true,
                                    context,
                                    '0',
                                    '-1',
                                  );
                                  if (widget.isLast) {
                                    Navigator.pop(context);
                                  }
                                  Navigator.pop(context);
                                  if (bpodetailsProvider.isLoading) {
                                    Navigator.pop(context);
                                  }
                                },
                                buttonNoText: "No",
                                buttonYesText: "Yes",
                              );
                              setState(() {
                                isLoading = true;
                              });
                              Provider.of<BpoProvider>(context, listen: false)
                                  .productDetails(widget.productID)
                                  .then((_) {
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            },
                            child: Container(
                              height: screenHeight * 0.06,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 213, 210, 4),
                                    Color.fromARGB(255, 210, 136, 0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: primaryColor, width: 1),
                              ),
                              child: const Center(
                                child: Text(
                                  "Complete",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: screenHeight * 0.04),
                ],
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
    BpoProvider provider, {
    required bool isConfirm,
    required double screenHeight,
    required double screenWidth,
  }) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(5),
      child: GestureDetector(
        onTap: () {
          if (text == "Confirm") {
            yesnoAlertDialog(
              context: context,
              message: "Do you want to Confirm Order?",
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              onNo: () {
                Navigator.pop(context);
              },
              onYes: () {
                // if (isConfirm) {
                //   provider.confirmFunction(provider.cartItems, context);
                // }
                Future.delayed(const Duration(seconds: 2)).then((_) {
                  Navigator.pop(context);
                  // Navigator.pop(context);
                });
              },
              buttonNoText: "No",
              buttonYesText: "Yes",
            );
          } else {
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

  // Helper method to build content text with consistent style
  Widget _buildContentText(String label, String value, double screenWidth) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(width: screenWidth * 0.08),
      ],
    );
  }
}
