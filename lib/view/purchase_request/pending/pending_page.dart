import 'package:easy_stock_app/controllers/providers/purchase_request/pending/pending_provider.dart';
import 'package:easy_stock_app/models/purchase/pending/bpo_pending_model.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase_request/common_widgets/buildTextRow.dart';
import 'package:easy_stock_app/view/purchase_request/pending/pending_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/common_widgets/background_image_widget.dart';
import '../../../utils/constants/colors/colors.dart';

class RequestPendingPage extends StatefulWidget {
  RequestPendingPage({super.key});

  @override
  State<RequestPendingPage> createState() => _RequestPendingPageState();
}

class _RequestPendingPageState extends State<RequestPendingPage> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<PendingProvider>(context, listen: false)
          .initializeData()
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

    final provider = Provider.of<PendingProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: CustomAppBar(txt: "Pending"),
          ),
          Positioned(
            top: screenHeight * 0.13,
            left: 20,
            right: 20,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Check all pending and skipped items easily on the Items View Page.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Text(
                    "Pending",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                ),
                isLoading
                    ? SizedBox(
                        height: screenHeight * 0.3,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : provider.pendingBPOs.isEmpty
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
                        : Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 10),
                              itemCount: provider.pendingBPOs.length,
                              itemBuilder: (context, index) {
                                PendingData detail =
                                    provider.pendingBPOs[index];
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                        Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PendingDetailsPage(
                                                          orderID:
                                                              detail.orderId,
                                                          editNo: detail.editNo,
                                                        )));
                                    },
                                    child: Container(
                                      height: screenHeight * 0.095,
                                      width: screenWidth * 0.8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CircleAvatar(
                                            radius: 17,
                                            backgroundColor: primaryColor,
                                            child: Center(
                                              child: Text(
                                                detail.customerName[0]
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: screenHeight * 0.03,
                                                      width: screenWidth * 0.55,
                                                      child: Text(
                                                        detail.customerName,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    buildContentText(
                                                        "LPO:",
                                                        "${detail.orderId}",
                                                        screenWidth),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    buildContentText(
                                                        "Total Items:",
                                                        detail.totalItems,
                                                        screenWidth),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PendingDetailsPage(
                                                            orderID:
                                                                detail.orderId,
                                                            editNo: detail.editNo,
                                                          )));
                                            },
                                            child: const Icon(
                                              Icons.visibility,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.03),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
