import 'package:easy_stock_app/controllers/providers/purchase_request/vehicle/vehicleProvider.dart';
import 'package:easy_stock_app/models/purchase_order/bpo_vehicle_details_model.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase_request/vehicle_details/vehicle_details_page/productSummaryPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/common_widgets/background_image_widget.dart';

class VehicleDetailsPage extends StatefulWidget {
  final String id, driverName;
  VehicleDetailsPage({super.key, required this.id, required this.driverName});

  @override
  State<VehicleDetailsPage> createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BpoVehicleProvider>(context, listen: false)
          .fetchVehicleData(widget.id);
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
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                              horizontal: screenWidth * 0.05),
                          child: Container(
                            height: screenHeight * 0.05,
                            width: screenWidth * 0.85,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Text(
                                    widget.driverName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                            : SizedBox(
                              height: screenHeight*0.68,
                              child: ListView.builder(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10, right: 10, bottom: 55),
                                  itemCount:
                                      bpoVehicleProvider.vehicleData.length,
                                  shrinkWrap: true,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    bpoVehicleDatum data =
                                        bpoVehicleProvider.vehicleData[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Productsummarypage(
                                                      id: data.productId
                                                          .toString(),
                                                    )
                                               
                                                ),
                                          );
                                        },
                                        child: Container(
                                          height: screenHeight * 0.092,
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
                                                Center(
                                                  child: Container(
                                                    height: screenHeight *
                                                        0.075, // Adjust image height
                                                    width: screenWidth *
                                                        0.2, // Adjust image width
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12), // Rounded corners
                                                      // You can adjust the border radius value to make the corners more or less rounded
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15), // Apply rounded corners to the image as well
                                                      child: Image.network(
                                                        data.imageUrl,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            const Icon(
                                                          Icons.panorama,
                                                          size: 45,
                                                          color: Color.fromARGB(
                                                              255, 97, 92, 74),
                                                        ),
                                                      ),
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
                                                        data.productName,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                      ),
                                    );
                                  },
                                ),
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
