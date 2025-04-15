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
  BpoDetailsPage({super.key, required this.productID, required this.data});

  @override
  State<BpoDetailsPage> createState() => _BpoDetailsPageState();
}

class _BpoDetailsPageState extends State<BpoDetailsPage> {
  bool isLoading = true;int? selectedIndex; 
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool isvisible = false;
  int visibleindex = -1;
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

      return Center(
        child: Container(
          width: screenWidth * 0.85,
          // height: screenHeight * 0.1,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
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
                            // title2: "NoStock",
                            // title1: "Complete",
                          );
                        },
                        decoration: InputDecoration(
                          label: Text('Qty'),
                          labelStyle: const TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                          hintText: 'Enter new quantity',
                          hintStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 103, 101, 101),
                                width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: primaryColor, width: 2.0),
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
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
                            buttonYesText: "yes",
                            // title2: "NoStock",
                            // title1: "Complete",
                          );
                        },
                        decoration: InputDecoration(
                          label: Text('Price'),
                          labelStyle: const TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                          hintText: 'Enter new price',
                          hintStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 103, 101, 101),
                                width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: primaryColor, width: 2.0),
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
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: primaryColor, width: 0.8),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Update",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
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
          ),
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
          Positioned(
              top: screenHeight * 0.053,
              left: screenWidth * 0.05,
              child: CustomAppBar(txt: "Bpo")),
          Positioned(
              top: screenHeight * 0.13,
              left: 20,
              right: 20,
              child: Column(children: [
                Container(
                  height: screenHeight * 0.16,
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0.85, color: primaryColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name Row
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: Text(
                                widget.data.productName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        // Quantity and UOM Code & Price Row
                        Row(
                          children: [
                            const SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: Text(
                                '${double.parse(widget.data.qty).toStringAsFixed(2)} ${widget.data.uomCode}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'AED ${double.parse(widget.data.price).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Info Section with Icon
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'If everything looks good, just hit finish \nand all your orders will be saved in one go!',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<BpoProvider>(builder: (context, provider, child) {
                  return SizedBox(
                    height: screenHeight * 0.5,
                    child: isLoading || bpodetailsProvider.isLoading
                        ? SizedBox(
                            height: screenHeight * 0.3,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : provider.details.isEmpty
                            ? const Center(
                                child: Text(
                                  "Empty data",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.only(bottom: 10, top: 10),
                                shrinkWrap: true,
                                itemCount: provider.details.length,
                                itemBuilder: (context, index) {
                                  BpoDetailsDatum detail =
                                      provider.details[index];
                                  return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        height: screenHeight * 0.18,
                                        width: screenWidth * 0.8,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.black.withOpacity(0.42),
                                        ),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            screenHeight * 0.03,
                                                        width:
                                                            screenWidth * 0.55,
                                                        child: Text(
                                                          detail.customerName,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            'Qty',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: screenWidth *
                                                                0.08,
                                                          ),
                                                          Text(
                                                            double.parse(
                                                                    detail.qty)
                                                                .toStringAsFixed(
                                                                    2),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          Text(
                                                            ' ${detail.uomCode}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () { setState(() {
                                        // Toggle visibility logic
                                        if (selectedIndex == index) {
                                          selectedIndex = null; // Deselect if clicked again
                                        } else {
                                          selectedIndex = index; // Set the clicked index
                                        }
                                      });
                                                          // _editQuantity(index);
                                                          setState(() {
                                                            quantityController
                                                                .text = double.parse(
                                                                    bpodetailsProvider
                                                                        .details[
                                                                            index]
                                                                        .qty)
                                                                .toStringAsFixed(
                                                                    2);
                                                            priceController
                                                                .text = double.parse(
                                                                    bpodetailsProvider
                                                                        .details[
                                                                            index]
                                                                        .total)
                                                                .toStringAsFixed(
                                                                    2);
                                                            isvisible =
                                                                !isvisible;
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color: Colors
                                                                  .grey.shade100
                                                                  .withOpacity(
                                                                      0.2)),
                                                          child: const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        5),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text('Edit',
                                                                    style: TextStyle(
                                                                        color:
                                                                            primaryColor,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                                SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Icon(
                                                                  Icons.edit,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          202,
                                                                          199,
                                                                          199),
                                                                  size: 15,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 2,
                                                      ),
                                                      Text(
                                                        'AED ${double.parse(detail.total).toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.03,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Visibility(
                                                visible: selectedIndex == index,
                                                child: _editQuantity(index),
                                              ),
                                            ]),
                                      ));
                                }),
                  );
                }),
                bpodetailsProvider.price.isEmpty
                    ? Container()
                    : Visibility(
                        visible: !isLoading,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: SizedBox(
                            height: screenHeight * 0.1,
                            width: screenWidth * 0.9,
                            child: Column(
                              children: [
                                SizedBox(height: screenHeight * 0.02),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: screenWidth * 0.3,
                                      child: const Text(
                                        "Total Item: ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      " ${bpodetailsProvider.details.length} ",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.003,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: screenWidth * 0.3,
                                      child: const Text(
                                        "Total Amount: ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      " ${bpodetailsProvider.price} ",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: screenHeight * 0.01),
                Visibility(
                  visible: !isLoading,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(8),
                            child: GestureDetector(
                              onTap: () {
                                yesnoAlertDialog(
                                  context: context,
                                  message:
                                      "Do you want to \n marked as Nostock?",
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

                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    // Navigator.pop(context);
                                  },
                                  buttonNoText: "No",
                                  buttonYesText: "Yes",
                                );
                                // refresh data

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
                                height: screenHeight * 0.051,
                                width: screenWidth * 0.4,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.red, width: 0.8)),
                                alignment: Alignment.centerLeft,
                                child: const Center(
                                  child: Text(
                                    "No Stock",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(8),
                            child: GestureDetector(
                              onTap: () {
                                yesnoAlertDialog(
                                  context: context,
                                  message:
                                      "Do you want to \n marked as Completed?",
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
                                    Navigator.pop(context);
                                    if (bpodetailsProvider.isLoading)
                                      Navigator.pop(context);
                                    // Navigator.pop(context);
                                  },
                                  buttonNoText: "No",
                                  buttonYesText: "Yes",
                                );
                                // refresh data

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
                                height: screenHeight * 0.051,
                                width: screenWidth * 0.4,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 213, 210, 4),
                                        Color.fromARGB(255, 210, 136, 0),
                                      ], // Gradient colors
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    // color: primaryColor,
                                    // borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: primaryColor, width: 0.8)),
                                alignment: Alignment.centerLeft,
                                child: const Center(
                                  child: Text(
                                    "Complete",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
              ])),
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
