import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/models/masters/item_model/item_model.dart';
import 'package:easy_stock_app/services/api_services/masters/itemMaster_apis/itemmaster_get_api.dart';
import 'package:flutter/material.dart';
import 'package:easy_stock_app/models/purchase_order/cart_item_model.dart';
import 'package:easy_stock_app/models/purchase_order/productData_model.dart';
import 'package:easy_stock_app/models/purchase_order/productModel.dart';
import 'package:easy_stock_app/services/api_services/barcode_scanner_api/barcode_scanner_api.dart';
import 'package:easy_stock_app/services/api_services/purchase_order/get_category_byid_api.dart';
import 'package:easy_stock_app/models/masters/category_list_model.dart';
import 'package:easy_stock_app/services/api_services/masters/category_list_api.dart';
import 'package:easy_stock_app/services/api_services/purchase_order/post_purchaseorder_api.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';

class PurchaseItemListProvider with ChangeNotifier {
  // Variables for Item and Category Lists
  int _selectedIndex = 0;
  int _clickedIndex = -1;
  bool _isLoading = false;
  List<ProductDatum> productDatas = [];
  List<ProductDatum> filteredProductDatas = [];
  List<CategoryData> categoryList = [];
  String searchQuery = '';

  // Variables for Cart Management
  List<ProductItem> _cartItems = [];
  double totalPrice = 0.0;
  double totalVat = 0.0;
  bool _isCartVisible = true;

  // Getters for State Variables
  int get selectedIndex => _selectedIndex;
  int get clickedIndex => _clickedIndex;
  bool get isLoading => _isLoading;
  List<ProductDatum> get products => filteredProductDatas;
  List<CategoryData> get categories => categoryList;
  List<ProductItem> get cartItems => _cartItems;
  bool get isCartVisible => _isCartVisible;

  // Index Management
  void selectIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void updateClickedIndex(int index) {
    _clickedIndex = index;
    notifyListeners();
  }

  // Loading Management
  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  // Fetch Functions for Items and Categories
  Future<void> fetchDataByBarcode(String barcode) async {
    startLoading();
    var res = await fetchProductByBarcode(barcode);
    if (res != 'Failed') {
      Map<String, dynamic> jsonData = json.decode(res);
      ProductdataList obj = ProductdataList.fromJson(jsonData);
      productDatas = obj.data;
      filteredProductDatas = productDatas;
    } else {
      productDatas = [];
      filteredProductDatas = [];
    }
    stopLoading();
  }

  Future<void> getProducts(String categoryID) async {
    log("Fetching products by category ID: $categoryID");
    startLoading();
    var res = await getProductsbyidApi(categoryID: categoryID);
    if (res != 'Failed') {
      Map<String, dynamic> jsonData = json.decode(res);
      ProductdataList obj = ProductdataList.fromJson(jsonData);
      productDatas = obj.data;
      filteredProductDatas = productDatas;
      applySearchFilter();
    } else {
      productDatas = [];
      filteredProductDatas = [];
    }
    stopLoading();
  }

  clearCartItems() {
    _cartItems.clear();
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    var res = await CategoryListAPI();
    if (res != 'Failed') {
      Map<String, dynamic> jsonData = json.decode(res);
      CategoryListModel obj = CategoryListModel.fromJson(jsonData);
      categoryList = obj.data;
      if (categoryList.isNotEmpty) {
        cartVisibility(false);

        startLoading();
        getProducts(categoryList.first.categoryId.toString());

        updateClickedIndex(0);

        Future.delayed(const Duration(seconds: 2), () {
          stopLoading(); // Hide loading spinner after data fetch
          cartVisibility(true);
        });
      }
    } else {
      categoryList = [];
    }
    notifyListeners();
  }

  // Search and Filter
  void searchProducts(String query) {
    searchQuery = query.toLowerCase();
    applySearchFilter();
  }

  void applySearchFilter() {
    if (searchQuery.isEmpty) {
      filteredProductDatas = productDatas;
    } else {
      filteredProductDatas = productDatas.where((product) {
        final productCode = product.barcode.toLowerCase();
        final productName = product.productName.toLowerCase();
        return productCode.contains(searchQuery) ||
            productName.contains(searchQuery);
      }).toList();
    }
    notifyListeners();
  }

  // Cart Visibility Control
  void cartVisibility(bool value) {
    _isCartVisible = value;
    notifyListeners();
  }

  // Cart Management Functions
  void addItemToCart(ProductDatum productData, double quantity, context) {
    int index = _cartItems.indexWhere(
      (item) => item.productData.productId == productData.productId,
    );
    //  int previousqty=_cartItems[index].quantity;
    if (index != -1) {
      _cartItems[index].quantity = quantity;
    } else {
      _cartItems.add(ProductItem(
        productData: productData,
        quantity: quantity,
      ));
      // showSnackBar(context, "", "Item Added", Colors.white);
    }

    updatePriceAndVat();
    notifyListeners();
  }

