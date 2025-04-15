import 'dart:developer';
import 'package:easy_stock_app/controllers/providers/purchase_providers/po_provider/po_provider.dart';
import 'package:easy_stock_app/models/purchase_order/lpoModel.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase_request/po/po_details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/common_widgets/background_image_widget.dart';


class PoPage extends StatefulWidget {
  const PoPage({super.key});

  @override
  State<PoPage> createState() => _PoPageState();
}

class _PoPageState extends State<PoPage> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PoProvider>(context, listen: false).fetchData().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final poListProvider = Provider.of<PoProvider>(context);
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
                    const Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "This Is Actual Requested Orders",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: screenHeight * 0.8,
                      child: isLoading
                          ? _buildShimmerLoading(screenHeight, screenWidth)
                          : poListProvider.lpoData.isEmpty
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
                                  itemCount: poListProvider.lpoData.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final lpodata =
                                        poListProvider.lpoData[index];
                                    return buildLpoItem(
                                        context,
                                        lpodata,
                                        screenHeight,
                                        screenWidth,
                                        index,
                                        poListProvider);
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

  Widget buildLpoItem(
      BuildContext context,
      lpoDatum lpodata,
      double screenHeight,
      double screenWidth,
      int index,
      PoProvider poListProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          log("${lpodata.orderId}, ${lpodata.editNo}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoDetailsPage(
                orderId: lpodata.orderId.toString(),
                editNo: lpodata.editNo.toString(),
                customerName:
                    lpodata.customerName.isEmpty ? "" : lpodata.customerName,
                companyname: poListProvider.companyname,
                country: poListProvider.country,
                state: poListProvider.state,
                trnno: poListProvider.trnno,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          height: screenHeight * 0.072,
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
              color: Colors.grey.shade100.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: primaryColor, width: 0.52)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.4,
                        child: Text(
                          lpodata.customerName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        DateFormat('hh:mm a').format(lpodata.orderDate),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "LPO: #${lpodata.orderId}",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                  // Text(
                  //   DateFormat('hh:mm a').format(lpodata.orderDate),
                  //   style: const TextStyle(
                  //     fontSize: 8,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.white,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
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
            height: screenHeight * 0.072,
            width: screenWidth * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          );
        },
      ),
    );
  }
}
