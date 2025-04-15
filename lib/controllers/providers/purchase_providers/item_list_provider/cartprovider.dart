// import 'dart:developer';

// import 'package:easy_stock_app/models/purchase_order/cart_item_model.dart';
// import 'package:easy_stock_app/models/purchase_order/productModel.dart';
// import 'package:easy_stock_app/services/api_services/purchase_order/post_purchaseorder_api.dart';
// import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import '../../../../models/purchase_order/productData_model.dart';

// class CartProvider with ChangeNotifier {
//   List<ProductItem> _cartItems = [];
//   double totalPrice = 0.0;
//   double totalVat = 0.0;
//   List<ProductItem> get cartItems => _cartItems;
//   bool _isCartVisible = true;
//   get isCartVisible => _isCartVisible;

//   cartVisibility(bool value) {
//     log("cartvisiblity function");//     _isCartVisible = value;
//     notifyListeners();
//     log("cartvisiblity:$_isCartVisible");
//   }

//   // Updated addItemToCart method to accept quantity as an argument
//   void addItemToCart(ProductDatum productData, int quantity) {
//     int index = _cartItems.indexWhere(
//       (item) => item.productData.productId == productData.productId,
//     );

//     if (index != -1) {
//       // If the product is already in the cart, increase the quantity by the entered amount
//       _cartItems[index].quantity += quantity;
//     } else {
//       // Add a new ProductItem to the cart with the specified quantity
//       _cartItems.add(ProductItem(
//         productData: productData,
//         quantity: quantity, // Start with the specified quantity for new items
//       ));
//     }

//     notifyListeners(); // Notify listeners to update the UI
//   }

//   String getPrice() {
//     if (cartItems.isNotEmpty) {
//       double totalSum = cartItems.fold(0, (sum, item) {
//         return sum + (double.parse(item.productData.price) * item.quantity);
//       });
//       return totalSum.toString();
//     } else {
//       return "0";
//     }
//   }

//   String getTotalCartQty() {
//     if (cartItems.isNotEmpty) {
//       double totalSum = cartItems.fold(0, (sum, item) {
//         return sum + (item.quantity);
//       });
//       return totalSum.toString();
//     } else {
//       return "0";
//     }
//   }

//   void updatePriceAndVat() {
//     if (cartItems.isNotEmpty) {
//       totalPrice = cartItems.fold(0, (sum, item) {
//         return sum + (double.parse(item.productData.price) * item.quantity);
//       });
//       totalVat = cartItems.fold(0, (vat, item) {
//         return vat + (double.parse(item.productData.vat));
//       });
//     } else {
//       totalPrice = 0;
//       totalVat = 0;
//     }
//     notifyListeners(); // Call notifyListeners only after prices and VAT are updated
//   }

//   // Remove product from the cart
//   void removeItemFromCart(ProductDatum productItem) {
//     _cartItems.removeWhere(
//         (item) => item.productData.productId == productItem.productId);
//     notifyListeners();
//   }

//   // Increase quantity of a product
//   void increaseQuantity(ProductDatum productItem) {
//     int index = _cartItems.indexWhere(
//         (item) => item.productData.productId == productItem.productId);
//     if (index != -1) {
//       _cartItems[index].quantity++;
//       notifyListeners(); // Notify listeners to update the UI
//     }
//   }

//   // Decrease quantity of a product
//   void decreaseQuantity(ProductDatum productItem, context) {
//     int index = _cartItems.indexWhere(
//         (item) => item.productData.productId == productItem.productId);
//     if (index != -1) {
//       if (_cartItems[index].quantity > 1) {
//         _cartItems[index].quantity--;
//         showSnackBar(context, "", "Item Removed", Colors.white);
//       } else {
//         showSnackBar(context, "", "Item Removed", Colors.white);
//         // Remove product if quantity becomes zero
//         removeItemFromCart(productItem);
//       }
//       notifyListeners(); // Notify listeners to update the UI
//     }
//   }

//   Product transformToProduct(ProductItem productItems) {
//     return Product(
//         ProductID: productItems.productData.productId,
//         ProductName: productItems.productData.productName,
//         Price: productItems.productData.price,
//         Unit: productItems.productData.unit,
//         Qty: productItems.quantity.toString(),
//         Vat: productItems.productData.vat,
//         Total: (double.parse(productItems.productData.price) *
//                 productItems.quantity)
//             .toString());
//   }

//   confirmFunction(List<ProductItem> _cartItem, context) async {
//     // Transform the list of ProductItem to List<Product>
//     List<Product> productItemsList =
//         _cartItem.map((item) => transformToProduct(item)).toList();

//     // Pass the transformed list to the API
//     var res = await postPurchaseOrderApi(
//         productItemsList, totalPrice, totalVat, 'O', '0', '0');

//     // Check the response from the API
//     if (res != 'Failed') {
//       showSnackBar(context, "", "Saved", Colors.white);
//       _cartItem.clear();
//       notifyListeners();
//       Navigator.pop(context);
//       // Handle success case
//     } else {
//       // Handle failure case
//     }
//   }
//  CancelFunction(List<ProductItem> _cartItem, context) async {

//  _cartItem.clear();
// notifyListeners();
    
//   }
// }
