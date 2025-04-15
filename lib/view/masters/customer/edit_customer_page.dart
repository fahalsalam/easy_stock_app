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
  int? selectedIndex; // Index of the selected vehicle
  String selectedVehicle = '';
  @override
  void initState() {
    super.initState();
    selectedIndices =
        widget.vehicles.map((vehicle) => int.parse(vehicle.vehicleId)).toSet();
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
            child: CustomAppBar(txt: "Edit Customer"),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: screenHeight * 0.142, left: 15, right: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Customer Details",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "  ID",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            CustomerTextfield(
                              controller: customerManagementProvider
                                  .editcustomerIdController,
                              txt: "",
                              hintText: "Customer ID",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  customerManagementProvider.customerID.clear();
                                },
                                icon: const Icon(Icons.close,
                                    color: Colors.black),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Name",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            CustomerTextfield(
                              controller: customerManagementProvider
                                  .editcustomerNameController,
                              txt: "",
                              hintText: "Name",
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.close,
                                    color: Colors.transparent),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Group",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            CustomerTextfield(
                              controller: customerManagementProvider
                                  .editcustomerGroupController,
                              txt: "",
                              hintText: "Customer Group",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  customerManagementProvider.customerID.clear();
                                },
                                icon: const Icon(Icons.close,
                                    color: Colors.black),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "City",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            CustomerTextfield(
                              controller: customerManagementProvider
                                  .editcustomerCityController,
                              txt: "",
                              hintText: "Customer City",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  customerManagementProvider.customerID.clear();
                                },
                                icon: const Icon(Icons.close,
                                    color: Colors.black),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Vehicle",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
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
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(18.0),
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
                                  padding: const EdgeInsets.only(bottom: 10),
                                  shrinkWrap: true,
                                  itemCount: vehicleManagement_provider
                                      .vehicleList.length,
                                  itemBuilder: (context, index) {
                                    final vehicle = vehicleManagement_provider
                                        .vehicleList[index];
                                    final vehicleId =
                                        int.parse(vehicle.vehicleId.toString());
                                    final isSelected =
                                        selectedIndices.contains(vehicleId);

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isSelected) {
                                              // Deselect the vehicle
                                              selectedIndices.remove(vehicleId);
                                              selectedVehicles.remove(
                                                  vehicle.vehicleName );
                                            } else {
                                              // Select the vehicle
                                              selectedIndices.add(vehicleId);
                                              selectedVehicles.add(
                                                   vehicle.vehicleName);
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              vehicle.vehicleName,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
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
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      gradientElevatedButton(
                        child: Center(
                          child: customerManagementProvider.isLoading
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
                          if (customerManagementProvider
                              .editcustomerNameController.text.isEmpty) {
                            showSnackBarWithsub(
                              context,
                              "Please Enter Customer Name",
                              "Error",
                              Colors.red,
                            );
                            customerManagementProvider.setLoading(false);
                            return; // Exit early if validation fails
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
                            return; // Exit early if validation fails
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
                              customerManagementProvider.customerEdit(context, selectedIndices);
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
                  SizedBox(height: screenHeight * 0.35),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// class EditCustomerPage extends StatefulWidget {
//   String name, id, code, group, city;
//   List<Vehicle> vehicles;
//   EditCustomerPage({
//     super.key,
//     required this.name,
//     required this.id,
//     required this.code,
//     required this.city,
//     required this.group,
//     required this.vehicles,
//   });

//   @override
//   State<EditCustomerPage> createState() => _EditCustomerPageState();
// }

// class _EditCustomerPageState extends State<EditCustomerPage> {
//   bool isListVisible = false;
//   Set<int> selectedIndices = {}; // Tracks selected vehicle IDs
//   List<String> selectedVehicles = []; // Tracks selected vehicle names

//   @override
//   void initState() {
//     super.initState();

//     // Initialize selected vehicles and indices
//     selectedIndices =
//         widget.vehicles.map((vehicle) => int.parse(vehicle.vehicleId)).toSet();
//     selectedVehicles = widget.vehicles.map((vehicle) => vehicle.vehicleName).toList();

//     log('Selected Indices: $selectedIndices');
//     log('Selected Vehicles: $selectedVehicles');

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<VehicleManagementProvider>(context, listen: false).fetchData();
//       Provider.of<CustomerManagementProvider>(context, listen: false).clearEditControllers();
//       Provider.of<CustomerManagementProvider>(context, listen: false).initializeData(
//           widget.id, widget.code, widget.name, widget.group, widget.city);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final customerManagementProvider =
//         Provider.of<CustomerManagementProvider>(context);
//     final vehicleManagementProvider =
//         Provider.of<VehicleManagementProvider>(context);
//     var screenHeight = MediaQuery.of(context).size.height;
//     var screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: Stack(
//         children: [
//           BackgroundImageWidget(image: common_backgroundImage),
//           Positioned(
//             top: screenHeight * 0.06,
//             left: screenWidth * 0.02,
//             right: screenWidth * 0.02,
//             child: CustomAppBar(txt: "Edit Customer"),
//           ),
//           Padding(
//             padding: EdgeInsets.only(
//                 top: screenHeight * 0.142, left: 15, right: 15),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Customer Details",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Center(
//                     child: Container(
//                       width: screenWidth * 0.9,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 15),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Other TextFields for Customer ID, Name, etc.
//                             const Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text(
//                                 "Vehicle",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
                           
//                             const SizedBox(height: 25),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 25),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       gradientElevatedButton(
//                         child: Center(
//                           child: customerManagementProvider.isLoading
//                               ? const Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 2, horizontal: 5),
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 5,
//                                   ),
//                                 )
//                               : const Text(
//                                   "Save",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                         ),
//                         onPressed: () {
//                           if (customerManagementProvider
//                               .editcustomerNameController.text.isEmpty) {
//                             showSnackBarWithsub(
//                               context,
//                               "Please Enter Customer Name",
//                               "Error",
//                               Colors.red,
//                             );
//                             customerManagementProvider.setLoading(false);
//                             return;
//                           }
//                           if (customerManagementProvider
//                               .editcustomerIdController.text.isEmpty) {
//                             showSnackBarWithsub(
//                               context,
//                               "Please Enter Customer ID",
//                               "Error",
//                               Colors.red,
//                             );
//                             customerManagementProvider.setLoading(false);
//                             return;
//                           }
//                           yesnoAlertDialog(
//                             context: context,
//                             message: "Do you want to save?",
//                             screenHeight: screenHeight,
//                             screenWidth: screenWidth,
//                             onNo: () {
//                               Navigator.pop(context);
//                             },
//                             onYes: () {
//                               customerManagementProvider.customerEdit(context);
//                               Navigator.pop(context);
//                             },
//                             buttonNoText: "No",
//                             buttonYesText: "Yes",
//                           );
//                         },
//                         width: screenWidth * 0.23,
//                         height: screenHeight * 0.04,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: screenHeight * 0.35),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }