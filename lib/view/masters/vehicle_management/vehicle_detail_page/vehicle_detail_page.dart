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
          .fetchCategory();
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
            child: CustomAppBar(txt: "Vehicle Details"),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: screenWidth >= 600
                  ? screenHeight * 0.078 + kToolbarHeight
                  : screenHeight * 0.041 + kToolbarHeight,
              left: 12.0,
              right: 12.0,
              bottom: 12.0,
            ),
            child: ListView(
              children: [
                // Vehicle Image and Name Card
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey.shade800.withOpacity(0.8),
                        Colors.black.withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: Container(
                          height: screenHeight * 0.2,
                          width: double.infinity,
                          color: Colors.grey.withOpacity(0.1),
                          child: Image.network(
                            widget.vehicledata.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                              child: Icon(
                                Icons.directions_car,
                                size: 60,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.vehicledata.vehicleName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: primaryColor.withOpacity(0.5)),
                              ),
                              child: Text(
                                widget.vehicledata.vehicleNumber,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Driver Information Card
                _buildInfoCard(
                  title: "Driver Information",
                  icon: Icons.person,
                  child: Column(
                    children: [
                      _buildInfoRow(
                        icon: Icons.person_outline,
                        label: "Driver Name",
                        value: widget.vehicledata.driverName,
                      ),
                      const Divider(color: Colors.white24, height: 1),
                      _buildInfoRow(
                        icon: Icons.phone_outlined,
                        label: "Contact Number",
                        value: widget.vehicledata.contactNo,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Assigned Customers Section
                if (widget.vehicledata.customers.isNotEmpty)
                  _buildInfoCard(
                    title: "Assigned Customers",
                    icon: Icons.people_outline,
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.vehicledata.customers.map((customer) {
                        return _buildChip(customer.customerName);
                      }).toList(),
                    ),
                  ),

                // Assigned Categories Section
                if (widget.vehicledata.categories.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    title: "Assigned Categories",
                    icon: Icons.category_outlined,
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: widget.vehicledata.categories.map((category) {
                        return _buildChip(category.categoryName);
                      }).toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Edit Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VehicleDetailsEditPage(
                            vehicleData: widget.vehicledata,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text(
                      "Edit Vehicle Details",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade800.withOpacity(0.8),
            Colors.black.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(icon, color: primaryColor, size: 18),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}
