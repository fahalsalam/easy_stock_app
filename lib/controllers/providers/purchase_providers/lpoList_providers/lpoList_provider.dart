import 'dart:convert';
import 'dart:developer';
import 'package:easy_stock_app/models/masters/item_model/item_model.dart';
import 'package:easy_stock_app/models/purchase_order/lpoModel.dart';
import 'package:easy_stock_app/models/purchase_order/order_details_model.dart';
import 'package:easy_stock_app/services/api_services/masters/itemMaster_apis/itemmaster_get_api.dart';
import 'package:easy_stock_app/services/api_services/purchase_order/edit_purchase_order_api.dart';
import 'package:easy_stock_app/services/api_services/purchase_order/get_purchase_order_api.dart';
import 'package:easy_stock_app/services/api_services/purchase_order/purchase_order_details_byid.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:flutter/material.dart';

class LpolistProvider with ChangeNotifier {
  String CustmrID = "";
  String CustmrName = "";
  List<lpoDatum> lpoData = [];
  TextEditingController searchController = TextEditingController();

  // Fetch purchase order data
  fetchData() async {
    try {
      var res = await getPurchaseorderApi();
      if (res != 'Failed') {
        Map<String, dynamic> jsonData = json.decode(res);
        PurchaseOrderLpoModel obj = PurchaseOrderLpoModel.fromJson(jsonData);
        print("lpo Length ${obj.data.length}");
        lpoData = obj.data;
        notifyListeners();
      } else {
        lpoData = [];
        notifyListeners();
        return;
      }
    } catch (e) {
      log("Error fetching data: $e");
      lpoData = [];
      notifyListeners();
    }
  }

  List<Detail> details = [];
  List<Header> header=[];
  String orderID = '0';
  String editNO = '0';

  // Fetch order details
  fetchDetails({orderId, editNo}) async {
    try {
      log("order:$orderId");
      log("edit $editNo");
      var res = await getPurchaseorderDetailsByidApi(
          orderId: orderId, editNo: editNo);
      if (res != 'Failed') {
        Map<String, dynamic> jsonData = json.decode(res);
        OrderdetailsByidModel obj = OrderdetailsByidModel.fromJson(jsonData);
        orderID = orderId;
        editNO = editNo;
        CustmrID = obj.data.header.first.customerId;
        CustmrName = obj.data.header.first.customerName;
        log("------------>>>>order id: $orderID");
        log("--------->>>>>edit id: $editNO");
        print("lpo Length ${obj.data.details.length}");
        details = obj.data.details;
        header=obj.data.header;
        notifyListeners();
      } else {
        details = [];
        notifyListeners();
        return;
      }
    } catch (e) {
      log("Error fetching details: $e");
      details = [];
      notifyListeners();
    }
  }

  // Calculate item price based on quantity and price
  String getItemPrice(int index, dynamic quantity) {
    details[index].total =
        (double.parse(details[index].price) * double.parse(details[index].qty))
            .toStringAsFixed(2);
    return details[index].total;
  }

  double totalPrice = 0.0;
  double totalVat = 0.0;
// Add totalQuantity as a state variable
  double totalQuantity = 0.0;

// Function to calculate total quantity
  String getTotalQuantity() {
    if (details.isNotEmpty) {
      double quantitySum = details.fold(0, (sum, item) {
        return sum + double.parse(item.qty);
      });

      // Only update if totalQuantity has changed
      if (totalQuantity != quantitySum) {
        totalQuantity = double.parse(
            quantitySum.toStringAsFixed(2)); // Set to 2 decimal points
      }

      return totalQuantity.toStringAsFixed(2); // Return as 2 decimal string
    } else {
      return "0.00"; // 2 decimal format for empty state
    }
  }

  String getPrice() {
    if (details.isNotEmpty) {
      double totalSum = details.fold(0, (sum, item) {
        return sum + (double.parse(item.price) * double.parse(item.qty));
      });
      double totalvat = details.fold(0, (vat, item) {
        return vat + (double.parse(item.vat));
      });

      // Only update if values have changed
      if (totalPrice != totalSum || totalVat != totalvat) {
        totalPrice = double.parse(
            totalSum.toStringAsFixed(2)); // Set to 2 decimal points
        totalVat = double.parse(
            totalvat.toStringAsFixed(2)); // Set to 2 decimal points
        return totalPrice.toStringAsFixed(2); // Return as 2 decimal string
      }

      return totalPrice.toStringAsFixed(2); // Return as 2 decimal string
    } else {
      return "0.00"; // 2 decimal format for empty state
    }
  }

  // Get VAT value
  getVat() {
    getPrice();
    return totalVat;
  }

