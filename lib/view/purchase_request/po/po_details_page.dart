import 'package:easy_stock_app/controllers/providers/purchase_providers/lpoList_providers/lpoList_provider.dart';
import 'package:easy_stock_app/models/purchase_order/order_details_model.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase_request/po/po_invoice_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/common_widgets/background_image_widget.dart';

class PoDetailsPage extends StatefulWidget {
  final String orderId;
  final String editNo;
  final String customerName;
    String companyname;
  String country;
  String state;
  String trnno;
 PoDetailsPage(
      {super.key,
      required this.orderId,
      required this.editNo,
      required this.customerName,
       required this.companyname,
      required this.country,
      required this.state,
      required this.trnno
      });

  @override
  State<PoDetailsPage> createState() => _PoDetailsPageState();
}

class _PoDetailsPageState extends State<PoDetailsPage> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LpolistProvider>(context, listen: false)
          .fetchDetails(orderId: widget.orderId, editNo: widget.editNo)
          .then((_) {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final lpoListProvider = Provider.of<LpolistProvider>(context);
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
            child: CustomAppBar(txt: "Purchase Orders"),
          ),
          Positioned(
            top: screenHeight * 0.13,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: screenWidth * 0.8,
                          child: const Text(
                            "You can’t edit anything here, but you can check out Actual Received orders!",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(10),
                          child: GestureDetector(
                            onTap: () async {
                              // Push to the EditOrderListPage
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => poinvoicePage(
                                    dataList: lpoListProvider.details,
                                    lpoNumber: widget.orderId.toString(),
                                    customerName: widget.customerName,
                                     companyname:
                                                      widget.companyname,
                                                  country: widget.country,
                                                  state: widget.state,
                                                  trnno: widget.trnno,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: screenHeight * 0.035,
                              width: screenWidth * 0.2,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(width: 1, color: primaryColor),
                              ),
                              child: const Center(
                                child: Text(
                                  "Preview",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: screenHeight * 0.8,
                      child: isLoading
                          ? _buildShimmerLoading(screenHeight, screenWidth)
                          : lpoListProvider.details.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No Product Data",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  itemCount: lpoListProvider.details.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final lpodata =
                                        lpoListProvider.details[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: _buildOrderItem(
                                          lpodata,
                                          index,
                                          context,
                                          lpoListProvider,
                                          screenHeight,
                                          screenWidth),
                                    );
                                  }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Detail item, int index, BuildContext context,
      LpolistProvider provider, double screenHeight, double screenWidth) {
    return 
      // visible: item.itemStatus != 'NoStock',
     Container(
        height: screenHeight * 0.12,
        width: screenWidth * 0.06,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey.withOpacity(0.2),
            border: Border.all(color: primaryColor, width: 0.52)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
                child: Container(
              height: screenHeight * 0.07,
              width: screenWidth * 0.18,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Rounded corners
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image, size: 40, color: Colors.white),
                ),
              ),
            )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(height: 0.05,),
                SizedBox(
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.48,
                  child: Text(
                    item.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Uom: ${item.uomCode}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Text(
                      "Qty: ${double.parse(item.qty).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${double.parse(item.price).toStringAsFixed(2)} AED",
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              
              ],
            ),
          ],
        ),
     
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
          height: screenHeight * 0.12,
        width: screenWidth * 0.06,
            decoration: BoxDecoration(
              color: Colors.white,
               borderRadius: BorderRadius.circular(15),
            ),
          );
        },
      ),
    );
  }
}
