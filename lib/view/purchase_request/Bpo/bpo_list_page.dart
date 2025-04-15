import 'dart:developer';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/view/purchase_request/Bpo/bpo_details/bpo_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/providers/purchase_request/bpo/bpoProvider.dart';
import '../../../utils/common_widgets/background_image_widget.dart';
import '../../../utils/common_widgets/custom_appbar.dart';
import '../../../utils/constants/images/images.dart';
import '../../../models/purchase/bpo_model.dart';

class BpoListPage extends StatefulWidget {
  String id;
  List<Item> items;
  BpoListPage({Key? key, required this.id, required this.items})
      : super(key: key);

  @override
  State<BpoListPage> createState() => _BpoListPageState();
}

class _BpoListPageState extends State<BpoListPage> with RouteAware {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadData();
    log('log form init ,len: ${widget.items.length}');
    isLoading = false;
  }

  void _loadData() async {
    try {
      await Provider.of<BpoProvider>(context, listen: false).fetchData();
      await Provider.of<BpoProvider>(context, listen: false)
          .fetchDatabyid(widget.id);
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

Future<void> _loadDatas() async {
  setState(() {
    isLoading = true;
  });
  try {
    final bpoProvider = Provider.of<BpoProvider>(context, listen: false);
    await bpoProvider.fetchData();
    await bpoProvider.fetchDatabyid(widget.id);
  } catch (e) {
    log('Error fetching data: $e');
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    final bpoProvider = Provider.of<BpoProvider>(context);
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
            child: CustomAppBar(txt: "BPO"),
          ),
          Positioned(
            top: screenHeight * 0.13,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenWidth * 0.87,
                  child: const Text(
                    "See all the requested items here. You can view all items on a single page.",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                bpoProvider.isLoading || isLoading
                    ? _buildShimmerLoading(screenHeight,
                        screenWidth) // Shimmer effect when loading
                    : bpoProvider.products.isEmpty
                        ? const Center(
                            child: Text(
                              "No Data",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : Center(
                            child: Consumer<BpoProvider>(
                                builder: (context, provider, child) {
                              return Container(
                                height: screenHeight * 0.8,
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 50),
                                  itemCount: provider.products.length,
                                  itemBuilder: (context, index) {
                                    Item data = provider.products[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BpoDetailsPage(
                                              productID: data.productId,
                                              data: data,
                                            ),
                                          ),
                                        ).then((_) {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          _loadData();

                                          Future.delayed(
                                              const Duration(seconds: 2));

                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: screenHeight * 0.082,
                                          width: screenWidth * 0.75,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5.0,
                                              horizontal: 5,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  height: screenHeight * 0.045,
                                                  width: screenWidth * 0.01,
                                                  decoration: BoxDecoration(
                                                      // color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Image.network(
                                                    data.imageUrl,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Icon(
                                                      Icons.image,
                                                      color: Colors.grey,
                                                      size: 28,
                                                    ),
                                                  ),
                                                ),

                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data.productName,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${double.parse(data.qty).toStringAsFixed(2)} ${data.uomCode}',
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  primaryColor),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SizedBox(
                                                          width: screenWidth *
                                                              0.15,
                                                        ),
                                                        Text(
                                                          'AED ${double.parse(data.price).toStringAsFixed(2)} ',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .grey),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                // GestureDetector(
                                                //     onTap: () {
                                                //       _openEditPriceDialog(
                                                //         context,
                                                //         double.parse(
                                                //             data.price),
                                                //         int.parse(
                                                //             data.productId),
                                                //         screenWidth,
                                                //         screenHeight,
                                                //         bpoProvider,
                                                //       );
                                                //     },
                                                //     child: Material(
                                                //       elevation: 5,
                                                //       borderRadius:
                                                //           BorderRadius.circular(
                                                //               8),
                                                //       child: Container(
                                                //         height: screenHeight *
                                                //             0.034,
                                                //         width:
                                                //             screenWidth * 0.2,
                                                //         decoration:
                                                //             BoxDecoration(
                                                //           color: primaryColor,
                                                //           borderRadius:
                                                //               BorderRadius
                                                //                   .circular(8),
                                                //         ),
                                                //         child: const Center(
                                                //             child: FittedBox(
                                                //           child: Text(
                                                //               'Edit Price',
                                                //               style: TextStyle(
                                                //                   color: Colors
                                                //                       .black,
                                                //                   fontSize: 13,
                                                //                   fontWeight:
                                                //                       FontWeight
                                                //                           .w600)),
                                                //         )),
                                                //       ),
                                                //     ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ),
              ],
            ),
          ),
        ],
      ),
    );
  }

void _openEditPriceDialog(BuildContext context, double value, int id,
    double screenWidth, double screenHeight, BpoProvider bpoProvider) {
  final TextEditingController _priceController =
      TextEditingController(text: value.toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey.withOpacity(0.53),
        title: const Text(
          "Price",
          style: TextStyle(
              color: Color.fromARGB(255, 193, 191, 191),
              fontSize: 17,
              fontWeight: FontWeight.w600),
        ),
        content: Container(
          width: screenWidth * 0.08,
          height: screenHeight * 0.0454,
          decoration: BoxDecoration(
              color: Colors.grey.shade100.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8)),
          child: TextField(
            controller: _priceController,
            decoration: const InputDecoration(
              hintText: 'Enter Price',
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final updatedPrice = _priceController.text;
              if (updatedPrice.isNotEmpty) {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  await bpoProvider.updateBulkPrice(
                    productId: id,
                    price: double.parse(updatedPrice),
                    context: context,
                  );
                  // Reload data after updating
                  await _loadDatas();
                } catch (e) {
                  log('Error updating price: $e');
                }
              } else {
                showSnackBar(context, "", 'Enter valid data', Colors.red);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: const Text(
              "Update",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without saving
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text(
              "Cancel",
              style: TextStyle(color: primaryColor),
            ),
          ),
        ],
      );
    },
  );
}








  // void _openEditPriceDialog(BuildContext context, double value, int id,
  //     double screenWidth, double screenHeight, BpoProvider bpoProvider) {
  //   final TextEditingController _priceController =
  //       TextEditingController(text: value.toString());

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.grey.withOpacity(0.53),
  //         title: const Text(
  //           "Price",
  //           style: TextStyle(
  //               color: Color.fromARGB(255, 193, 191, 191),
  //               fontSize: 17,
  //               fontWeight: FontWeight.w600),
  //         ),
  //         content: Container(
  //           width: screenWidth * 0.08,
  //           height: screenHeight * 0.0454,
  //           decoration: BoxDecoration(
  //               color: Colors.grey.shade100.withOpacity(0.8),
  //               borderRadius: BorderRadius.circular(8)),
  //           child: TextField(
  //             controller: _priceController,
  //             decoration: const InputDecoration(

  //                 // labelText: 'Price', // Label for the TextField
  //                 ),
  //             keyboardType:
  //                 TextInputType.number, // Set the keyboard type to number
  //           ),
  //         ),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () {
  //               String updatedPrice = _priceController.text;
  //               if (updatedPrice.isNotEmpty) {
  //                 Navigator.of(context).pop();
  //                 bpoProvider
  //                     .updateBulkPrice(
  //                         productId: id,
  //                         price: double.parse(_priceController.text),
  //                         context: context)
  //                     .then((_) {
  //                   _loadDatas();
  //                 });
  //                 print("Updated price: $updatedPrice");
  //               } else {
  //                 showSnackBar(context, "", 'Enter valid data', Colors.red);
  //               }
  //               // Close the dialog
  //             },
  //             style: ElevatedButton.styleFrom(backgroundColor: primaryColor
  //                 // primary: Colors.green, // Change button color
  //                 ),
  //             child: const Text(
  //               "Update",
  //               style: TextStyle(
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog without saving
  //             },
  //             style: ElevatedButton.styleFrom(backgroundColor: Colors.black
  //                 // primary: Colors.red, // Change cancel button color
  //                 ),
  //             child: const Text(
  //               "Cancel",
  //               style: TextStyle(
  //                 color: primaryColor,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}

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

Widget _buildShimmerLoading(double screenHeight, double screenWidth) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[700]!,
    highlightColor: Colors.grey[400]!,
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // Number of shimmer items to show
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(8),
          width: screenWidth * 0.9,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    ),
  );
}