  // Confirm changes in the purchase order
  confirmFunction(
    List<Detail> productItemsList,
    context,
  ) async {
    getPrice();

    // Pass the transformed list to the API
    var res = await editPurchaseOrderApi(
      customerId: CustmrID,
      customername: CustmrName,
      PurchaseOrderList: productItemsList, // Use transformedList here
      totalPrice: totalPrice,
      Vat: totalVat,
      docStatus: 'U',
      editNo: editNO,
      orderID: orderID,
    );

    // Check the response from the API
    if (res != 'Failed') {
      showSnackBar(context, "", "Saved", Colors.white);
      Navigator.pop(context);
      // Handle success case
    } else {
      showSnackBar(context, "", "Error", Colors.red);
      // Handle failure case
    }
  }

  // Delete an item from the list
  deleteIndex(index, context) {
    details.removeAt(index);
    showSnackBar(context, "", "Item Removed", Colors.red);
    notifyListeners();
    getPrice();
  }

  // Change quantity of an item
  changeQty(index, value, context) {
    details[index].qty = value;
    notifyListeners();
    //  showSnackBar(context, "", "Quantity Updated", Colors.white);
  }

  // add product button functions

  List<ItemData> itemData = [];
  List<ItemData> filteredItems = [];
  String _searchQuery = '';

// Fetch initial product data using `ProductDatum` with filtering logic
  Future<void> fetchProductData() async {
    var res = await ItemMasterGetAPI(searchText: "null");
    if (res != 'Failed') {
      var jsonData = json.decode(res);
      var itemModel = ItemModel.fromJson(jsonData);
      itemData = itemModel.data;
      // .map((item) => item.toProductDatum()).toList();

      // Apply filtering to exclude products already in `details`
      filteredItems = _filterOutDetails(itemData);

      notifyListeners();
    } else {
      itemData = [];
      filteredItems = [];
      notifyListeners();
    }
  }

// Update search query and filter items

  bool updateSearchQuery(String query) {
    _searchQuery = query;

    // Filter locally if query length is less than 3 characters
    if (query.length < 3) {
      filteredItems = _filterOutDetails(
        itemData
            .where((item) =>
                item.productName.toLowerCase().contains(query.toLowerCase()) ||
                item.productCode.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
      notifyListeners();
      return true;
    } else {
      // Call API for search with query
      searchByApi(query);
      notifyListeners();
      return false;
    }
  }

// Perform search with API and apply filtering
  Future<void> searchByApi(String value) async {
    var res =
        await ItemMasterGetAPI(searchText: value.isNotEmpty ? value : 'null');
    if (res != 'Failed') {
      var jsonData = json.decode(res);
      var obj = ItemModel.fromJson(jsonData);
      itemData = obj.data;
      // itemData = obj.data.map((item) => item.toProductDatum()).toList();

      // Apply filtering to exclude products already in `details`
      filteredItems = _filterOutDetails(itemData);

      notifyListeners();
    } else {
      itemData = [];
      filteredItems = [];
      notifyListeners();
    }
  }

// Helper method to filter out items from `details`
  List<ItemData> _filterOutDetails(List<ItemData> products) {
    // Get a set of product IDs from `details`
    final detailProductIds = details.map((detail) => detail.productId).toSet();

    // Filter out products that have the same product ID as any in `details`
    return products
        .where((product) =>
            !detailProductIds.contains(product.productId.toString()))
        .toList();
  }

  // Clear search and reset filtered items
  void clearSearch() {
    _searchQuery = '';
    filteredItems = itemData;
    notifyListeners();
  }

  void addProduct(ItemData product, int qty, BuildContext context) {
    // Check if product with the same productId already exists in the details list
    bool productExists =
        details.any((detail) => detail.productId == product.productId);

    if (productExists) {
      // Product exists, update its quantity
      int index =
          details.indexWhere((detail) => detail.productId == product.productId);
      Detail existingDetail = details[index];

      // Update the quantity
      existingDetail.qty = (int.parse(existingDetail.qty) + qty).toString();
      existingDetail.total =
          (double.parse(existingDetail.price) * int.parse(existingDetail.qty))
              .toString(); // Recalculate total
      showSnackBar(
          context,
          "Updated ${product.productName} quantity to ${existingDetail.qty}.",
          "Updated",
          Colors.white);
    } else {
      // Product does not exist, add it to the details list
      Detail newDetail = Detail(
        productId: product.productId.toString(),
        productName: product.productName,
        qty: qty.toString(),
        price: product.price.toString(),
        total: (product.price * qty).toString(), // Calculate total based on qty
        vat: product.vat.toString(),
        unit: product.unit.toString(),
        imageUrl: product.imageUrl,
        unitID: product.unit,
        uomCode: product.unitName,
        itemStatus: ""
      );

      details.add(newDetail);
      filteredItems = _filterOutDetails(itemData);
      notifyListeners();
      showSnackBar(context, "Added ${product.productName} with quantity $qty.",
          "Added", Colors.white);
    }
  }

  // ------------->>>>>>>>>>>>>

  Map<int, int> productQuantities =
      {}; // Map to store product IDs and their quantities

  // Get the quantity of a product by its ID
  int getQuantity(int productId) {
    return productQuantities[productId] ?? 0; // Return 0 if not found
  }
}
