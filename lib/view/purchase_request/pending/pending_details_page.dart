import 'package:easy_stock_app/controllers/providers/purchase_request/pending/pending_provider.dart';
import 'package:easy_stock_app/models/purchase/pending/pending_details_model.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase_request/common_widgets/buildTextRow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/common_widgets/background_image_widget.dart';

class PendingDetailsPage extends StatefulWidget {
  String orderID, editNo;
  PendingDetailsPage({
    super.key,
    required this.orderID,
    required this.editNo,
  });

  @override
  State<PendingDetailsPage> createState() => _PendingDetailsPageState();
}

class _PendingDetailsPageState extends State<PendingDetailsPage> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<PendingProvider>(context, listen: false)
          .initializeDetails(orderID: widget.orderID, editNo: widget.editNo)
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
            child: CustomAppBar(txt: 'Pending'),
          ),
          Positioned(
            top: screenHeight * 0.13,
            left: 20,
            right: 20,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isLoading
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
                        : Expanded(
                            child: ListView.builder(
                                padding:
                                    const EdgeInsets.only(bottom: 25, top: 25),
                                itemCount: provider.pendingDetails.length,
                                itemBuilder: (context, index) {
                                  PendingDetailsData detail =
                                      provider.pendingDetails[index];

                                  return Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      height: screenHeight * 0.09,
                                      width: screenWidth * 0.06,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: screenHeight * 0.04,
                                            width: screenWidth * 0.12,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.network(
                                                detail.imageUrl.toString(),
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Icon(
                                                  Icons.image,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   width: screenWidth * 0.00,
                                          // ),
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
                                                  // SizedBox(
                                                  //   width: screenWidth * 0.001,
                                                  // ),
                                                  SizedBox(
                                                    width: screenWidth * 0.5,
                                                    child: Text(
                                                      detail.productName,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                          fontSize: 14), overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * 0.001,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.01,
                                              ),
                                              Row(
                                                children: [
                                                  buildContentText(
                                                      "Qty:",
                                                      double.parse(detail.qty)
                                                          .toStringAsFixed(2),
                                                      screenWidth),
                                                  buildContentText(
                                                      "Price:",
                                                      double.parse(detail.price)
                                                          .toStringAsFixed(2),
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
                                        ],
                                      ),
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
}
