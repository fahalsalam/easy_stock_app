import 'dart:developer';
import 'package:easy_stock_app/models/masters/customer_model/customer_model.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/providers/masters_provider/customer_master/customer_master_provider.dart';
import '../../../controllers/providers/masters_provider/vehicle_management_provider/vehicle_management_provider.dart';
import '../../../utils/common_widgets/background_image_widget.dart';
import '../../../utils/common_widgets/custom_appbar.dart';
import '../../../utils/common_widgets/dropdown_widget.dart';
import '../../../utils/common_widgets/yesnoAlertbox.dart';
import '../../../utils/constants/images/images.dart';
import '../item_master/add_item/add_item_widget/gradient_button.dart';
import 'customer_widgets/customer_textfield_widget.dart';

class EditCustomerPage extends StatefulWidget {
  String name, id, code, group, city;
  List<Vehicle> vehicles;
  EditCustomerPage({
    super.key,
    required this.name,
    required this.id,
    required this.code,
    required this.city,
    required this.group,
    required this.vehicles,
  });

  @override
  State<EditCustomerPage> createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  bool isListVisible = false;
  Set<int> selectedIndices = {};
  List<String> selectedVehicles = [];
  int? selectedIndex;
  String selectedVehicle = '';

  @override
  void initState() {
    super.initState();
    selectedIndices =
        widget.vehicles.map((vehicle) => int.parse(vehicle.vehicleId)).toSet();
    selectedVehicles =
        widget.vehicles.map((vehicle) => vehicle.vehicleName).toList();
    log('------------->>>> ${selectedIndices}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VehicleManagementProvider>(context, listen: false)
          .fetchData();
      Provider.of<CustomerManagementProvider>(context, listen: false)
          .clearEditControllers();
      Provider.of<CustomerManagementProvider>(context, listen: false)
          .initializeData(
              widget.id, widget.code, widget.name, widget.group, widget.city);
    });
  }

  @override
  Widget build(BuildContext context) {
    final customerManagementProvider =
        Provider.of<CustomerManagementProvider>(context);
    final vehicleManagement_provider =
        Provider.of<VehicleManagementProvider>(context);
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
            child: Row(
              children: [
                Expanded(
                  child: CustomAppBar(txt: "Edit Customer"),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: TextButton.icon(
                    onPressed: () {
                      if (customerManagementProvider
                          .editcustomerNameController.text.isEmpty) {
                        showSnackBarWithsub(
                          context,
                          "Please Enter Customer Name",
                          "Error",
                          Colors.red,
                        );
                        customerManagementProvider.setLoading(false);
                        return;
                      }
                      if (customerManagementProvider
                          .editcustomerIdController.text.isEmpty) {
                        showSnackBarWithsub(
                          context,
                          "Please Enter Customer ID",
                          "Error",
                          Colors.red,
                        );
                        customerManagementProvider.setLoading(false);
                        return;
                      }
                      yesnoAlertDialog(
                        context: context,
                        message: "Do you want to save?",
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        onNo: () {
                          Navigator.pop(context);
                        },
                        onYes: () {
                          customerManagementProvider.customerEdit(
                              context, selectedIndices);
                          Navigator.pop(context);
                        },
                        buttonNoText: "No",
                        buttonYesText: "Yes",
                      );
                    },
                    icon: customerManagementProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save_outlined,
                            size: 20, color: Colors.white),
                    label: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: screenHeight * 0.142, left: 15, right: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Customer Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            label: "ID",
                            controller: customerManagementProvider
                                .editcustomerIdController,
                            hintText: "Customer ID",
                            onClear: () =>
                                customerManagementProvider.customerID.clear(),
                          ),
                          _buildTextField(
                            label: "Name",
                            controller: customerManagementProvider
                                .editcustomerNameController,
                            hintText: "Name",
                          ),
                          _buildTextField(
                            label: "Group",
                            controller: customerManagementProvider
                                .editcustomerGroupController,
                            hintText: "Customer Group",
                            onClear: () =>
                                customerManagementProvider.customerID.clear(),
                          ),
                          _buildTextField(
                            label: "City",
                            controller: customerManagementProvider
                                .editcustomerCityController,
                            hintText: "Customer City",
                            onClear: () =>
                                customerManagementProvider.customerID.clear(),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Vehicle",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _showVehicleSelectionBottomSheet(
                                context, vehicleManagement_provider),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.white24, width: 1),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      selectedVehicles.isEmpty
                                          ? 'Select Vehicles'
                                          : selectedVehicles.join(', '),
                                      style: TextStyle(
                                        color: selectedVehicles.isEmpty
                                            ? Colors.white54
                                            : Colors.white,
                                        fontSize: 15,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white54),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.35),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    VoidCallback? onClear,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        CustomerTextfield(
          controller: controller,
          txt: "",
          hintText: hintText,
          suffixIcon: IconButton(
            onPressed: onClear,
            icon: Icon(
              Icons.close,
              color: onClear != null ? Colors.black : Colors.transparent,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showVehicleSelectionBottomSheet(
      BuildContext context, VehicleManagementProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        return StatefulBuilder(
          builder: (context, setModalState) {
            List filteredVehicles = provider.vehicleList
                .where((c) => c.vehicleName
                    .toString()
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Select Vehicles",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.27,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 45,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search vehicles...',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.5)),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search,
                            color: Colors.white.withOpacity(0.5)),
                      ),
                      onChanged: (_) => setModalState(() {}),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredVehicles.length,
                      padding: const EdgeInsets.only(bottom: 10),
                      itemBuilder: (context, index) {
                        final vehicle = filteredVehicles[index];
                        final vehicleId =
                            int.parse(vehicle.vehicleId.toString());
                        final isSelected = selectedIndices.contains(vehicleId);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() {
                                setState(() {
                                  if (isSelected) {
                                    selectedIndices.remove(vehicleId);
                                    selectedVehicles
                                        .remove(vehicle.vehicleName);
                                  } else {
                                    selectedIndices.add(vehicleId);
                                    selectedVehicles.add(vehicle.vehicleName);
                                  }
                                  debugPrint(
                                      'Selected Vehicles: $selectedVehicles');
                                });
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryColor
                                    : Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      vehicle.vehicleName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
