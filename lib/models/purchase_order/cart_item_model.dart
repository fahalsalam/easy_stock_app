import 'package:easy_stock_app/models/purchase_order/productData_model.dart';

class ProductItem {
  ProductDatum productData;
  double quantity;

  ProductItem({required this.productData, this.quantity = 0});
}
