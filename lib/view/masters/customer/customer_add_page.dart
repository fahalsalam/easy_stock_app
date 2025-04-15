import 'dart:developer';

import 'package:easy_stock_app/controllers/providers/masters_provider/customer_master/customer_master_provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/vehicle_management_provider/vehicle_management_provider.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/common_widgets/dropdown_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/custom_textformfield.dart';
import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/common_widgets/background_image_widget.dart';
import 'customer_widgets/customer_textfield_widget.dart';

class MastersCustomerAddPage extends StatefulWidget {
  const MastersCustomerAddPage({super.key});

  @override
  State<MastersCustomerAddPage> createState() => _MastersCustomerAddPageState();
}

class _MastersCustomerAddPageState extends State<MastersCustomerAddPage> {
  bool isListVisible = false;
  Set<int> selectedIndices = {};
  List<String> selectedVehicles = [];
  int? selectedIndex; // Index of the selected vehicle
  String selectedVehicle = ''; // String to store the selected vehicle's name
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VehicleManagementProvider>(context, listen: false)
          .fetchData();

      Provider.of<CustomerManagementProvider>(context, listen: false)
          .fetchData();
      Provider.of<CustomerManagementProvider>(context, listen: false)
          .clearAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehicleManagement_provider =
        Provider.of<VehicleManagementProvider>(context);
    final customerManagement_provider =
        Provider.of<CustomerManagementProvider>(context);
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
            child: CustomAppBar(txt: "Add Customer"),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: screenHeight * 0.142, left: 15, right: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Name and Details",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Container(
                      width: screenWidth * 0.9,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 15),
                        child: Column(
                          children: [
                            CustomerTextfield(
                              mandatory: true,
                              controller:
                                  customerManagement_provider.customerID,
                              txt: "",
                              hintText: "Customer Code",
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            CustomerTextfield(
                              mandatory: true,
                              controller:
                                  customerManagement_provider.customerName,
                              txt: "",
                              hintText: "Name",
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "Customer Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Container(
                      width: screenWidth * 0.9,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15),
                            child: Column(
                              children: [
                                CustomTextfield(
                                  controller:
                                      customerManagement_provider.customerGroup,
                                  txt: "Group",
                                  hintText: "",
                                  color: Colors.grey.shade900,
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                                CustomTextfield(
                                  controller:
                                      customerManagement_provider.customerCity,
                                  txt: "City",
                                  hintText: "",
                                  color: Colors.grey.shade900,
                                  suffixIcon: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "Vehicle",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isListVisible = !isListVisible;
                      });
                    },
                    child: Container(
                      width: screenWidth * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          'Select a vehicle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isListVisible,
                    child: Container(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.2,
                      color: Colors.grey.shade500,
                      child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 10),
                          shrinkWrap: true,
                          itemCount: vehicleManagement_provider.vehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle =
                                vehicleManagement_provider.vehicles[index];
                            final isSelected = selectedIndices.contains(index);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      // If already selected, deselect it
                                      selectedIndices.remove(index);
                                      selectedVehicles.remove(vehicle['name']);
                                    } else {
                                      // Otherwise, select it
                                      selectedIndices.add(index);
                                      selectedVehicles
                                          .add(vehicle['id'] ?? '');
                                    }
                                  });
                                  debugPrint(
                                      'Selected Vehicles: $selectedVehicles');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: isSelected
                                          ? primaryColor
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${vehicle['name']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  // buildAutoCompleteField(
                  //   mandatory: true,
                  //   hintText: customerManagement_provider
                  //           .vehicle_controller.text.isEmpty
                  //       ? 'Select Vehicle'
                  //       : customerManagement_provider.vehicle_controller.text,
                  //   controller: customerManagement_provider.vehicle_controller,
                  //   suggestionsCallback: (query) async {
                  //     return vehicleManagement_provider.vehicles;
                  //   },
                  //   onSuggestionSelected: (suggestion) {
                  //     customerManagement_provider.vehicleId_controller.text =
                  //         suggestion['id'];
                  //     customerManagement_provider.vehicle_controller.text =
                  //         suggestion['name'];
                  //     log("----->>vehicle selected: ${suggestion['id']},${suggestion['name']}");
                  //   },
                  // ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      gradientElevatedButton(
                        child: Center(
                          child: customerManagement_provider.isLoading
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 5,
                                  ),
                                )
                              : const Text(
                                  "Save",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                        onPressed: () {
                          // Validate required fields
                          if (customerManagement_provider
                              .customerName.text.isEmpty) {
                            showSnackBarWithsub(
                              context,
                              "Please Enter Customer Name",
                              "Error",
                              Colors.red,
                            );
                            customerManagement_provider.setLoading(false);
                            return; // Exit early if validation fails
                          }

                          if (customerManagement_provider
                              .customerID.text.isEmpty) {
                            showSnackBarWithsub(
                              context,
                              "Please Enter Customer ID",
                              "Error",
                              Colors.red,
                            );
                            customerManagement_provider.setLoading(false);
                            return; // Exit early if validation fails
                          }

                          if (
                              selectedVehicles.isEmpty) {
                            showSnackBarWithsub(
                              context,
                              "Please Select Vehicle",
                              "Error",
                              Colors.red,
                            );
                            customerManagement_provider.setLoading(false);
                            return; // Exit early if validation fails
                          }
                          // If all validations pass, show the confirmation dialog
                          yesnoAlertDialog(
                            context: context,
                            message: "Do you want to save?",
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            onNo: () {
                              Navigator.pop(context);
                            },
                            onYes: () {
                              customerManagement_provider.CustomerSave(context,selectedVehicles);
                              Navigator.pop(context);
                            },
                            buttonNoText: "No",
                            buttonYesText: "Yes",
                          );
                        },
                        width: screenWidth * 0.23,
                        height: screenHeight * 0.04,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.35,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
