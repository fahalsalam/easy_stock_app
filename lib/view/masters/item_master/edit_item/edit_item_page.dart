// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_stock_app/controllers/providers/image_provider/image_provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/item_master_provider/item_master_add_item_provider/item_master_add_item_provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/item_master_provider/item_master_edit_item_provider/item_master_edit_item_provider.dart';

import 'package:easy_stock_app/models/masters/item_model/item_model.dart';
import 'package:easy_stock_app/utils/common_widgets/button_circular_progressIndicator.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/common_widgets/dropdown_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/imagepicker_container.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/custom_textformfield.dart';
import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/common_widgets/background_image_widget.dart';

class ItemMasterEditItemPage extends StatefulWidget {
  ItemData product;
  ItemMasterEditItemPage({super.key, required this.product});

  @override
  State<ItemMasterEditItemPage> createState() => _ItemMasterEditItemPageState();
}

class _ItemMasterEditItemPageState extends State<ItemMasterEditItemPage> {
  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductMasterProvider>(context, listen: false)
          .fetchDataFromApi();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EditItemProvider>(context, listen: false)
          .initializeData(widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    final ItemmasterProvider = Provider.of<ProductMasterProvider>(context);
    final ItemmasterEditProvider = Provider.of<EditItemProvider>(context);

    final imagePickerProvider = Provider.of<ImagePickerProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: CustomAppBar(txt: "Edit Item"),
          ),
          Positioned(
            top: screenHeight * 0.14,
            left: 15,
            right: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: true,
                  child: SizedBox(
                    height: screenHeight * 0.8, // Constrain height here
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        CustomTextfield(
                          mandatory: true,
                          controller:
                              ItemmasterEditProvider.edititemNameController,
                          txt: "Item Name",
                          hintText: "",
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(10),
                            color: Colors.black,
                            child: const Icon(
                              Icons.filter_center_focus,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        CustomTextfield(
                          mandatory: false,
                          txt: "Bar Code",
                          controller:
                              ItemmasterEditProvider.editbarcodeController,
                          hintText: "ADCB1825385",
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(10),
                            color: Colors.grey.shade700,
                            child: const Icon(
                              Icons.filter_center_focus,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Category",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 15),
                        buildAutoCompleteField(
                          hintText: 'Category',
                          controller:
                              ItemmasterEditProvider.editcategoryController,
                          suggestionsCallback: (query) async {
                            return ItemmasterProvider.categories;
                          },
                          onSuggestionSelected: (suggestion) {
                            ItemmasterEditProvider.editcategoryController.text =
                                suggestion['name'];
                            ItemmasterEditProvider.editcategoryID =
                                suggestion['id'];
                            log("----->>category selected: ${suggestion['id']},${suggestion['name']}");
                          },
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Tax",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 15),
                        buildAutoCompleteField(
                          hintText: 'Tax',
                          controller: ItemmasterEditProvider.edittaxController,
                          suggestionsCallback: (query) async {
                            return ItemmasterProvider.tax;
                          },
                          onSuggestionSelected: (suggestion) {
                            ItemmasterEditProvider.edittaxController.text =
                                suggestion['name'];
                            ItemmasterEditProvider.edittaxID = suggestion['id'];
                            log("----->>tax selected: ${suggestion['id']},${suggestion['name']}");
                          },
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "UOM",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 15),
                        buildAutoCompleteField(
                          hintText: 'UOM',
                          controller: ItemmasterEditProvider.edituomController,
                          suggestionsCallback: (query) async {
                            return ItemmasterProvider.uom;
                          },
                          onSuggestionSelected: (suggestion) {
                            ItemmasterEditProvider.edituomController.text =
                                suggestion['name'];
                            ItemmasterEditProvider.edituomID = suggestion['id'];
                            log("----->>uom selected: ${suggestion['id']},${suggestion['name']}");
                          },
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            if (imagePickerProvider.selectedImage == null) {
                              showImageSourceActionSheet(
                                  context, imagePickerProvider);
                            } else {}
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: DottedBorder(
                              color: Colors.grey,
                              strokeWidth: 2,
                              borderType: BorderType.RRect,
                              dashPattern: const [6, 3],
                              radius: const Radius.circular(12),
                              child: Center(
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.23,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Visibility(
                                            visible: imagePickerProvider
                                                        .selectedImage !=
                                                    null ||
                                                ItemmasterEditProvider
                                                    .imageurl.isNotEmpty,
                                            child: Column(
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
                                                           message:      'Do you want to remove Image?',
                                                           screenHeight:      screenHeight,
                                                          screenWidth:       screenWidth,
                                                           onNo:      () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            onYes:  () {
                                                              if (ItemmasterEditProvider
                                                                  .imageurl
                                                                  .isNotEmpty) {
                                                                imagePickerProvider
                                                                    .deleteImage(
                                                                        ItemmasterEditProvider
                                                                            .imageurl);
                                                              } else {
                                                                imagePickerProvider
                                                                    .deleteImage1();
                                                              }
                                                              Navigator.pop(
                                                                  context);
                                                              showImageSourceActionSheet(
                                                                  context,
                                                                  imagePickerProvider);
                                                            }, 
                                                            buttonNoText: 'No',
                                                            buttonYesText:  'Yes');
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
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: screenHeight * 0.1,
                                          // ),
                                          imagePickerProvider.isLoading
                                              ? SizedBox(
                                                  height: screenHeight * 0.12,
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : imagePickerProvider
                                                          .selectedImage !=
                                                      null
                                                  ? SizedBox(
                                                      height:
                                                          screenHeight * 0.15,
                                                      width: screenWidth * 0.6,
                                                      child: Image.file(
                                                        imagePickerProvider
                                                            .selectedImage!,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    )
                                                  : Container(
                                                      height:
                                                          screenHeight * 0.15,
                                                      width: screenWidth * 0.6,
                                                      color: Colors.transparent,
                                                      child: Image.network(
                                                        ItemmasterEditProvider
                                                            .imageurl,
                                                        fit: BoxFit.contain,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object error,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          return const Padding(
                                                            padding:
                                                                EdgeInsets
                                                                    .only(
                                                                   top:
                                                                        30),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons.image,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 70,
                                                                ),
                                                                Text(
                                                                  'Tap to add image',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15),
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                        ])),
                              ),
                            ),
                          ),
                        ),
                       
                        const SizedBox(height: 17),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              gradientElevatedButton(
                                child: ItemmasterEditProvider.isLoading
                                    ? buttonCircularIndicator()
                                    : const Center(
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black, // Text color
                                          ),
                                        ),
                                      ),
                                onPressed: () {
                                     if ( ItemmasterEditProvider.editbarcodeController.text.isEmpty) {
                                  showSnackBarWithsub(
                                    context,
                                    "Please Enter Item Code",
                                    "Error",
                                    Colors.red,
                                  );

                                  return; // Exit early if validation fails
                                }
                                if ( ItemmasterEditProvider.edititemNameController.text.isEmpty) {
                                  showSnackBarWithsub(
                                    context,
                                    "Please Enter Item Name",
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
                                    ItemmasterEditProvider.editFunction(
                                    productID: widget.product.productId.toString(),
                                    context: context,
                                    fileName: imagePickerProvider.filename,
                                    imageUrl: ItemmasterEditProvider.imageurl,
                                  );

                                  // itemmasterGetProvider.fetchData();
                                  Future.delayed(const Duration(seconds: 4))
                                      .then((_) {
                                    imagePickerProvider.removeImage();
                                  });
                                  },
                                  buttonNoText: "No",
                                  buttonYesText: "Yes",
                                );
                                 
                                },
                                width: screenWidth * 0.3,
                                height: screenHeight * 0.046,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 77),
                      ],
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
}
