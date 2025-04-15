import 'dart:developer';

import 'package:easy_stock_app/controllers/providers/purchase_request/completed/completed_provider.dart';
import 'package:easy_stock_app/models/purchase/pending/pending_details_model.dart';
import 'package:easy_stock_app/utils/common_widgets/background_image_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase_request/common_widgets/buildTextRow.dart';
import 'package:easy_stock_app/view/purchase_request/completed/completed_invoice_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompletedDetailsPage extends StatefulWidget {
  String orderID, editNo, customerName, orderId;
  String companyname;
  String country;
  String state;
  String trnno;
  CompletedDetailsPage(
      {super.key,
      required this.orderID,
      required this.editNo,
      required this.customerName,
      required this.orderId,
      required this.companyname,
      required this.country,
      required this.state,
      required this.trnno
      });

  @override
  State<CompletedDetailsPage> createState() => _CompletedDetailsPageState();
}

class _CompletedDetailsPageState extends State<CompletedDetailsPage> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<CompletedProvider>(context, listen: false)
          .initializeDetails(orderID: widget.orderID, editNo: widget.editNo)
          .then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  Future<void> _loadDatas() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<CompletedProvider>(context, listen: false)
          .initializeDetails(
        orderID: widget.orderID,
        editNo: widget.editNo,
      );
    } catch (e) {
      log('Error reloading data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    final provider = Provider.of<CompletedProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            BackgroundImageWidget(image: common_backgroundImage),
            Positioned(
              top: screenHeight * 0.06,
              left: screenWidth * 0.02,
              right: screenWidth * 0.02,
              child: CustomAppBar(txt: 'Completed'),
            ),
            Positioned(
              top: screenHeight * 0.13,
              left: 20,
              right: 20,
              bottom: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isLoading || provider.isLoading
                      ? SizedBox(
                          height: screenHeight * 0.5,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : provider.pendingDetails.isEmpty
                          ? SizedBox(
                              height: screenHeight * 0.3,
                              child: const Center(
                                child: Text(
                                  "No Data",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Material(
                                      elevation: 3,
                                      borderRadius: BorderRadius.circular(10),
                                      child: GestureDetector(
                                        onTap: () async {
                                          try {
                                            // Push to the EditOrderListPage
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CompletedInvoicePage(
                                                  dataList:
                                                      provider.pendingDetails,
                                                  lpoNumber:
                                                      widget.orderId.toString(),
                                                  customerName:
                                                      widget.customerName,
                                                  companyname:
                                                      widget.companyname,
                                                  country: widget.country,
                                                  state: widget.state,
                                                  trnno: widget.trnno,
                                                ),
                                              ),
                                            );

                                            // After returning from EditOrderListPage, fetch new data
                                            // await Provider.of<LpolistProvider>(context,
                                            //         listen: false)
                                            //     .fetchData();
                                          } catch (e) {
                                            // Handle any errors that occur during navigation or data fetching
                                            log("Error occurred: $e");
                                            // Optionally show a flushbar or dialog to notify the user
                                          }
                                        },
                                        child: Container(
                                          height: screenHeight * 0.035,
                                          width: screenWidth * 0.2,
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 1, color: primaryColor),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Invoice",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  height: screenHeight * 0.78,
                                  //  color: Colors.red,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.only(
                                          bottom: 155, top: 25),
                                      itemCount: provider.pendingDetails.length,
                                      itemBuilder: (context, index) {
                                        PendingDetailsData detail =
                                            provider.pendingDetails[index];

                                        return Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Container(
                                            height: screenHeight * 0.09,
                                            width: screenWidth * 0.056,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  height: screenHeight * 0.04,
                                                  width: screenWidth * 0.12,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image.network(
                                                      detail.imageUrl
                                                          .toString(),
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          const Icon(
                                                        Icons.image,
                                                        size: 30,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
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
                                                              .spaceEvenly,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              screenWidth * 0.5,
                                                          child: Text(
                                                            detail.productName,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: screenWidth *
                                                              0.001,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          screenHeight * 0.01,
                                                    ),
                                                    Row(
                                                      children: [
                                                        buildContentText(
                                                            "Qty:",
                                                            double.parse(
                                                                    detail.qty)
                                                                .toStringAsFixed(
                                                                    2),
                                                            screenWidth),
                                                        buildContentText(
                                                            "Price:",
                                                            double.parse(detail
                                                                    .price)
                                                                .toStringAsFixed(
                                                                    2),
                                                            screenWidth),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        buildContentText(
                                                            "Uom:",
                                                            detail.uomCode,
                                                            screenWidth),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _openEditPriceDialog(
                                                        context,
                                                        double.parse(
                                                            detail.price),
                                                        int.parse(
                                                            detail.productId),
                                                        screenWidth,
                                                        screenHeight,
                                                        provider);
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                    size: 25,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openEditPriceDialog(BuildContext context, double value, int id,
      double screenWidth, double screenHeight, CompletedProvider provider) {
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

                  // labelText: 'Price', // Label for the TextField
                  ),
              keyboardType:
                  TextInputType.number, // Set the keyboard type to number
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final updatedPrice = _priceController.text;
                if (updatedPrice.isNotEmpty) {
                  Navigator.of(context).pop(); // Close the dialog
                  setState(() {
                    isLoading = true;
                  });

                  try {
                    await provider.updateBulkPrice(
                      productId: id,
                      price: double.parse(updatedPrice),
                      context: context,
                      orderid: widget.orderID, 
                      editno:  widget.editNo
                    );

                    // Reload the data
                    await _loadDatas();
                  } catch (e) {
                    log('Error updating price: $e');
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                } else {
                  showSnackBar(context, "", 'Enter valid data', Colors.red);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor
                  // primary: Colors.green, // Change button color
                  ),
              child: const Text(
                "Update",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black
                  // primary: Colors.red, // Change cancel button color
                  ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
