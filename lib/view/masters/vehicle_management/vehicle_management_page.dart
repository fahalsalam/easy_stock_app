import 'package:easy_stock_app/controllers/providers/masters_provider/vehicle_management_provider/vehicle_management_provider.dart';
import 'package:easy_stock_app/models/masters/vehicle_masters/vehicleDetailModel.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/masters/vehicle_management/add_vehiclepage.dart';
import 'package:easy_stock_app/view/masters/vehicle_management/vehicle_detail_page/vehicle_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/common_widgets/background_image_widget.dart';

class MastersVehicleManagementPage extends StatefulWidget {
  const MastersVehicleManagementPage({super.key});

  @override
  State<MastersVehicleManagementPage> createState() =>
      _MastersVehicleManagementPageState();
}

class _MastersVehicleManagementPageState
    extends State<MastersVehicleManagementPage> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VehicleManagementProvider>(context, listen: false)
          .fetchData();
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
          Positioned(
            top: screenHeight * 0.14,
            left: 15,
            right: 15,
            child: Container(
              height: screenHeight * 0.98,
              width: screenWidth * 0.95,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: vehicleManagementProvider.data.isEmpty
                  ? const Center(
                      child: Text(
                        "No Data",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.3),
                      itemCount: vehicleManagementProvider.data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        VehicleDatum vehicleData = vehicleManagementProvider
                                .data[
                            vehicleManagementProvider.data.length - 1 - index];
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VechicleDetailPage(
                                          vehicledata: vehicleData))).then((_) {
                                isLoading = true;
                                vehicleManagementProvider.fetchData().then((_) {
                                  isLoading = false;
                                });
                              });
                            },
                            child: Container(
                              height: screenHeight * 0.17,
                              width: screenWidth * 0.85,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.grey.shade800, Colors.black],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 20),
                                    CircleAvatar(
                                      backgroundColor: primaryColor,
                                      radius: 24,
                                      child: Text(
                                        vehicleData.vehicleName.isNotEmpty
                                            ? vehicleData.vehicleName[0]
                                                .toUpperCase()
                                            : 'V',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 25),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            vehicleData.vehicleName,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.person,
                                                size: 16,
                                                color: primaryColor,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                vehicleData.driverName,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white70,
                                                ), overflow:
                                                          TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.call,
                                                size: 16,
                                                color: primaryColor,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                vehicleData.contactNo,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white70,
                                                ), overflow:
                                                          TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.directions_car,
                                                size: 16,
                                                color: primaryColor,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                vehicleData.vehicleNumber,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white70,
                                                ), overflow:
                                                          TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MastersAddvehiclePage()),
          ).then((_) {
            isLoading = true;
            vehicleManagementProvider.fetchData().then((_) {
              isLoading = false;
            });
          });
        },
        backgroundColor: primaryColor.withOpacity(0.5),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
