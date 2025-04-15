class Product {
  String ProductID;
  String ProductName;
  String Price;
  String Vat;
  String Qty;
  String Unit;
  String Total;

  Product({
    required this.ProductID,
    required this.ProductName,
    required this.Price,
    required this.Vat,
    required this.Qty,
    required this.Unit,
    required this.Total,
  });
  Map<String, dynamic> toJson() {
    return {
      'ProductID': ProductID,
      'ProductName':ProductName,
      'Price': Price,
      'Vat': Vat,
      'Qty': Qty,
      'Unit': Unit,
      'Total': Total,
    };
  }
}