import 'package:easy_stock_app/controllers/providers/purchase_providers/lpoList_providers/lpoList_provider.dart';
import 'package:easy_stock_app/models/masters/item_model/item_model.dart';
import 'package:easy_stock_app/utils/common_widgets/background_image_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LpoAddProductPage extends StatefulWidget {
  const LpoAddProductPage({super.key});

  @override
  State<LpoAddProductPage> createState() => _LpoAddProductPageState();
}

class _LpoAddProductPageState extends State<LpoAddProductPage> {
  double screenHeight = 0;
  double screenWidth = 0;
  bool isLoading = true;
  String searchQuery = ""; // To hold the search query
  late List<TextEditingController> quantityControllers;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();

    // Initialize quantityControllers list
    quantityControllers = [];

    // Fetch product data
    Future.microtask(() {
      final lpoListProvider =
          Provider.of<LpolistProvider>(context, listen: false);
      lpoListProvider.fetchProductData();
    }).then((_) {
      setState(() {
        isLoading = false;
      });
    });
    searchController.clear();
  }

  @override
  void dispose() {
    // Dispose of all controllers
    for (var controller in quantityControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: CustomAppBar(txt: "Add Products"),
          ),
          Positioned(
            top: screenHeight * 0.115,
            left: 0,
            right: 0,
            child: Consumer<LpolistProvider>(
              builder: (context, lpoListProvider, child) {
                final filteredProducts =
                    lpoListProvider.filteredItems.where((product) {
                  return product.productName
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                }).toList();

                // if (filteredProducts.isEmpty) {
                // return SizedBox(
                //   height: screenHeight * 0.5,
                //   child: const Center(
                //     child: Text(
                //       "No products",
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 16,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ),
                // );
                // }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Search Bar
                      SizedBox(
                        height: screenHeight * 0.056,
                        child: Center(
                          child: TextField(
                            cursorColor: primaryColor,
                            onChanged: (value) {
                              // setState(() {
                              //   isLoading = true;
                              // });
                              // Future.delayed(Duration(seconds: 1));
                              lpoListProvider
                                  .updateSearchQuery(searchController.text);
                              // setState(() {
                              //   isLoading = false;
                              // });
                              // if (res) {
                              //   searchController.clear();
                              //   lpoListProvider.fetchProductData();
                              // }
                            },
                            controller: searchController,
                            decoration: InputDecoration(
                              hintStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              hintText: 'Search products...',
                              suffix: IconButton(
                                onPressed: () {
                                  // setState(() {
                                  //   isLoading = true;
                                  // });
                                  // Future.delayed(Duration(seconds: 1));
                               lpoListProvider
                                      .updateSearchQuery(searchController.text);
                                  // setState(() {
                                  //   isLoading = false;
                                  // });
                                  // if (res) {
                                  //   searchController.clear();
                                  //   // lpoListProvider.fetchProductData();
                                  // }
                                },
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Product List
                      filteredProducts.isEmpty
                          ? SizedBox(
                              height: screenHeight * 0.5,
                              child: const Center(
                                child: Text(
                                  "No products",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: screenHeight * 0.75,
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                    bottom: screenHeight * 0.15),
                                itemCount: filteredProducts.length,
                                itemBuilder: (context, index) {
                                  final product = filteredProducts[index];
                                  return allProductListTile(
                                    product,
                                    index,
                                    lpoListProvider,
                                    quantityControllers,
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget allProductListTile(
      ItemData product,
      int index,
      LpolistProvider lpoListProvider,
      List<TextEditingController> quantityControllers) {
    // Retrieve the quantity from the provider
    int currentQuantity = lpoListProvider.getQuantity(product.productId);

    // Initialize the controller only once for each product index
    if (quantityControllers.length <= index) {
      quantityControllers.add(
        TextEditingController(
          text: currentQuantity == 0 ? "" : currentQuantity.toString(),
        ),
      );
    } else {
      quantityControllers[index].text =
          currentQuantity == 0 ? "" : currentQuantity.toString();
    }

    // Track whether the "Add" button and border color should change
    bool isQuantityEntered = quantityControllers[index].text.isNotEmpty;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            height: screenHeight * 0.2,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isQuantityEntered ? primaryColor : Colors.transparent,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.panorama,
                              size: 45,
                              color: Color.fromARGB(255, 97, 92, 74),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Price: ${product.price.toStringAsFixed(2)} AED",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "UOM: ${product.unit}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Category: ${product.category}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            cursorColor: primaryColor,
                            controller: quantityControllers[index],
                            decoration: InputDecoration(
                              hintText: 'Enter quantity',
                              hintStyle: const TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                isQuantityEntered = value.isNotEmpty;
                              });
                            },
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        ElevatedButton(
                          onPressed: () {
                            String quantityText =
                                quantityControllers[index].text;
                            int? quantity = int.tryParse(quantityText);
                            if (quantity != null) {
                              lpoListProvider.addProduct(
                                  product, quantity, context);
                                  searchController.clear();
                            } else {
                              showSnackBar(
                                  context,
                                  "Please enter a valid quantity",
                                  "Error",
                                  Colors.red);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isQuantityEntered ? primaryColor : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Add",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


}