  void removeItemFromCart(ProductDatum productItem) {
    _cartItems.removeWhere(
        (item) => item.productData.productId == productItem.productId);
    updatePriceAndVat();
    notifyListeners();
  }

  void updateQuantity(
      ProductDatum productItem, double newQuantity, BuildContext context) {
    int index = _cartItems.indexWhere(
        (item) => item.productData.productId == productItem.productId);

    if (index != -1) {
      if (newQuantity > 0) {
        _cartItems[index].quantity = newQuantity;
        // showSnackBar(context, "", "Quantity Updated", Colors.white);
      } else {
        removeItemFromCart(productItem);
        // showSnackBar(context, "", "Item Removed", Colors.white);
      }
      updatePriceAndVat();
      // getTotalPrice();
      // getTotalCartQty();
      notifyListeners();
    }
  }

  void updatePriceAndVat() {
    totalPrice = _cartItems.fold(0, (sum, item) {
      return sum + (double.parse(item.productData.price) * item.quantity);
    });
    totalVat = _cartItems.fold(0, (vat, item) {
      return vat + (double.parse(item.productData.vat));
    });
  }

  String getTotalPrice() => totalPrice.toString();
  String getTotalCartQty() => _cartItems
      .fold(0.0, (sum, item) => sum + item.quantity)
      .toStringAsFixed(2);

  // String getTotalCartQty() =>
  //     _cartItems.fold(0, (sum, item) => sum + item.quantity).toString();

  // Confirm and Cancel Functions
  Future<bool> confirmFunction(List<ProductItem> _cartItem, context) async {
    _isLoading = true;
    notifyListeners();
    List<Product> productItemsList =
        _cartItem.map((item) => transformToProduct(item)).toList();

    var res = await postPurchaseOrderApi(
        productItemsList, totalPrice, totalVat, 'O', '0', '0');

    if (res != 'Failed') {
      _isLoading = false;
      notifyListeners();
      showSnackBar(context, "", "Saved", Colors.white);
      _cartItem.clear();
      notifyListeners();
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      return true;
    } else {
      _isLoading = false;
      notifyListeners();
      showSnackBar(context, "", "Error", Colors.white);
      Navigator.pop(context);
      return false;
    }
  }

  void cancelFunction(List<ProductItem> _cartItem) {
    _cartItem.clear();
    notifyListeners();
  }

  Product transformToProduct(ProductItem productItems) {
    return Product(
        ProductID: productItems.productData.productId,
        ProductName: productItems.productData.productName,
        Price: productItems.productData.price,
        Unit: productItems.productData.unit,
        Qty: productItems.quantity.toString(),
        Vat: productItems.productData.vat,
        Total: (double.parse(productItems.productData.price) *
                productItems.quantity)
            .toString());
  }

  bool _isvisibleCirularIndicator = false;
  get isvisibleCirularIndicator => _isvisibleCirularIndicator;
  startCircleIndicator() {
    _isvisibleCirularIndicator = true;
    notifyListeners();
  }

  stopCircleIndicator() {
    _isvisibleCirularIndicator = false;
    notifyListeners();
  }

  //  search by api
  List<ProductDatum> itemdata = [];

  searchByApi(String value) async {
    if (value.isNotEmpty) {
      var res = await ItemMasterGetAPI(searchText: value);
      if (res != 'Failed') {
        Map<String, dynamic> jsonData = json.decode(res);
        ItemModel obj = ItemModel.fromJson(jsonData);

        // Convert each ItemData to ProductDatum
        itemdata = obj.data.map((item) => item.toProductDatum()).toList();

        log("------------>>>>>>>>>>>>>>>>>  Product data Length ${itemdata.length}");
        notifyListeners();
      } else {
        itemdata = [];
        notifyListeners();
        return;
      }
    }
  }
  // List<ItemData> itemdata = [];
  // searchByApi(String value) async {
  //   if (value.isNotEmpty) {
  //     var res = await ItemMasterGetAPI(searchText: value);
  //     if (res != 'Failed') {
  //       Map<String, dynamic> jsonData = json.decode(res);
  //       ItemModel obj = ItemModel.fromJson(jsonData);
  //       log("------------>>>>>>>>>>>>>>>>>  Product data Length ${obj.data}");
  //       itemdata = obj.data;
  //       notifyListeners();
  //     } else {
  //       itemdata = [];
  //       notifyListeners();
  //       return;
  //     }
  //   }
  // }
}
