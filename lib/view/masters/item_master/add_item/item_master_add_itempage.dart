import 'dart:developer';
import 'package:easy_stock_app/controllers/providers/image_provider/image_provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/item_master_provider/item_master_add_item_provider/item_master_add_item_provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/item_master_provider/item_master_provider.dart';
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

class ItemMasterAddItemPage extends StatefulWidget {
  const ItemMasterAddItemPage({super.key});
  @override
  State<ItemMasterAddItemPage> createState() => _ItemMasterAddItemPageState();
}

class _ItemMasterAddItemPageState extends State<ItemMasterAddItemPage> {
  @override
  void initState() {
    super.initState();

    // Fetch data when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductMasterProvider>(context, listen: false)
          .fetchDataFromApi();
      Provider.of<ImagePickerProvider>(context, listen: false).removeImage();
      Provider.of<ProductMasterProvider>(context, listen: false)
          .initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    final ItemmasterProvider = Provider.of<ProductMasterProvider>(context);
    final itemmasterGetProvider = Provider.of<ItemMasterProvider>(context);
    final imageProvider = Provider.of<ImagePickerProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: CustomAppBar(txt: "Add Item"),
          ),
          Positioned(
            top: screenHeight * 0.142,
            left: 15,
            right: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.8, // Constrain height here
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      CustomTextfield(
                        mandatory : true,
                        controller: ItemmasterProvider.itemNameController,
                        txt: "Item Name",
                        hintText: "",
                        suffixIcon: const Icon(
                          Icons.add,
                          color: Colors.transparent,
                        ),
                      ),
                      const SizedBox(height: 5),
                      CustomTextfield(mandatory : true,
                        controller: ItemmasterProvider.itemCodeController,
                        txt: "Item Code",
                        hintText: "",
                        suffixIcon: const Icon(
                          Icons.add,
                          color: Colors.transparent,
                        ),
                      ),
                      const SizedBox(height: 5),
                      CustomTextfield(
                        controller: ItemmasterProvider.barcodeController,
                        txt: "BarCode",
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
                      const SizedBox(height: 10),
                      const Text(
                        "Categories",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildAutoCompleteField(
                        hintText: 'Categories',
                        controller: ItemmasterProvider.categoryController,
                        suggestionsCallback: (query) async {
                          return ItemmasterProvider.categories;
                        },
                        onSuggestionSelected: (suggestion) {
                          ItemmasterProvider.categoryController.text =
                              suggestion['name'];
                          ItemmasterProvider.categoryID = suggestion['id'];
                          log("----->>category selected: ${suggestion['id']},${suggestion['name']}");
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Tax",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildAutoCompleteField(
                        hintText: 'Tax',
                        controller: ItemmasterProvider.taxController,
                        suggestionsCallback: (query) async {
                          return ItemmasterProvider.tax;
                        },
                        onSuggestionSelected: (suggestion) {
                          ItemmasterProvider.taxController.text =
                              suggestion['name'];
                          ItemmasterProvider.taxID = suggestion['id'];
                          log("----->>tax selected: ${suggestion['id']},${suggestion['name']}");
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "UOM",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildAutoCompleteField(
                        hintText: 'UOM',
                        controller: ItemmasterProvider.uomController,
                        suggestionsCallback: (query) async {
                          return ItemmasterProvider.uom;
                        },
                        onSuggestionSelected: (suggestion) {
                          ItemmasterProvider.uomController.text =
                              suggestion['name'];
                          ItemmasterProvider.uomID = suggestion['id'];
                          log("----->>uom selected: ${suggestion['id']},${suggestion['name']}");
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextfield(
                        textInput: TextInputType.number,
                        controller: ItemmasterProvider.priceController,
                        txt: "Price",
                        hintText: "",
                        suffixIcon: const Icon(
                          Icons.done,
                          color: Colors.transparent,
                          size: 35,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ImagePickerContainer(),
                      const SizedBox(height: 17),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            gradientElevatedButton(
                              child: Center(
                                child: ItemmasterProvider.isLodaing
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        "Add Item",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black, // Text color
                                        ),
                                      ),
                              ),
                              onPressed: () {
                                if (ItemmasterProvider.itemCodeController.text.isEmpty) {
                                  showSnackBarWithsub(
                                    context,
                                    "Please Enter Item Code",
                                    "Error",
                                    Colors.red,
                                  );

                                  return; // Exit early if validation fails
                                }
                                if (ItemmasterProvider.itemNameController.text.isEmpty) {
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
                                    // Future.delayed(Duration(seconds: 3));
                                    // Provider.of<ProductMasterProvider>(context,
                                    //         listen: false)
                                    //     .fetchDataFromApi();
                                    // Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  onYes: () {
                                    var res = ItemmasterProvider.addFunction(
                                        context, imageProvider.filename);
                                    if (res != "Failed") {
                                      imageProvider.removeImage();
                                      // Future.delayed(Duration(seconds: 3));
                                      // Provider.of<ProductMasterProvider>(context,
                                      //         listen: false)
                                      //     .fetchDataFromApi();
                                      // Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                    itemmasterGetProvider.fetchData();
                                  },
                                  buttonNoText: "No",
                                  buttonYesText: "Yes",
                                );
                              },
                              width: screenWidth * 0.384,
                              height: screenHeight * 0.04,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 77),
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
}
