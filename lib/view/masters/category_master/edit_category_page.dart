import 'package:dotted_border/dotted_border.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/category_master/edit_category_provider.dart';
import 'package:easy_stock_app/models/masters/category_list_model.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/custom_textformfield.dart';
import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/common_widgets/background_image_widget.dart';

class CategoryMasterEditCategoryPage extends StatefulWidget {
  CategoryData data;
  CategoryMasterEditCategoryPage({super.key, required this.data});

  @override
  State<CategoryMasterEditCategoryPage> createState() =>
      _CategoryMasterEditCategoryPageState();
}

class _CategoryMasterEditCategoryPageState
    extends State<CategoryMasterEditCategoryPage> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final editCategoryProvider = Provider.of<EditCategoryProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: CustomAppBar(txt: "Edit Category"),
          ),
          Positioned(
            top: screenHeight * 0.14,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: true,
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Consumer<EditCategoryProvider>(
                          builder: (context, imagePickerProvider, child) {
                        return DottedBorder(
                          color: Colors.grey,
                          strokeWidth: 2,
                          borderType: BorderType.RRect,
                          dashPattern: const [6, 3],
                          radius: const Radius.circular(12),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                // editCategoryProvider
                                //     .deleteImage(widget.data.imageUrl);
                                if (imagePickerProvider.selectedImage == null ||
                                    imagePickerProvider.selectedImage == null) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) =>
                                        _imageSourceBottomSheet(context),
                                  );
                                }
                              },
                              child: SizedBox(
                                width: screenWidth * 0.8,
                                height: screenHeight * 0.2,
                                // alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    imagePickerProvider.selectedImage != null ||
                                            widget.data.imageUrl.isNotEmpty
                                        ? Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          yesnoAlertDialog(
                                                            context: context,
                                                            message:
                                                                'Do you want to remove Image?',
                                                            screenHeight:
                                                                screenHeight,
                                                            screenWidth:
                                                                screenWidth,
                                                            onNo: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            onYes: () {
                                                              // Check if image URL exists and call appropriate method
                                                              if (widget
                                                                  .data
                                                                  .imageUrl
                                                                  .isNotEmpty) {
                                                                // Use this method to handle server deletion or state update for URL removal
                                                                editCategoryProvider
                                                                    .deleteImage(
                                                                        widget
                                                                            .data
                                                                            .imageUrl);
                                                                widget.data
                                                                        .imageUrl =
                                                                    ''; // Clear the imageUrl after deletion
                                                              } else {
                                                                // This handles local deletion (i.e., image picker file)
                                                                editCategoryProvider
                                                                    .deleteImage1();
                                                              }
                                                              Navigator.pop(
                                                                  context); // Close the alert dialog
                                                              // Optionally show the bottom sheet to pick a new image
                                                              showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                builder: (context) =>
                                                                    _imageSourceBottomSheet(
                                                                        context),
                                                              );
                                                            },
                                                            buttonNoText: 'No',
                                                            buttonYesText:
                                                                'Yes',
                                                          );
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.grey,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              // SizedBox(
                                              //   height: screenHeight * 0.05,
                                              // ),
                                            ],
                                          )
                                        : Container(),
                                    imagePickerProvider.isimageLoading
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                top: imagePickerProvider
                                                                .selectedImage !=
                                                            null ||
                                                        widget.data.imageUrl
                                                            .isNotEmpty
                                                    ? 20
                                                    : 60),
                                            // height: screenHeight * 0.5,
                                            child: const Text(
                                              'Loading...',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        : imagePickerProvider.selectedImage !=
                                                null
                                            ? SizedBox(
                                                height: screenHeight * 0.1,
                                                width: screenWidth * 0.7,
                                                child: Image.file(
                                                  imagePickerProvider
                                                      .selectedImage!,
                                                  fit: BoxFit.contain,
                                                  width: screenWidth * 0.8,
                                                  height: screenHeight * 0.2,
                                                ),
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    // margin: const EdgeInsets.only(
                                                    //     top: 35),
                                                    // color: Colors.red,
                                                    height: screenHeight * 0.13,
                                                    width: screenWidth * 0.7,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 18),
                                                      child: Image.network(
                                                        widget.data.imageUrl,
                                                        fit: BoxFit.contain,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 28.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            25),
                                                                child: Text(
                                                                  'Tap to add image',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 17),
                      CustomTextfield(
                        onChanged: (value) {
                          editCategoryProvider.editedCategoryName = value;
                          editCategoryProvider.editCategoryNameController.text=value;
                        },
                        initialValue: widget.data.categoryName,
                        txt: "Category Name",
                        hintText: "",
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.close,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Consumer<EditCategoryProvider>(
                                builder: (context, provider, child) {
                              return gradientElevatedButton(
                                child: Center(
                                  child: provider.isLoading
                                      ? const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 1),
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
                                  if (editCategoryProvider.editCategoryNameController.text.isEmpty) {
                                    showSnackBarWithsub(
                                      context,
                                      "Please Enter Category Name",
                                      "Error",
                                      Colors.red,
                                    );

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
                                      editCategoryProvider.EditCategory(
                                          categoryID: widget.data.categoryId,
                                          categoryName:
                                              widget.data.categoryName,
                                          isActive: widget.data.isActive,
                                          context: context,
                                          image: widget.data.imageUrl);
                                      Navigator.pop(context);
                                      Future.delayed(const Duration(seconds: 4))
                                          .then((_) {
                                        provider.removeSelectedImage();
                                      });
                                    },
                                    buttonNoText: "No",
                                    buttonYesText: "Yes",
                                  );
                                },
                                width: screenWidth * 0.3,
                                height: screenHeight * 0.04,
                              );
                            }),
                          ],
                        ),
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

  Widget _imageSourceBottomSheet(BuildContext context) {
    final imageProvider =
        Provider.of<EditCategoryProvider>(context, listen: false);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: () {
              imageProvider.pickImageFromCamera();
              Navigator.pop(context); // Close the bottom sheet
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Gallery"),
            onTap: () {
              imageProvider.pickImageFromGallery();
              Navigator.pop(context); // Close the bottom sheet
            },
          ),
        ],
      ),
    );
  }
}
