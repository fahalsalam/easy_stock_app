import 'package:easy_stock_app/controllers/providers/masters_provider/vehicle_management_provider/vehicle_management_provider.dart';
import 'package:easy_stock_app/models/masters/category_list_model.dart';
import 'package:easy_stock_app/models/masters/vehicle_masters/vehicleDetailModel.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/masters/vehicle_management/vehicle_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/common_widgets/background_image_widget.dart';

class VechicleDetailPage extends StatefulWidget {
  VehicleDatum vehicledata;
  VechicleDetailPage({super.key, required this.vehicledata});

  @override
  State<VechicleDetailPage> createState() => _VechicleDetailPageState();
}

class _VechicleDetailPageState extends State<VechicleDetailPage> {
    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VehicleManagementProvider>(context, listen: false)
          . fetchCategory();
      // Provider.of<Vehicleimagepicker>(context, listen: false).removeImage();
    });
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
final vehicleManagementProvider =
        Provider.of<VehicleManagementProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: CustomAppBar(txt: "Vehicle Management"),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: screenWidth >= 600
                  ? screenHeight * 0.078 + kToolbarHeight
                  : screenHeight * 0.041 + kToolbarHeight,
              left: 15.0,
              right: 15.0,
              bottom: 20.0,
            ),
            child: ListView(
              children: [
                Container(  margin: EdgeInsets.symmetric(horizontal: 15),
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox( width: screenWidth*0.5,
                          height: screenHeight*0.2,
                        child: Image.network(
                          width: screenWidth*0.5,
                          height: screenHeight*0.2,
                          widget.vehicledata.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.panorama,
                            size: 85,
                            color: Colors.white,
                          ),
                        ),
                      ),
                       Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                         widget.vehicledata.vehicleName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VehicleDetailRow(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        title: "Driver",
                        value: widget.vehicledata.driverName,
                      ),
                      VehicleDetailRow(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        title: "Contact",
                        value: widget.vehicledata.contactNo,
                      ),
                      VehicleDetailRow(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        title: "Plate Number",
                        value: widget.vehicledata.vehicleNumber,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.vehicledata.customers.isEmpty
                              ? ""
                              : "Assigned Customers",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      widget.vehicledata.customers.isEmpty
                          ? Container()
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.vehicledata.customers.length,
                              itemBuilder: (context, index) {
                                return AssignedDetails(
                                    screenHeight,
                                    screenWidth,
                                    widget.vehicledata.customers[index]
                                        .customerName);
                              }),
                      SizedBox(
                        height: screenHeight * .02,
                      ),
                      Visibility(
                        visible: widget.vehicledata.categories.length!=0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.vehicledata.customers.isEmpty
                                ? ""
                                : "Assigned Category",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                      widget.vehicledata.customers.isEmpty
                          ? Container()
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount:  widget.vehicledata.categories.length,
                                  itemBuilder: (context, index) {
                               Category category= widget.vehicledata.categories[index];
                                return AssignedCategoryDetails(
                                    screenHeight,
                                    screenWidth,
                                    category
                                       );
                              }),
                      SizedBox(
                        height: screenHeight * .02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VehicleDetailsEditPage(
                                              vehicleData:
                                                  widget.vehicledata)));
                            },
                            child: Container(
                              height: screenHeight * 0.045,
                              width: screenWidth * 0.3,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(
                                      color: primaryColor, width: 0.8),
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Center(
                                child: Text(
                                  "Change",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget VehicleDetailRow(
      {required double screenWidth,
      required double screenHeight,
      required String title,
      required String value}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth * 0.4,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const Text(
            ":",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          SizedBox(
            width: screenWidth * 0.25,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget AssignedCategoryDetails(double screenHeight, double screenWidth,   Category category) {
    return Container(
      height: screenHeight * 0.045,
      width: screenWidth * 0.4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: screenWidth * 0.48,
              child: Text(
                category.categoryName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget AssignedDetails(double screenHeight, double screenWidth, String txt) {
    return Container(
      height: screenHeight * 0.045,
      width: screenWidth * 0.4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: screenWidth * 0.48,
              child: Text(
                txt,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
