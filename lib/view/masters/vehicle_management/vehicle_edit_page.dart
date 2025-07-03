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
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomAppBar(txt: "Edit Vehicle Details"),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _showSaveConfirmation(context,
                        editDetailsProvider, screenHeight, screenWidth),
                    icon: const Icon(Icons.save_outlined,
                        color: Colors.white, size: 20),
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
                          horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
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
                _buildVehicleImageContainer(context, editDetailsProvider),
                _buildDetailsForm(
                  context,
                  editDetailsProvider,
                  vehicleManagementProvider,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleImageContainer(
      BuildContext context, EditVehicleDetailsProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          GestureDetector(
            onTap: () {
              if (widget.vehicleData.imageUrl.isEmpty ||
                  provider.selectedImage == null) {
                _showImageSourceBottomSheet(context);
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white))
                  : Stack(
                      children: [
                        _buildImagePreview(provider),
                        if (widget.vehicleData.imageUrl.isNotEmpty ||
                            provider.selectedImage != null)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                if (widget.vehicleData.imageUrl.isNotEmpty) {
                                  provider
                                      .deleteImage(widget.vehicleData.imageUrl);
                                } else {
                                  provider.deleteImage1();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
          if (widget.vehicleData.imageUrl.isEmpty &&
              provider.selectedImage == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo,
                      color: Colors.white.withOpacity(0.7), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Tap to add image',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(EditVehicleDetailsProvider provider) {
    final hasNetworkImage = widget.vehicleData.imageUrl.isNotEmpty;
    final hasLocalImage = provider.selectedImage != null;

    if (hasLocalImage) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Image.file(provider.selectedImage!, fit: BoxFit.cover),
      );
    } else if (hasNetworkImage) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Image.network(
          widget.vehicleData.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Center(
            child: Icon(
              Icons.image,
              color: Colors.white.withOpacity(0.5),
              size: 40,
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: Icon(
          Icons.image,
          color: Colors.white.withOpacity(0.5),
          size: 40,
        ),
      );
    }
  }

  Widget _buildDetailsForm(
      BuildContext context,
      EditVehicleDetailsProvider editProvider,
      VehicleManagementProvider vehicleProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 12),
          CustomTextfield(
            hintText: "",
            controller: editProvider.vehicleNameController,
            txt: "Vehicle Name",
            suffixIcon: Container(
              height: 10,
              width: 10,
            ),
          ),
          const SizedBox(height: 12),
          CustomTextfield(
            hintText: "",
            controller: editProvider.driverNameController,
            txt: "Driver Name",
            suffixIcon: Container(
              height: 10,
              width: 10,
            ),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _showCategoryBottomSheet(context, vehicleProvider),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.category_outlined,
                          color: primaryColor, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        selectedCategoryIds.isEmpty
                            ? "Select Categories"
                            : "${selectedCategoryIds.length} Categories Selected",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryBottomSheet(
      BuildContext context, VehicleManagementProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Select Categories",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: provider.categoryList.length,
                itemBuilder: (context, index) {
                  final category = provider.categoryList[index];
                  final isSelected =
                      selectedCategoryIds.contains(category.categoryId);

                  return ListTile(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedCategoryIds.remove(category.categoryId);
                        } else {
                          selectedCategoryIds.add(category.categoryId);
                        }
                      });
                    },
                    leading: Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected
                          ? primaryColor
                          : Colors.white.withOpacity(0.5),
                      size: 24,
                    ),
                    title: Text(
                      category.categoryName,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSaveConfirmation(
    BuildContext context,
    EditVehicleDetailsProvider provider,
    double screenHeight,
    double screenWidth,
  ) {
    yesnoAlertDialog(
      context: context,
      message: "Do you want to save?",
      screenHeight: screenHeight,
      screenWidth: screenWidth,
      onNo: () {
        Navigator.pop(context);
      },
      onYes: () {
        provider.editVehicleDetail(
          widget.vehicleData.vehicleId.toString(),
          widget.vehicleData.imageUrl,
          context,
          selectedCategoryIds,
        );
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        showSnackBar(context, "", "Updated", Colors.white);
      },
      buttonNoText: "No",
      buttonYesText: "Yes",
    );
  }

  void _showImageSourceBottomSheet(BuildContext context) {
    final provider =
        Provider.of<EditVehicleDetailsProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            child: const Text(
              "Choose Image Source",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.white),
            title: const Text(
              "Camera",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              provider.pickImageFromCamera();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Colors.white),
            title: const Text(
              "Gallery",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              provider.pickImageFromGallery();
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
