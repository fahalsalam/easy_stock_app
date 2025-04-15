import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/models/masters/item_model/item_model.dart';
import 'package:easy_stock_app/models/masters/item_model/productmodel.dart';
import 'package:easy_stock_app/services/api_services/masters/itemMaster_apis/itemMaster_edit_api.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:flutter/material.dart';

class EditItemProvider with ChangeNotifier {
  String imageurl = "";
  initializeData(ItemData data) {
    editcategoryID = data.category.toString();
    edituomID = data.unit.toString();
    edittaxID = data.vat.toString();
    edititemCodeController.text = data.productCode;
    edititemNameController.text = data.productName;
    editbarcodeController.text = data.barcode;
    editPriceController.text = data.price.toString();
    imageurl = data.imageUrl;
    editcategoryController.text = data.categoryName;
    edittaxController.text = data.vatName.toString();
    edituomController.text = data.unitName.toString();
    notifyListeners();
  }

  int selectedIndex = 0;
  selectIndex(index) {
    selectedIndex = index;
    notifyListeners();
  }

  bool isLoading = false;
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> tax = [];
  List<Map<String, dynamic>> uom = [];
  String editcategoryID = "";
  String edituomID = "";
  String edittaxID = "";
  TextEditingController edititemNameController = TextEditingController();
  TextEditingController edititemCodeController = TextEditingController();
  TextEditingController editbarcodeController = TextEditingController();
  TextEditingController editPriceController = TextEditingController();
  TextEditingController editcategoryController = TextEditingController();
  TextEditingController edittaxController = TextEditingController();
  TextEditingController edituomController = TextEditingController();

// edit function
  editFunction({
    required String productID,
    required BuildContext context,
    required String fileName,
    required String imageUrl,
  }) async {
    setLoading(true);
    try {
      // Log current state
      log("Category ID: $editcategoryID, Tax ID: $edittaxID, UOM ID: $edituomID");

      // Simulate a delay if needed
      await Future.delayed(const Duration(seconds: 3));

      // Validate mandatory fields
      if (edititemNameController.text.isEmpty) {
        showSnackBar(
            context, "Please add mandatory fields", "Error", Colors.red);
        setLoading(false);
        return;
      }

      // Prepare API call
      final updatedImageUrl = fileName.isNotEmpty ? fileName : imageUrl;
      final res = await itemMasterUpdateAPI(
        productID: productID,
        productCode: edititemCodeController.text,
        productName: edititemNameController.text,
        barcode: editbarcodeController.text,
        uom: edituomID,
        vat: edittaxID,
        price: editPriceController.text,
        category: editcategoryID,
        imageUrl: updatedImageUrl,
      );
      // Decode the response
      final Map<String, dynamic> jsonData = json.decode(res);
Navigator.pop(context);
      showTopSnackBar(
        context,
        jsonData['message'],
        jsonData['isSucess'] ? "Product Updated Successfully" : 'Error',
        Colors.white.withOpacity(0.85),
      );

      // Handle response
      if (res != 'Failed') {
        log("---> Edit Response: $res");

        // Parse JSON response
        final Map<String, dynamic> jsonData = json.decode(res);
        final ProductModel updatedProduct = ProductModel.fromJson(jsonData);

        // Log and notify success
        log("Updated Product Message: ${updatedProduct.message}");
        // showSnackBar(
        //   context,
        //   "Product Updated Successfully",
        //   "Product Updated",
        //   Colors.white,
        // );

        // Clear inputs and reset UI
        clearAll();
        setLoading(false);
        Navigator.pop(context);
      } else {
        // Handle API failure
        // showSnackBar(context, "Product Update Failed", "Error", Colors.red);
        setLoading(false);
      }
    } catch (e) {
      // Handle unexpected errors
      log("Error during product update: $e");
      // showSnackBar(context, "An error occurred. Please try again.", "Error", Colors.red);
      setLoading(false);
    }
  }

  void showTopSnackBar(
    BuildContext context,
    String message,
    String title,
    Color backgroundColor,
  ) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top +
            10, // Account for the status bar
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the snackbar after a delay
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  clearAll() {
    editbarcodeController.clear();
    edititemCodeController.clear();
    edititemNameController.clear();
    editPriceController.clear();
    editcategoryController.clear();
    edittaxController.clear();
    edituomController.clear();
  }

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
// edit function

  // editFunction({productID, context, fileName, imageUrl}) async {
  //   setLoading(true);
  //   log("ctgy ID:${editcategoryID},tax ID:${edittaxID},uom ID:${edituomID}");
  //   await Future.delayed(const Duration(seconds: 3));
  //   if (edititemNameController.text.isNotEmpty) {
  //     var res = await ItemMasterUPDATEAPI(
  //         productID: productID.toString(),
  //         productCode: edititemCodeController.text,
  //         productName: edititemNameController.text,
  //         barcode: editbarcodeController.text,
  //         uom: edituomID,
  //         vat: edittaxID,
  //         price: editPriceController.text,
  //         category: editcategoryID,
  //         imageUrl: fileName.toString().isNotEmpty ? fileName : imageUrl);
  //     if (res != 'Failed') {
  //       log("--->edit--->$res");
  //       Map<String, dynamic> jsonData = json.decode(res);
  //       ProductModel obj = ProductModel.fromJson(jsonData);
  //       log("obj:${obj.message}");
  //       showSnackBar(context, "Product Updated Sucessfully", "Product Updated",
  //           Colors.white);
  //       clearAll();

  //       setLoading(false);
  //       Navigator.pop(context);
  //     } else {
  //       showSnackBar(context, "Product Updated Failed", "Error", Colors.red);
  //       setLoading(false);
  //     }
  //   } else {
  //     showSnackBar(context, "Please add mandatory fields", "Error", Colors.red);
  //     setLoading(false);
  //   }
  // }