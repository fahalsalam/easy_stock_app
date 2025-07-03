import 'package:easy_stock_app/controllers/providers/purchase_providers/history/historyProvider.dart';
import 'package:easy_stock_app/models/purchase_order/historyModel/history_totallistmodel.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/common_widgets/background_image_widget.dart';

class HistoryTotalItemListPage extends StatefulWidget {
  final String orderId, editno;
  HistoryTotalItemListPage(
      {super.key, required this.orderId, required this.editno});

  @override
  State<HistoryTotalItemListPage> createState() =>
      _HistoryTotalItemListPageState();
}

class _HistoryTotalItemListPageState extends State<HistoryTotalItemListPage> {
  late Future<void> _fetchDetailsFuture;

  @override
  void initState() {
    super.initState();
    _fetchDetailsFuture =
        Provider.of<PurchaseHistoryProvider>(context, listen: false)
            .fetchDetails(editNo: widget.editno, orderId: widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final historyProvider = Provider.of<PurchaseHistoryProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: CustomAppBar(txt: "History"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.history, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Total Item List",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white12, width: 1),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: Colors.white70, size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Note: Always recheck whenever you confirm the order",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: FutureBuilder<void>(
                      future: _fetchDetailsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                              strokeWidth: 3,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "An error occurred",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (historyProvider.details.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 48,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "No History Found",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: Colors.white24, width: 1),
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: historyProvider.details.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = historyProvider.details[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildOrderItem(
                                    item,
                                    index,
                                    context,
                                    historyProvider,
                                    screenHeight,
                                    screenWidth,
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                if (historyProvider.details.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.01),
                    child: _buildSummary(
                        context, historyProvider, screenWidth, screenHeight),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, PurchaseHistoryProvider provider,
      double screenWidth, double screenHeight) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            "Total Items",
            provider.details.length.toStringAsFixed(2),
            Icons.shopping_bag_outlined,
          ),
          const Divider(color: Colors.white24, height: 24),
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
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isTotal ? primaryColor : Colors.white,
            fontSize: 15,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isTotal ? primaryColor : Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(
      HistoryDetailss item,
      int index,
      BuildContext context,
      PurchaseHistoryProvider provider,
      double screenHeight,
      double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Row(
        children: [
          Container(
            height: screenHeight * 0.06,
            width: screenWidth * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image, size: 24, color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildTag(
                        'Qty: ${double.parse(item.qty).toStringAsFixed(2)}'),
                    const SizedBox(width: 6),
                    _buildTag(
                        '${double.parse(item.price).toStringAsFixed(2)} AED',
                        isPrice: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, {bool isPrice = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isPrice
            ? primaryColor.withOpacity(0.2)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isPrice ? primaryColor : Colors.white70,
          fontSize: 12,
        ),
      ),
    );
  }
}



// import 'package:easy_stock_app/controllers/providers/purchase_providers/history/historyProvider.dart';
// import 'package:easy_stock_app/models/purchase_order/order_details_model.dart';
// import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
// import 'package:easy_stock_app/utils/constants/images/images.dart';
// import 'package:easy_stock_app/view/purchase/edit_request/edit_order_widgets/editTextfield_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../../utils/common_widgets/background_image_widget.dart';

// class HistoryTotalItemListPage extends StatefulWidget {
//   String orderId, editno;
//   HistoryTotalItemListPage(
//       {super.key, required this.orderId, required this.editno});

//   @override
//   State<HistoryTotalItemListPage> createState() =>
//       _HistoryTotalItemListPageState();
// }

// class _HistoryTotalItemListPageState extends State<HistoryTotalItemListPage> {
//   bool  isLoading=true;
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<PurchaseHistoryProvider>(context, listen: false)
//           .fetchDetails(editNo: widget.editno, orderId: widget.orderId);
//         Future.delayed(Duration(seconds: 3));
//           isLoading=false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenHeight = MediaQuery.of(context).size.height;
//     var screenWidth = MediaQuery.of(context).size.width;
//     final historyProvider = Provider.of<PurchaseHistoryProvider>(context);

//     return Scaffold(
//         body: Stack(
//       children: [
//         BackgroundImageWidget(image: common_backgroundImage),
//         Positioned(
//             top: screenHeight * 0.05,
//             left: screenWidth * 0.05,
//             child: CustomAppBar(txt: "History")),
//         Positioned(
//           top: screenHeight * 0.13,
//           left: 0,
//           right: 0,
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Total Item List",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                         color: Colors.white),
//                   ),
//                   SizedBox(
//                     height: screenHeight * 0.008,
//                   ),
//                   const Text(
//                     "Note : Always recheck whenever you confirm the order",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w300,
//                         fontSize: 12,
//                         color: Colors.white),
//                   ),
//                   isLoading
//                       ? SizedBox(
//                           height: screenHeight * 0.8,
//                           child: Center(
//                               child: CircularProgressIndicator(
//                             color: Colors.white,
//                           )),
//                         )
//                       : historyProvider.details.isEmpty
//                           ? SizedBox(
//                               height: screenHeight * 0.3,
//                               child: const Center(
//                                 child: Text(
//                                   "No Data",
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 20),
//                                 ),
//                               ),
//                             )
//                           : SizedBox(
//                               height: screenHeight * 0.65,
//                               child: ListView.builder(
//                                 padding: EdgeInsets.only(bottom: 50),
//                                 itemCount: historyProvider.details.length,
//                                 shrinkWrap: true,
//                                 itemBuilder: (context, index) {
//                                   final item = historyProvider.details[index];
//                                   return Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: _buildOrderItem(
//                                         item,
//                                         index,
//                                         context,
//                                         historyProvider,
//                                         screenHeight,
//                                         screenWidth),
//                                   );
//                                 },
//                               ),
                            
//                             ),
//                   SizedBox(
//                     height: screenHeight * 0.01,
//                   ),
//                   _buildSummary(
//                       context, historyProvider, screenWidth, screenHeight),
                
//                   SizedBox(
//                     height: screenHeight * 0.01,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     ));
//   }

//   Widget _buildSummary(BuildContext context, PurchaseHistoryProvider provider,
//       double screenWidth, double screenHeight) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
//       child: Column(
//         children: [
//           _buildSummaryRow("Total Items", provider.details.length.toString()),
//           SizedBox(
//             height: screenHeight * 0.008,
//           ),
//           _buildSummaryRow("Grand Total", provider.getPrice()),
//           // _buildSummaryRow("Grand Total", "2700.00"),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummaryRow(String label, String value) {
//     return Row(
//       children: [
//         SizedBox(
//           width: 100,
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//               fontSize: 15,
//             ),
//           ),
//         ),
//         const Text(" : "),
//         Text(
//           value,
//           style: const TextStyle(
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//             fontSize: 14,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildOrderItem(
//       Detail item,
//       int index,
//       BuildContext context,
//       PurchaseHistoryProvider provider,
//       double screenHeight,
//       double screenWidth) {
//     return Container(
//       height: screenHeight * 0.12,
//       width: screenWidth * 0.06,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: Colors.grey.withOpacity(0.2),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
//             child: Container(
//               height: screenHeight * 0.06,
//               width: screenWidth * 0.15,
//               decoration: const BoxDecoration(shape: BoxShape.circle
//                   // borderRadius: BorderRadius.circular(10),
//                   ),
//               child: ClipOval(
//                 // borderRadius: BorderRadius.circular(10),
//                 child: Image.network(
//                   item.imageUrl,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) =>
//                       const Icon(Icons.image, size: 40, color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // SizedBox(height: 0.05,),
//               SizedBox(
//                 height: screenHeight * 0.03,
//                 width: screenWidth * 0.48,
//                 child: Text(
//                   item.productName,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   Text(
//                     "${item.unit} kg",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w400,
//                       color: Colors.white,
//                       fontSize: 14,
//                     ),
//                   ),
//                   SizedBox(width: screenWidth * 0.03),
//                   Row(
//                     children: [
//                       Text(
//                         "Qty: ${item.qty}",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white,
//                           fontSize: 14,
//                         ),
//                       ),
                      
//                     ],
//                   ),
//                 ],
//               ),
//               Text(
//                 "${provider.getItemPrice(index, item.qty)} AED",
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w400,
//                   color: Colors.white,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
          
//           const SizedBox(
//             width: 0.02,
//           )
//         ],
//       ),
//     );
//   }
// }
// // SizedBox(
//                       //   width: screenWidth * 0.2,
//                       //   child: QtyButtonWidget(
//                       //     screenHeight: screenHeight,
//                       //     screenWidth: screenWidth,
//                       //     initialQuantity: item.qty,
//                       //     onSubmit: (value) {
//                       //       if (value.isNotEmpty) {
//                       //         setState(() {
//                       //           provider.details[index].qty = value;
//                       //         });
//                       //       }
//                       //     },
//                       //   ),
// // const Spacer(),
//           // IconButton(
//           //   onPressed: () async {
//           //     await _editQuantity(context, index, provider);
//           //   },
//           //   icon: const Icon(
//           //     Icons.edit,
//           //     color: Colors.white,
//           //     size: 20,
//           //   ),
//           // ),
//   // Column(
//                   //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   //   children: [
//                   //     Row(
//                   //       children: [
//                   //         SizedBox(
//                   //           width: screenWidth * 0.25,
//                   //           child: const Text(
//                   //             "Total  Qty",
//                   //             style: TextStyle(
//                   //                 fontWeight: FontWeight.w400,
//                   //                 color: Colors.white,
//                   //                 fontSize: 14),
//                   //           ),
//                   //         ),
//                   //         Padding(
//                   //           padding: EdgeInsets.symmetric(
//                   //               horizontal: screenHeight * 0.004),
//                   //           child: const Text(
//                   //             "-",
//                   //             style: TextStyle(
//                   //                 fontWeight: FontWeight.w400,
//                   //                 color: Colors.white,
//                   //                 fontSize: 14),
//                   //           ),
//                   //         ),
//                   //         const Text(
//                   //           "110",
//                   //           style: TextStyle(
//                   //               fontWeight: FontWeight.w400,
//                   //               color: Colors.white,
//                   //               fontSize: 14),
//                   //         ),
//                   //       ],
//                   //     ),
//                   //     Row(
//                   //       children: [
//                   //         SizedBox(
//                   //           width: screenWidth * 0.25,
//                   //           child: const Text(
//                   //             "Price Total",
//                   //             style: TextStyle(
//                   //                 fontWeight: FontWeight.w400,
//                   //                 color: Colors.white,
//                   //                 fontSize: 14),
//                   //           ),
//                   //         ),
//                   //         Padding(
//                   //           padding: EdgeInsets.symmetric(
//                   //               horizontal: screenHeight * 0.004),
//                   //           child: const Text(
//                   //             "-",
//                   //             style: TextStyle(
//                   //                 fontWeight: FontWeight.w400,
//                   //                 color: Colors.white,
//                   //                 fontSize: 14),
//                   //           ),
//                   //         ),
//                   //         const Text(
//                   //           "3000.000",
//                   //           style: TextStyle(
//                   //               fontWeight: FontWeight.w500,
//                   //               color: Colors.white,
//                   //               fontSize: 14),
//                   //         ),
//                   //       ],
//                   //     ),
//                   //     Row(
//                   //       children: [
//                   //         SizedBox(
//                   //           width: screenWidth * 0.25,
//                   //           child: const Text(
//                   //             "VAT",
//                   //             style: TextStyle(
//                   //                 fontWeight: FontWeight.w400,
//                   //                 color: Colors.green,
//                   //                 fontSize: 14),
//                   //           ),
//                   //         ),
//                   //         Padding(
//                   //           padding: EdgeInsets.symmetric(
//                   //               horizontal: screenHeight * 0.004),
//                   //           child: const Text(
//                   //             "-",
//                   //             style: TextStyle(
//                   //                 fontWeight: FontWeight.w400,
//                   //                 color: Colors.green,
//                   //                 fontSize: 14),
//                   //           ),
//                   //         ),
//                   //         const Text(
//                   //           "10%",
//                   //           style: TextStyle(
//                   //               fontWeight: FontWeight.w500,
//                   //               color: Colors.green,
//                   //               fontSize: 14),
//                   //         ),
//                   //       ],
//                   //     ),
//                   //     Row(
//                   //       children: [
//                   //         SizedBox(
//                   //           width: screenWidth * 0.25,
//                   //           child: const Text(
//                   //             " Grand Total ",
//                   //             style: TextStyle(
//                   //                 fontWeight: FontWeight.w400,
//                   //                 color: Colors.white,
//                   //                 fontSize: 14),
//                   //           ),
//                   //         ),
//                   //         Padding(
//                   //           padding: EdgeInsets.symmetric(
//                   //               horizontal: screenHeight * 0.004),
//                   //           child: const Text(
//                   //             "-",
//                   //             style: TextStyle(
//                   //                 fontWeight: FontWeight.w400,
//                   //                 color: Colors.white,
//                   //                 fontSize: 14),
//                   //           ),
//                   //         ),
//                   //         const Text(
//                   //           " 2700.00",
//                   //           style: TextStyle(
//                   //               fontWeight: FontWeight.w500,
//                   //               color: Colors.white,
//                   //               fontSize: 14),
//                   //         ),
//                   //       ],
//                   //     ),
//                   //   ],
//                   // ),
//   // child: ListView.builder(
//                               //     padding: EdgeInsets.zero,
//                               //     itemCount: 15,
//                               //     shrinkWrap: true,
//                               //     itemBuilder: (context, index) {
//                               //       List<String> imageList = [
//                               //         "assets/images/itemlist_apple.png",
//                               //         "assets/images/itemlist_mango.png",
//                               //         "assets/images/itemlist_potato.png",
//                               //         "assets/images/tomato.png",
//                               //         "assets/images/itemlist_apple.png",
//                               //         "assets/images/itemlist_mango.png",
//                               //         "assets/images/itemlist_potato.png",
//                               //         "assets/images/tomato.png",
//                               //         "assets/images/itemlist_apple.png",
//                               //         "assets/images/itemlist_mango.png",
//                               //         "assets/images/itemlist_potato.png",
//                               //         "assets/images/tomato.png",
//                               //         "assets/images/itemlist_apple.png",
//                               //         "assets/images/itemlist_mango.png",
//                               //         "assets/images/itemlist_potato.png",
//                               //         "assets/images/tomato.png"
//                               //       ];
//                               //       List<String> productName = [
//                               //         "Apple",
//                               //         "Mango",
//                               //         "Potato",
//                               //         "Tomato",
//                               //         "Apple",
//                               //         "Mango",
//                               //         "Potato",
//                               //         "Tomato",
//                               //         "Apple",
//                               //         "Mango",
//                               //         "Potato",
//                               //         "Tomato",
//                               //         "Apple",
//                               //         "Mango",
//                               //         "Potato",
//                               //         "Tomato",
//                               //       ];
//                               //       return Padding(
//                               //         padding: const EdgeInsets.all(8.0),
//                               //         child: Container(
//                               //           height: screenHeight * 0.063,
//                               //           width: screenWidth * 0.06,
//                               //           decoration: BoxDecoration(
//                               //             borderRadius: BorderRadius.circular(15),
//                               //             color: Colors.grey.withOpacity(0.2),
//                               //           ),
//                               //           child: Row(
//                               //             mainAxisAlignment:
//                               //                 MainAxisAlignment.spaceEvenly,
//                               //             children: [
//                               //               SizedBox(
//                               //                 width: screenWidth * 0.00,
//                               //               ),
//                               //               Container(
//                               //                 height: screenHeight * 0.04,
//                               //                 width: screenWidth * 0.12,
//                               //                 decoration: const BoxDecoration(),
//                               //                 child: ClipRRect(
//                               //                   child: Image.asset(
//                               //                     imageList[index],
//                               //                     fit: BoxFit.cover,
//                               //                   ),
//                               //                 ),
//                               //               ),
//                               //               SizedBox(
//                               //                 width: screenWidth * 0.001,
//                               //               ),
//                               //               Text(
//                               //                 productName[index],
//                               //                 style: const TextStyle(
//                               //                     fontWeight: FontWeight.w500,
//                               //                     color: Colors.white,
//                               //                     fontSize: 14),
//                               //               ),
//                               //               SizedBox(
//                               //                 width: screenWidth * 0.001,
//                               //               ),
//                               //               const Text(
//                               //                 "75.00 kg",
//                               //                 style: TextStyle(
//                               //                     fontWeight: FontWeight.w400,
//                               //                     color: Colors.white,
//                               //                     fontSize: 13),
//                               //               ),
//                               //               Padding(
//                               //                 padding: const EdgeInsets.symmetric(
//                               //                     vertical: 10.0),
//                               //                 child: VerticalDivider(
//                               //                   thickness: 1,
//                               //                   color: Colors.grey.withOpacity(0.2),
//                               //                 ),
//                               //               ),
//                               //               Row(
//                               //                 mainAxisAlignment:
//                               //                     MainAxisAlignment.spaceEvenly,
//                               //                 children: [
//                               //                   IconButton(
//                               //                       onPressed: () {},
//                               //                       icon: const Icon(
//                               //                         Icons.edit,
//                               //                         color: Colors.white,
//                               //                         size: 22,
//                               //                       )),
//                               //                   IconButton(
//                               //                       onPressed: () {},
//                               //                       icon: const Icon(
//                               //                         Icons.delete,
//                               //                         color: Colors.white,
//                               //                         size: 22,
//                               //                       ))
//                               //                 ],
//                               //               )
//                               //             ],
//                               //           ),
//                               //         ),
//                               //       );
//                               //     }),