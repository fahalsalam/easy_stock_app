import 'dart:developer';
import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/vehicle_management_provider/vehicle_management_provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/vehicle_management_provider/vehicledetails_edit_provider.dart';
import 'package:easy_stock_app/models/masters/vehicle_masters/vehicleDetailModel.dart';
import 'package:easy_stock_app/utils/common_widgets/background_image_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';

class VehicleDetailsEditPage extends StatefulWidget {
  final VehicleDatum vehicleData;

  const VehicleDetailsEditPage({Key? key, required this.vehicleData})
      : super(key: key);

  @override
  State<VehicleDetailsEditPage> createState() => _VehicleDetailsEditPageState();
}

class _VehicleDetailsEditPageState extends State<VehicleDetailsEditPage> {
  bool isCategoryListVisible = false;
  List<int> selectedCategoryIds = [];
  late List<Category> existingCategories;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final editProvider =
          Provider.of<EditVehicleDetailsProvider>(context, listen: false);
      final vehicleProvider =
          Provider.of<VehicleManagementProvider>(context, listen: false);

      editProvider.initializeData(widget.vehicleData);
      editProvider.removeImage();
      vehicleProvider.initialiseData();

      // Populate categories
      existingCategories = widget.vehicleData.categories;
      selectedCategoryIds =
          existingCategories.map((e) => int.parse(e.categoryId)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final editDetailsProvider =
        Provider.of<EditVehicleDetailsProvider>(context);
    final vehicleManagementProvider =
        Provider.of<VehicleManagementProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.06,
            left: MediaQuery.of(context).size.width * 0.02,
            right: MediaQuery.of(context).size.width * 0.02,
            child: CustomAppBar(txt: "Edit Vehicle Details"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 15.0, vertical: screenHeight * 0.1),
            child: ListView(
              children: [
                _buildVehicleImageContainer(context, editDetailsProvider),
                _buildDetailsForm(
                  context,
                  editDetailsProvider,
                  vehicleManagementProvider,
                ),
                _buildSaveButton(
                    context, editDetailsProvider, screenHeight, screenWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleImageContainer(
      BuildContext context, EditVehicleDetailsProvider provider) {
    return GestureDetector(
      onTap: () {
        if (widget.vehicleData.imageUrl.isEmpty ||
            provider.selectedImage == null) {
          _showImageSourceBottomSheet(context);
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: provider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : _buildImagePreview(provider),
      ),
    );
  }

  Widget _buildImagePreview(EditVehicleDetailsProvider provider) {
    final hasNetworkImage = widget.vehicleData.imageUrl.isNotEmpty;
    final hasLocalImage = provider.selectedImage != null;

    if (hasLocalImage) {
      return Image.file(provider.selectedImage!, fit: BoxFit.contain);
    } else if (hasNetworkImage) {
      return Image.network(
        widget.vehicleData.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.image, color: Colors.white, size: 50),
      );
    } else {
      return const Icon(Icons.image, color: Colors.white, size: 50);
    }
  }

  Widget _buildDetailsForm(
      BuildContext context,
      EditVehicleDetailsProvider editProvider,
      VehicleManagementProvider vehicleProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextfield(
            hintText: "",
            controller: editProvider.vehicleNumberController,
            txt: "Vehicle Number",
            suffixIcon: Container(
              height: 10,
              width: 10,
            ),
          ),
          CustomTextfield(
            hintText: "",
            controller: editProvider.vehicleNameController,
            txt: "Vehicle Name",
            suffixIcon: Container(
              height: 10,
              width: 10,
            ),
          ),
          CustomTextfield(
            hintText: "",
            controller: editProvider.driverNameController,
            txt: "Driver Name",
            suffixIcon: Container(
              height: 10,
              width: 10,
            ),
          ),
          CustomTextfield(
            hintText: "",
            textInput: TextInputType.phone,
            controller: editProvider.contactNumberController,
            txt: "Contact",
            suffixIcon: Container(
              height: 10,
              width: 10,
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              setState(() {
                isCategoryListVisible = !isCategoryListVisible;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                "Select Category",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (isCategoryListVisible) _buildCategoryList(vehicleProvider),
        ],
      ),
    );
  }

  Widget _buildCategoryList(VehicleManagementProvider provider) {
    if (provider.categoryList.isEmpty) {
      return const Center(
        child: Text("No Categories Available",
            style: TextStyle(color: Colors.grey, fontSize: 16)),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: provider.categoryList.length,
      itemBuilder: (_, index) {
        final category = provider.categoryList[index];
        final isSelected = selectedCategoryIds.contains(category.categoryId);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedCategoryIds.remove(category.categoryId);
              } else {
                selectedCategoryIds.add(category.categoryId);
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              category.categoryName,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSaveButton(BuildContext context, EditVehicleDetailsProvider provider,screenHeight,screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => yesnoAlertDialog(
            context: context,
            message: "Do you want to save?",
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            onNo: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            onYes: () {
              provider.editVehicleDetail(
                  widget.vehicleData.vehicleId.toString(),
                  widget.vehicleData.imageUrl,
                  context,
                  selectedCategoryIds);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              showSnackBar(context, "", "Updated", Colors.white);
            },
            buttonNoText: "No",
            buttonYesText: "Yes",
          ),
          child: Container(
            height: screenHeight * 0.045,
            width: screenWidth * 0.3,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: primaryColor, width: 0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                "Save",
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
    );
  }
  // Widget _buildSaveButton(
  //     BuildContext context, EditVehicleDetailsProvider provider,screenHeight,screenWidth) {
  //   return Align(
  //     alignment: Alignment.centerRight,
  //     child: ElevatedButton(
  //       onPressed: () {
  //         yesnoAlertDialog(
  //           context: context,
  //           screenHeight: screenHeight,
  //           screenWidth: screenWidth,
  //           message: "Do you want to save changes?",
  //           onNo: () => Navigator.pop(context),
  //           buttonNoText: 'No',
  //           buttonYesText: 'Yes',
  //           onYes: () {
  //             provider.editVehicleDetail(
  // widget.vehicleData.vehicleId.toString(),
  // widget.vehicleData.imageUrl,
  //               context,
  //             );
  //             Navigator.pop(context); // Close dialogs
  //             Navigator.pop(context); // Go back to the previous page
  //             showSnackBar(context, "", "Updated Successfully", Colors.green);
  //           },
  //         );
  //       },
  //       child: const Text("Save"),
  //     ),
  //   );
  // }

  void _showImageSourceBottomSheet(BuildContext context) {
    final provider =
        Provider.of<EditVehicleDetailsProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text("Camera"),
            onTap: () {
              provider.pickImageFromCamera();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Gallery"),
            onTap: () {
              provider.pickImageFromGallery();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}







// import 'dart:developer';

// import 'package:easy_stock_app/controllers/providers/masters_provider/vehicle_management_provider/vehicle_management_provider.dart';
// import 'package:easy_stock_app/utils/common_widgets/background_image_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:easy_stock_app/controllers/providers/masters_provider/vehicle_management_provider/vehicledetails_edit_provider.dart';
// import 'package:easy_stock_app/models/masters/vehicle_masters/vehicleDetailModel.dart';
// import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
// import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
// import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
// import 'package:easy_stock_app/utils/constants/colors/colors.dart';
// import 'package:easy_stock_app/utils/constants/images/images.dart';
// import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/custom_textformfield.dart';

// class VehicleDatailsEditPage extends StatefulWidget {
//   final VehicleDatum vehicledata;

//   VehicleDatailsEditPage({Key? key, required this.vehicledata})
//       : super(key: key);

//   @override
//   State<VehicleDatailsEditPage> createState() => _VehicleDatailsEditPageState();
// }

// class _VehicleDatailsEditPageState extends State<VehicleDatailsEditPage> {
//   bool isVisible = false;
//   List<Category> categorlist=[];
//   List<int> selectedIndeces = [];
//   List<int> selectedIds = [];
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider =
//           Provider.of<EditVehicleDetailsProvider>(context, listen: false);
//       provider.initializeData(widget.vehicledata);
//       provider.removeImage();
//       Provider.of<VehicleManagementProvider>(context, listen: false)
//           .initialiseData();
//     });
//     categorlist=widget.vehicledata.categories;
//     log("--category ${widget.vehicledata.categories}");
//   }

//   @override
//   Widget build(BuildContext context) {
    // var screenHeight = MediaQuery.of(context).size.height;
    // var screenWidth = MediaQuery.of(context).size.width;
//     final editDetailsProvider =
//         Provider.of<EditVehicleDetailsProvider>(context);
//     final vehicleManagementProvider =
//         Provider.of<VehicleManagementProvider>(context);
//     return Scaffold(
//       body: Stack(
//         children: [
//           BackgroundImageWidget(image: common_backgroundImage),
//           Positioned(
//             top: screenHeight * 0.06,
//             left: screenWidth * 0.02,
//             right: screenWidth * 0.02,
//             child: CustomAppBar(txt: "Edit Vehicle Details"),
//           ),
//           Padding(
//             padding: EdgeInsets.only(
//               top: screenWidth >= 600
//                   ? screenHeight * 0.078 + kToolbarHeight
//                   : screenHeight * 0.041 + kToolbarHeight,
//               left: 15.0,
//               right: 15.0,
//               bottom: 20.0,
//             ),
//             child: ListView(
//               children: [
//                 _buildVehicleImageContainer(context, editDetailsProvider),
//                 _buildDetailsForm(context, editDetailsProvider, vehicleManagementProvider,screenHeight,screenWidth) ,
//                 _buildSaveButton(
//                     context, screenHeight, screenWidth, editDetailsProvider),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVehicleImageContainer(
//       BuildContext context, EditVehicleDetailsProvider provider) {
//     var screenHeight = MediaQuery.of(context).size.height;
//     var screenWidth = MediaQuery.of(context).size.width;

//     return GestureDetector(
//       onTap: () {
//         if (widget.vehicledata.imageUrl.isEmpty ||
//             provider.selectedImage == null) {
//           _showImageSourceBottomSheet(context);
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 15),
//         height: screenHeight * 0.28,
//         width: screenWidth * 0.56,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Colors.grey.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: provider.isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                 ),
//               )
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (widget.vehicledata.imageUrl.isNotEmpty ||
//                       provider.selectedImage != null)
//                     _buildDeleteIcon(context, provider),
//                   SizedBox(
//                       height: widget.vehicledata.imageUrl.isEmpty
//                           ? screenHeight * 0.00
//                           : screenHeight * 0.00),
//                   provider.selectedImage != null
//                       ? SizedBox(
//                           width: screenWidth * 0.5,
//                           height: screenHeight * 0.12,
//                           child: Image.file(
//                             provider.selectedImage!,
//                             width: screenWidth * 0.5,
//                             height: screenHeight * 0.12,
//                             fit: BoxFit.contain,
//                           ),
//                         )
//                       : widget.vehicledata.imageUrl.isNotEmpty
//                           ? SizedBox(
//                               width: screenWidth * 0.5,
//                               height: screenHeight * 0.12,
//                               child: Image.network(
//                                 widget.vehicledata.imageUrl,
//                                 width: screenWidth * 0.5,
//                                 height: screenHeight * 0.2,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     const Icon(
//                                   Icons.image,
//                                   color: Colors.white,
//                                   size: 50,
//                                 ),
//                               ),
//                             )
//                           : const Icon(
//                               Icons.image,
//                               color: Colors.white,
//                               size: 50,
//                             ),
//                   if (widget.vehicledata.imageUrl.isEmpty &&
//                       provider.selectedImage == null)
//                     const Padding(
//                       padding: EdgeInsets.all(3.0),
//                       child: Text(
//                         'Tap to add image',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildDeleteIcon(
//       BuildContext context, EditVehicleDetailsProvider provider) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         IconButton(
//           onPressed: () {
//             if (widget.vehicledata.imageUrl.isNotEmpty) {
//               provider.deleteImage(widget.vehicledata.imageUrl);
//             } else {
//               provider.deleteImage1();
//             }
//             // _showImageSourceBottomSheet(context); // Reopen bottom sheet
//           },
//           icon: const Icon(Icons.delete, color: Colors.grey),
//         ),
//       ],
//     );
//   }

//   Widget _buildDetailsForm(
//       BuildContext context, EditVehicleDetailsProvider provider,VehicleManagementProvider vehicleManagementProvider,double screenHeight,double screenWidth) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 35),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomTextfield(
//             hintText: "",
//             controller: provider.vehicleNumberController,
//             txt: "Vehicle Number",
            // suffixIcon: Container(
            //   height: 10,
            //   width: 10,
            // ),
//           ),
//           CustomTextfield(
//             hintText: "",
//             controller: provider.vehicleNameController,
//             txt: "Vehicle Name",
//             suffixIcon: Container(
//               height: 10,
//               width: 10,
//             ),
//           ),
//           CustomTextfield(
//             hintText: "",
//             controller: provider.driverNameController,
//             txt: "Driver Name",
//             suffixIcon: Container(
//               height: 10,
//               width: 10,
//             ),
//           ),
//           CustomTextfield(
//             hintText: "",
//             textInput: TextInputType.phone,
//             controller: provider.contactNumberController,
//             txt: "Contact",
//             suffixIcon: Container(
//               height: 10,
//               width: 10,
//             ),
//           ),
//           // const SizedBox(height: 20), // Space before button
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
//                 child: Text(
//                   "Category",
//                   style: TextStyle(
//                     fontSize: 14.0,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//             GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 isVisible = !isVisible;
//                               });
//                             },
//                             child: Container(
//                               width: screenWidth,
//                               height: screenHeight * 0.07,
//                               decoration: BoxDecoration(
//                                   color: Colors.black,
//                                   borderRadius: BorderRadius.circular(15)),
//                               child: const Center(
//                                 child: Text(
//                                   "Select Category",
//                                   style: TextStyle(
//                                     fontSize: 16.0,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//           Visibility(
//             visible: isVisible,
//             child: Container(
//               color: Colors.grey.shade400.withOpacity(0.5),
//               height: screenHeight * 0.23,
//               child: ListView.builder(
//                   shrinkWrap: true,
//                   padding: const EdgeInsets.only(bottom: 0),
//                   itemCount: vehicleManagementProvider.categoryList.length,
//                   itemBuilder: (context, index) {
//                     final category =
//                         vehicleManagementProvider.categoryList[index];
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             if (selectedIndeces.contains(index)) {
//                               selectedIndeces.remove(index);
//                               selectedIds.remove(category.categoryId);
//                             } else {
//                               selectedIndeces.add(index);
//                               selectedIds.add(category.categoryId);
//                             }
//                           });
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: selectedIndeces.contains(index)||categorlist.contains(category)
//                                   ? primaryColor
//                                   : Colors.grey.shade300,
//                               borderRadius: BorderRadius.circular(15)),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 15.0, horizontal: 15),
//                             child: Text(
//                               '${category.categoryName}',
//                               style: const TextStyle(
//                                 fontSize: 16.0,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

  // Widget _buildSaveButton(BuildContext context, double screenHeight,
  //     double screenWidth, EditVehicleDetailsProvider provider) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: [
  //       GestureDetector(
  //         onTap: () => yesnoAlertDialog(
  //           context: context,
  //           message: "Do you want to save?",
  //           screenHeight: screenHeight,
  //           screenWidth: screenWidth,
  //           onNo: () {
  //             Navigator.pop(context);
  //             Navigator.pop(context);
  //           },
  //           onYes: () {
  //             provider.editVehicleDetail(
  //                 widget.vehicledata.vehicleId.toString(),
  //                 widget.vehicledata.imageUrl,
  //                 context);
  //             Navigator.pop(context);
  //             Navigator.pop(context);
  //             Navigator.pop(context);
  //             showSnackBar(context, "", "Updated", Colors.white);
  //           },
  //           buttonNoText: "No",
  //           buttonYesText: "Yes",
  //         ),
  //         child: Container(
  //           height: screenHeight * 0.045,
  //           width: screenWidth * 0.3,
  //           decoration: BoxDecoration(
  //             color: Colors.black,
  //             border: Border.all(color: primaryColor, width: 0.8),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: const Center(
  //             child: Text(
  //               "Save",
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w400,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

//   void _showImageSourceBottomSheet(BuildContext context) {
//     final imageProvider =
//         Provider.of<EditVehicleDetailsProvider>(context, listen: false);
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => SizedBox(
//         height: MediaQuery.of(context).size.height * 0.2,
//         child: Column(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text("Camera"),
//               onTap: () {
//                 imageProvider.pickImageFromCamera();
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text("Gallery"),
//               onTap: () {
//                 imageProvider.pickImageFromGallery();
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
