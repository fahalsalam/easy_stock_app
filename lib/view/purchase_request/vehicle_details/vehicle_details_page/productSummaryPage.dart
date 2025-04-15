import 'package:easy_stock_app/controllers/providers/purchase_request/vehicle/vehicleProvider.dart';
import 'package:easy_stock_app/models/purchase_order/vehiclesummarymodel.dart';
import 'package:easy_stock_app/utils/common_widgets/background_image_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Productsummarypage extends StatefulWidget {
  String id;
  Productsummarypage({super.key, required this.id});

  @override
  State<Productsummarypage> createState() => _ProductsummarypageState();
}

class _ProductsummarypageState extends State<Productsummarypage> {
  bool isLoading =true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BpoVehicleProvider>(context, listen: false)
          .fetchProductSummary(widget.id).then((_){
            isLoading=false;
          });
    });
  }

  @override
  Widget build(BuildContext context) {
  final bpoVehicleProvider = Provider.of<BpoVehicleProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.053),
                CustomAppBar(txt: "Vehicle Details"),
                SizedBox(height: screenHeight * 0.05),
                Center(
                  child: Container(
                    width: screenWidth * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      isLoading?SizedBox(
                        height: screenHeight*0.5,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ):
                        bpoVehicleProvider.vehicleData.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    "No Data",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 15),
                                itemCount:
                                    bpoVehicleProvider.productData.length,
                                shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                               ProductSummaryDatum data =
                                      bpoVehicleProvider.productData[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Container(
                                      height: screenHeight * 0.085,
                                      width: screenWidth * 0.8,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                width: screenWidth * 0.03),
                                           
                                            CircleAvatar(
                                              radius: 18,
                                              backgroundColor: primaryColor,
                                              child: Text(
                                                data.productName.isEmpty
                                                    ? 'P'
                                                    : data.productName[0]
                                                        .toUpperCase(),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: screenWidth * 0.03),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: screenWidth * 0.5,
                                             
                                                  child: Text(
                                                    //  'fsdbmbsdsbnfsafvdfnsadsfdbvsda',
                                                      data.productName,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),SizedBox(
                                                  width: screenWidth * 0.5,
                                                  child: Text(
                                                   'Customer Name: ${data.customerName}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "Total Qty: ${double.parse(data.totalQty).toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                        SizedBox(height: screenHeight * 0.03),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
