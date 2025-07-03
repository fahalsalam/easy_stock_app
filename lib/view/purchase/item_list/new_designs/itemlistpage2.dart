import 'package:easy_stock_app/controllers/providers/purchase_providers/item_list_provider/itemlist_provider.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase/item_list/item_list_cart/item_list_cart_page.dart';
import 'package:easy_stock_app/view/purchase/item_list/item_list_page/item_list_widgets/category_item_widget.dart';
import 'package:easy_stock_app/view/purchase/item_list/item_list_page/item_list_widgets/goto_cart_button.dart';
import 'package:easy_stock_app/view/purchase/item_list/item_list_page/item_list_widgets/item_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/common_widgets/background_image_widget.dart';

class ItemListPage2 extends StatefulWidget {
  const ItemListPage2({super.key});

  @override
  State<ItemListPage2> createState() => _ItemListPage2State();
}

class _ItemListPage2State extends State<ItemListPage2> {
  TextEditingController _searchController = TextEditingController();
  // bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final itemListProvider = Provider.of<PurchaseItemListProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),

          // Make the entire content scrollable
          SingleChildScrollView(
            child: Column(
              children: [
                // Top spacing for status bar
                SizedBox(height: screenHeight * 0.06),

                // Header with back button and search
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 42,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                            onPressed: () {
                              if (itemListProvider.cartItems.isNotEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Unsaved Changes"),
                                      content: const Text(
                                          "Please Confirm Cart before existing"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); // Close the dialog without going back
                                          },
                                          child: const Text(
                                            "Cancel",
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            itemListProvider.clearCartItems();
                                            Navigator.pop(
                                                context); // Close the dialog
                                            Navigator.pop(
                                                context); // Go back to the previous screen without saving
                                          },
                                          child:
                                              const Text("Exit Without Saving"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 22,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextFormField(
                              controller: _searchController,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    itemListProvider
                                        .searchByApi(_searchController.text);
                                  },
                                  icon: Icon(Icons.search,
                                      color: _searchController.text.isEmpty
                                          ? Colors.grey
                                          : Colors.white),
                                ),
                                hintText: 'Search...',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.15),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.01),

                // Main content area with categories and items
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.5),
                      child: buildCategoryListRow(
                        itemListProvider,
                        screenHeight,
                        screenWidth,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: itemListProvider.isLoading
                          ? SizedBox(
                              height: screenHeight * 0.5,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : buildItemListRowScrollable(
                              screenHeight,
                              screenWidth,
                              itemListProvider,
                              _searchController.text.isEmpty
                                  ? itemListProvider.filteredProductDatas
                                  : itemListProvider.itemdata,
                            ),
                    ),
                  ],
                ),

                // Bottom spacing for cart button
                SizedBox(height: screenHeight * 0.15),
              ],
            ),
          ),

          // Fixed cart button at bottom
          if (itemListProvider.cartItems.isNotEmpty &&
              itemListProvider.isCartVisible == true)
            Positioned(
              bottom: screenHeight * 0.05,
              left: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * 0.05,
                    width: screenWidth * 0.9,
                    child: GotoCartButton(
                      txt: "Go to Cart",
                      screenHeight: screenHeight * 0.05,
                      screenWidth: screenWidth * 0.7,
                      length: itemListProvider.cartItems.length,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ItemlistCartPage(),
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
}
