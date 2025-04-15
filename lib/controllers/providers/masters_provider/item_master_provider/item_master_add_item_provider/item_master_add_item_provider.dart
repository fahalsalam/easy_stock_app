import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/models/masters/item_model/productmodel.dart';
import 'package:easy_stock_app/services/api_services/masters/itemMaster_apis/itemMaster_add_api.dart';
import 'package:easy_stock_app/services/api_services/masters/productMasterLoad_api.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:flutter/material.dart';

class ProductMasterProvider with ChangeNotifier {
// edit provider

  int selectedIndex = 1;
  bool isLodaing = false;
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> tax = [];
  List<Map<String, dynamic>> uom = [];
  String categoryID = "";
  String uomID = "";
  String taxID = "";
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemCodeController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController uomController = TextEditingController();
  // Method to update selected index and notify listeners
  void selectIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  setLoading(bool value) {
    isLodaing = value;
    notifyListeners();
  }
initializeData(){
  itemNameController.clear();
  itemCodeController.clear();
 barcodeController.clear();
  priceController.clear();
  categoryController.clear();
  taxController.clear();
  uomController.clear();
}
// add function
  addFunction(context, String imageurl) async {
    setLoading(true);
    if (barcodeController.text.isNotEmpty ||
        itemCodeController.text.isNotEmpty ||
        itemNameController.text.isNotEmpty ||
        priceController.text.isNotEmpty ||
        imageurl.isNotEmpty ||
        categoryID.isNotEmpty ||
        uomID.isNotEmpty ||
        taxID.isNotEmpty) {
      log("---> uom:${uomID},tax:${taxID},category:${categoryID}");
      var res = await ItemMasterADDAPI(
          barcode: barcodeController.text,
          productCode: itemCodeController.text,
          productName: itemNameController.text,
          uom: uomID,
          tax: taxID,
          price: priceController.text,
          category: categoryID,
          imageUrl: imageurl);
      if (res != 'Failed') {
        Map<String, dynamic> jsonData = json.decode(res);
        ProductModel obj = ProductModel.fromJson(jsonData);
        log("obj:${obj.message}");
        showSnackBar(context, "Product Added Sucessfully", "Product Added",
            Colors.white);
        clearAll();
        setLoading(false);
        // final imageProvider = Provider.of<ImagePickerProvider>(context);
        // imageProvider.removeImage();
        Navigator.pop(context);
        return 'Success';
      } else {
        setLoading(false);
        showSnackBar(context, "Product Added Failed", "Error", Colors.red);
        // Navigator.pop(context);
        return 'Failed';
      }
    } else {
      setLoading(false);
      log("---> uom:${uomID},tax:${taxID},category:${categoryID}");
      log("---> image:${imageurl},price:${priceController.text},barcode:${barcodeController.text}");
      log("---> productCode:${itemCodeController.text},itemName:${itemNameController.text}");
      showSnackBar(context, "Please fill all the fields", "Error", Colors.red);
      return 'Failed';
    }
  }

  clearAll() {
    barcodeController.clear();
    itemCodeController.clear();
    itemNameController.clear();
    priceController.clear();
    categoryController.clear();
    taxController.clear();
    uomController.clear();
  }

  // Asynchronous method to fetch data from an API and store it
  fetchDataFromApi() async {
    categories.clear();
    tax.clear();
    uom.clear();
    var res = await ProductMasterLoadAPI();
    Map<String, dynamic> jsonData = json.decode(res);
    // ProductMasterLoadModel obj = ProductMasterLoadModel.fromJson(jsonData);

    categories = (jsonData['data']['categories'] as List)
        .map<Map<String, dynamic>>((item) => {
              'id': item['CategoryID'].toString(),
              'name': item['CategoryName'].toString(),
            })
        .toList();

    tax = (jsonData['data']['tax'] as List)
        .map<Map<String, dynamic>>((item) => {
              'id': item['TaxSlabID'].toString(),
              'name': item['SlabType'].toString(),
            })
        .toList();

    uom = (jsonData['data']['uom'] as List)
        .map<Map<String, dynamic>>((item) => {
              'id': item['UOMID'].toString(),
              'name': item['UOMDescription'].toString(),
            })
        .toList();
    notifyListeners();
  }

  // dropdown
  String? _selectedValue;
  List<String> _items = [];

  String? get selectedValue => _selectedValue;
  List<String> get items => _items;

  void initialize(List<String> items, String? selectedValue) {
    _items = items;
    _selectedValue = selectedValue;
    notifyListeners();
  }

  void setSelectedValue(String? value) {
    _selectedValue = value;
    notifyListeners();
  }
}
