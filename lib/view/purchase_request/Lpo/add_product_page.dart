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
  String searchQuery = "";
  late List<TextEditingController> quantityControllers;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    quantityControllers = [];
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
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: CustomAppBar(txt: "Add Products"),
                ),
                Expanded(
                  child: Consumer<LpolistProvider>(
                    builder: (context, lpoListProvider, child) {
                      final filteredProducts =
                          lpoListProvider.filteredItems.where((product) {
                        return product.productName
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase());
                      }).toList();

                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
                        child: Column(
                          children: [
                            SizedBox(height: screenHeight * 0.02),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.white24, width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.search,
                                          color: primaryColor, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        "Search Products",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    cursorColor: primaryColor,
                                    onChanged: (value) {
                                      lpoListProvider.updateSearchQuery(
                                          searchController.text);
                                    },
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search products...',
                                      hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.5)),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.1),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Colors.white24, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 1),
                                      ),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: filteredProducts.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.search_off_rounded,
                                            size: 48,
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            "No Products Found",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
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
          ),
        ],
      ),
    );
  }

  Widget allProductListTile(
    ItemData product,
    int index,
    LpolistProvider lpoListProvider,
    List<TextEditingController> quantityControllers,
  ) {
    int currentQuantity = lpoListProvider.getQuantity(product.productId);

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

    bool isQuantityEntered = quantityControllers[index].text.isNotEmpty;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isQuantityEntered ? primaryColor : Colors.white24,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.image,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.productName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "${product.price.toStringAsFixed(2)} AED",
                                    style: const TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "UOM: ${product.unit}",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "Category: ${product.category}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          cursorColor: primaryColor,
                          controller: quantityControllers[index],
                          decoration: InputDecoration(
                            hintText: 'Enter quantity',
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.white24, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: primaryColor, width: 1),
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
                      const SizedBox(width: 8),
                      Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () {
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
                                Colors.red,
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isQuantityEntered
                                  ? primaryColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                "Add",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
