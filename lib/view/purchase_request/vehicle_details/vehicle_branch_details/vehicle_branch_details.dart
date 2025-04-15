import 'package:easy_stock_app/controllers/providers/purchase_request/vehicle/vehicleProvider.dart';
import 'package:easy_stock_app/models/purchase_order/bpo_customer_model.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase_request/vehicle_details/invoice/invoice_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/common_widgets/background_image_widget.dart';
import '../../../../utils/constants/colors/colors.dart';

class VehicleBranchDetailsPage extends StatefulWidget {
  String customerID, customerName;
  VehicleBranchDetailsPage(
      {super.key, required this.customerID, required this.customerName});

  @override
  State<VehicleBranchDetailsPage> createState() =>
      _VehicleBranchDetailsPageState();
}

class _VehicleBranchDetailsPageState extends State<VehicleBranchDetailsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<BpoVehicleProvider>(context, listen: false)
        .fetchCustomerData(widget.customerID);
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
          Positioned(
              top: screenHeight * 0.053,
              left: screenWidth * 0.05,
              child: CustomAppBar(txt: "Vehicle Details")),
          Positioned(
            top: screenHeight * 0.14,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                  child: SizedBox(
                    width: screenWidth * 0.88,
                    child: const Text(
                      "Check all pending and skipped items easily on the Items View Page.",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: Container(
                    height: screenHeight * 0.05,
                    width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: primaryColor,
                            child: Text(
                              widget.customerName.isEmpty
                                  ? 'C'
                                  : widget.customerName[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.customerName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                bpoVehicleProvider.customerData.isEmpty
                    ? const Center(
                        child: Text(
                          "No data",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: screenHeight * 0.65,
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                            bottom: screenHeight * 0.01,
                            top: screenHeight * 0.01,
                          ),
                          itemCount: bpoVehicleProvider.customerData.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final bpoCustomerDatum data =
                                bpoVehicleProvider.customerData[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: screenHeight * 0.1,
                                width: screenWidth * 0.8,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.025,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.03),
                                        child: Container(
                                          height: screenHeight * 0.06,
                                          width: screenWidth * 0.15,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                10), // Rounded corners
                                            child: Image.network(
                                              data.imageUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(Icons.image,
                                                      size: 40,
                                                      color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // CircleAvatar(
                                      //   radius: 15,
                                      //   backgroundColor: primaryColor,
                                      //   child: Text(
                                      //     data.productName.isEmpty
                                      //         ? 'P'
                                      //         : data.productName[0]
                                      //             .toUpperCase(),
                                      //     style: const TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.w600,
                                      //       color: Colors.black,
                                      //     ),
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   width: screenWidth * 0.025,
                                      // ),
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
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(
                                              height: screenHeight * 0.005),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: screenWidth * 0.25,
                                                child: Text(
                                                  "Price: ${double.parse(data.price).toStringAsFixed(2)} AED",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.25,
                                                child: Text(
                                                  "Qty: ${double.parse(data.qty).toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: screenHeight * 0.005),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: screenWidth * 0.25,
                                                child: Text(
                                                  "Uom: ${data.uomCode}",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: screenHeight * 0.005),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                SizedBox(height: screenHeight * 0.02),
                bpoVehicleProvider.customerData.isEmpty
                    ? SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InvoicePage(
                                          dataList: bpoVehicleProvider
                                              .customerData,
                                              customername:widget.customerName.isEmpty?"":widget.customerName)));
                            },
                            child: Container(
                              height: screenHeight * 0.04,
                              width: screenWidth * 0.3,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Center(
                                child: Text(
                                  "Invoice",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
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
        ],
      ),
    );
  }
}
