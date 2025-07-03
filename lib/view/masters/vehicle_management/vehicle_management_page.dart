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
import 'dart:developer';

class MastersVehicleManagementPage extends StatefulWidget {
  const MastersVehicleManagementPage({super.key});

  @override
  State<MastersVehicleManagementPage> createState() =>
      _MastersVehicleManagementPageState();
}

class _MastersVehicleManagementPageState
    extends State<MastersVehicleManagementPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  List<VehicleDatum> _filteredVehicles = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isLoading = true;
        Provider.of<VehicleManagementProvider>(context, listen: false)
            .fetchData()
            .then((_) {
          setState(() {
            isLoading = false;
            _filteredVehicles = List.from(
                Provider.of<VehicleManagementProvider>(context, listen: false)
                    .data
                    .reversed);
            _animationController.forward();
          });
        });
      });
    });
  }

  void _filterVehicles(String query, List<VehicleDatum> vehicles) {
    setState(() {
      _filteredVehicles = vehicles.where((vehicle) {
        return vehicle.vehicleName
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            vehicle.driverName.toLowerCase().contains(query.toLowerCase()) ||
            vehicle.vehicleNumber.toLowerCase().contains(query.toLowerCase()) ||
            vehicle.contactNo.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    final vehicleManagementProvider =
        Provider.of<VehicleManagementProvider>(context);

    if (_filteredVehicles.isEmpty &&
        vehicleManagementProvider.data.isNotEmpty) {
      _filteredVehicles = List.from(vehicleManagementProvider.data.reversed);
    }

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
            bottom: 0,
            child: Container(
              height: screenHeight * 0.86,
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Column(
                      children: [
                        // Search and View Toggle Bar
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white30),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Search vehicles...',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.white.withOpacity(0.6),
                                      size: 20,
                                    ),
                                    suffixIcon: _searchController
                                            .text.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color:
                                                  Colors.white.withOpacity(0.6),
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              _searchController.clear();
                                              _filterVehicles(
                                                  '',
                                                  vehicleManagementProvider
                                                      .data);
                                            },
                                          )
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                  ),
                                  onChanged: (value) => _filterVehicles(
                                      value, vehicleManagementProvider.data),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white30),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _isGridView
                                      ? Icons.view_list
                                      : Icons.grid_view,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isGridView = !_isGridView;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Vehicle List/Grid
                        Expanded(
                          child: vehicleManagementProvider.data.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.directions_car_outlined,
                                        size: 64,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        "No Vehicles Found",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Add a new vehicle to get started",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: _isGridView
                                      ? GridView.builder(
                                          padding: EdgeInsets.only(
                                              bottom: screenHeight * 0.1),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                isWideScreen ? 3 : 2,
                                            childAspectRatio: 1.2,
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 12,
                                          ),
                                          itemCount: _filteredVehicles.length,
                                          itemBuilder: (context, index) {
                                            return _buildGridVehicleCard(
                                                _filteredVehicles[index]);
                                          },
                                        )
                                      : ListView.builder(
                                          padding: EdgeInsets.only(
                                              bottom: screenHeight * 0.1),
                                          itemCount: _filteredVehicles.length,
                                          itemBuilder: (context, index) {
                                            return _buildListVehicleCard(
                                                _filteredVehicles[index]);
                                          },
                                        ),
                                ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MastersAddvehiclePage()),
          ).then((_) {
            setState(() {
              isLoading = true;
              Provider.of<VehicleManagementProvider>(context, listen: false)
                  .fetchData()
                  .then((_) {
                setState(() {
                  isLoading = false;
                  _filteredVehicles = List.from(
                      Provider.of<VehicleManagementProvider>(context,
                              listen: false)
                          .data
                          .reversed);
                });
              });
            });
          });
        },
        backgroundColor: primaryColor,
        elevation: 4,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Vehicle',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildGridVehicleCard(VehicleDatum vehicleData) {
    return Hero(
      tag: 'vehicle-${vehicleData.vehicleNumber}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _navigateToDetail(vehicleData),
          child: Container(
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
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        vehicleData.vehicleName.isNotEmpty
                            ? vehicleData.vehicleName[0].toUpperCase()
                            : 'V',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vehicleData.vehicleName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vehicleData.vehicleNumber,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vehicleData.driverName,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListVehicleCard(VehicleDatum vehicleData) {
    return Hero(
      tag: 'vehicle-${vehicleData.vehicleNumber}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _navigateToDetail(vehicleData),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
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
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        vehicleData.vehicleName.isNotEmpty
                            ? vehicleData.vehicleName[0].toUpperCase()
                            : 'V',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicleData.vehicleName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.directions_car,
                              size: 14,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                vehicleData.vehicleNumber,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 14,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                vehicleData.driverName,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white.withOpacity(0.5),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(VehicleDatum vehicleData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VechicleDetailPage(
          vehicledata: vehicleData,
        ),
      ),
    ).then((_) {
      setState(() {
        isLoading = true;
        Provider.of<VehicleManagementProvider>(context, listen: false)
            .fetchData()
            .then((_) {
          setState(() {
            isLoading = false;
            _filterVehicles(
                _searchController.text,
                Provider.of<VehicleManagementProvider>(context, listen: false)
                    .data);
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
