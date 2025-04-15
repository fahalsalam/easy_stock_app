import 'dart:io';
import 'package:easy_stock_app/controllers/providers/masters_provider/vehicle_management_provider/vehicle_management_provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/vehicle_management_provider/vehicleimagepicker.dart';
import 'package:easy_stock_app/utils/common_widgets/background_image_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/custom_textformfield.dart';
import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MastersAddvehiclePage extends StatefulWidget {
  MastersAddvehiclePage({super.key});

  @override
  State<MastersAddvehiclePage> createState() => _MastersAddvehiclePageState();
}

class _MastersAddvehiclePageState extends State<MastersAddvehiclePage> {
  bool isVisible = false;
  List<int> selectedIndeces = [];
  List<int> selectedIds = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VehicleManagementProvider>(context, listen: false)
          .initialiseData();
      Provider.of<Vehicleimagepicker>(context, listen: false).removeImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final vehicleManagementProvider =
        Provider.of<VehicleManagementProvider>(context);
    final imagePickerProvider = Provider.of<Vehicleimagepicker>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true, // Allows layout adjustment for keyboard
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: CustomAppBar(txt: "Add Vehicle"),
          ),
          Positioned(
            top: screenHeight * 0.12,
            left: 15,
            right: 15,
            bottom: 10, // Added bottom space for button visibility
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.02),
                          GestureDetector(
                            onTap: () {
                              if (imagePickerProvider.selectedImage == null) {
                                showImageSourceActionSheetr(
                                    context, imagePickerProvider);
                              }
                            },
                            child: Container(
                              height: screenHeight * 0.33,
                              width: screenWidth * 0.73,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: imagePickerProvider.isLoading
                                  ? SizedBox(
                                      height: screenHeight * 0.2,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (imagePickerProvider.selectedImage !=
                                            null)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.grey),
                                                onPressed: () {
                                                  imagePickerProvider
                                                      .deleteImage1();
                                                },
                                              ),
                                            ],
                                          ),
                                        imagePickerProvider.selectedImage !=
                                                null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image.file(
                                                  File(imagePickerProvider
                                                      .selectedImage!.path),
                                                  height: screenHeight * 0.2,
                                                  width: screenWidth * 0.7,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : const Column(
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    color: Colors.white,
                                                    size: 50,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'Tap to add image',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                            ),
                          ),

                          const SizedBox(height: 20), // Consistent spacing
                          CustomTextfield(
                            mandatory: true,
                            controller: vehicleManagementProvider
                                .vehicleNumberController,
                            txt: "Vehicle Number",
                            hintText: "Enter vehicle number",
                            suffixIcon: const Icon(Icons.directions_car),
                          ),
                          const SizedBox(height: 15),
                          CustomTextfield(
                            mandatory: true,
                            controller:
                                vehicleManagementProvider.vehicleNameControler,
                            txt: "Vehicle Name",
                            hintText: "Enter vehicle name",
                            suffixIcon: const Icon(Icons.local_shipping),
                          ),
                          const SizedBox(height: 15),
                          CustomTextfield(
                            mandatory: true,
                            controller: vehicleManagementProvider
                                .driverContactController,
                            txt: "Driver Name",
                            hintText: "Enter driver's name",
                            suffixIcon: const Icon(Icons.person),
                          ),
                          const SizedBox(height: 15),
                          CustomTextfield(
                            textInput: TextInputType.phone,
                            controller: vehicleManagementProvider
                                .vehicleContactController,
                            txt: "Contact",
                            hintText: "Enter contact number",
                            suffixIcon: const Icon(Icons.phone),
                          ),
                          const SizedBox(height: 20), // Space before button
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                child: Text(
                                  "Category",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            child: Container(
                              width: screenWidth,
                              height: screenHeight * 0.07,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Center(
                                child: Text(
                                  "Select Category",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isVisible,
                            child: Container(
                              color: Colors.grey.shade400.withOpacity(0.5),
                              height: screenHeight * 0.23,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(bottom: 0),
                                  itemCount: vehicleManagementProvider
                                      .categoryList.length,
                                  itemBuilder: (context, index) {
                                    final category = vehicleManagementProvider
                                        .categoryList[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (selectedIndeces.contains(index)) {
                                            selectedIndeces.remove(index);
                                            selectedIds
                                                .remove(category.categoryId);
                                          } else {
                                            selectedIndeces.add(index);
                                            selectedIds
                                                .add(category.categoryId);
                                          }
                                          });
                                          
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: selectedIndeces
                                                      .contains(index)
                                                  ? primaryColor
                                                  : Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15.0, horizontal: 15),
                                            child: Text(
                                              '${category.categoryName}',
                                              style: const TextStyle(
                                                fontSize: 16.0,
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
                          SizedBox(
                            height: screenHeight * 0.07,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      gradientElevatedButton(
                        child: Center(
                          child: vehicleManagementProvider.isLoading
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
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
                          if (vehicleManagementProvider
                              .vehicleNumberController.text.isEmpty) {
                            showSnackBarWithsub(
                              context,
                              "Please Enter Vehicle Number",
                              "Error",
                              Colors.red,
                            );

                            return; // Exit early if validation fails
                          }
                          if (vehicleManagementProvider
                              .vehicleNameControler.text.isEmpty) {
                            showSnackBarWithsub(
                              context,
                              "Please Enter Vehicle Name",
                              "Error",
                              Colors.red,
                            );

                            return; // Exit early if validation fails
                          }
                          if (vehicleManagementProvider
                              .driverContactController.text.isEmpty) {
                            showSnackBarWithsub(
                              context,
                              "Please Enter Driver Name",
                              "Error",
                              Colors.red,
                            );

                            return; // Exit early if validation fails
                          }
                          yesnoAlertDialog(
                            context: context,
                            message: "Do you want to confirm?",
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            onNo: () {
                              Navigator.pop(context);
                            },
                            onYes: () {
                              vehicleManagementProvider.vehicleSave(
                                  imagePickerProvider.filename, context,selectedIds);
                              imagePickerProvider.removeImage();
                              Navigator.pop(context);
                            },
                            buttonNoText: "No",
                            buttonYesText: "Yes",
                          );
                        },
                        width: screenWidth * 0.23,
                        height: screenHeight * 0.05,
                      ),
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

  // Function to show the action sheet to choose between camera and gallery
  void showImageSourceActionSheetr(
      BuildContext context, Vehicleimagepicker provider) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () {
                provider.pickImage(ImageSource.gallery, context, 'products');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Capture from Camera'),
              onTap: () {
                provider.pickImage(ImageSource.camera, context,
                    'products'); // Updated to allow image capture
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
