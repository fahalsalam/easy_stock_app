import 'package:easy_stock_app/controllers/providers/purchase_providers/item_list_provider/itemlist_provider.dart';
import 'package:easy_stock_app/models/purchase_order/productData_model.dart';
import 'package:easy_stock_app/view/purchase/item_list/item_list_page/item_list_widgets/productCard_widget.dart';
import 'package:easy_stock_app/view/purchase/item_list/item_list_page/item_list_widgets/rowcarditem.dart';
import 'package:flutter/material.dart';

Widget buildItemList(double screenHeight, double screenWidth,
    PurchaseItemListProvider provider, List<ProductDatum> list
    //  CartProvider cartProvider,
    ) {
  return SizedBox(
    height: screenHeight * 0.76,
    width: screenWidth * 0.8,
    child: provider.filteredProductDatas.isEmpty
        ? const Center(
            child: Text(
              "No Products",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.only(bottom: 350, top: 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 0,
              childAspectRatio: 0.8,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return list.isEmpty
                  ? const Center(
                      child: Text(
                      'No Product to Show',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ))
                  : screenWidth >= 600
                      ? buildProductCardTab(
                          list[index],
                          screenHeight,
                          screenWidth,
                          context,
                        )
                      : buildProductCard(
                          list[index],
                          screenHeight,
                          screenWidth,
                          context,
                        );
            },
          ),
  );
}

Widget buildItemListRow(double screenHeight, double screenWidth,
    PurchaseItemListProvider provider, List<ProductDatum> list
    //  CartProvider cartProvider,
    ) {
  return SizedBox(
    height: screenHeight * 0.76,
    width: screenWidth * 0.8,
    child: provider.filteredProductDatas.isEmpty
        ? const Center(
            child: Text(
              "No Products",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.only(bottom: 350, top: 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 0,
              childAspectRatio: 0.8,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return list.isEmpty
                  ? const Center(
                      child: Text(
                      'No Product to Show',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ))
                  : screenWidth >= 600
                      ? buildProductCardTab(
                          list[index],
                          screenHeight,
                          screenWidth,
                          context,
                        )
                      : ProductCardRow(
                          product: list[index],
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          // context,
                        );
            },
          ),
  );
}

// New scrollable function for entire page scroll
Widget buildItemListScrollable(double screenHeight, double screenWidth,
    PurchaseItemListProvider provider, List<ProductDatum> list) {
  return provider.filteredProductDatas.isEmpty
      ? SizedBox(
          height: screenHeight * 0.5,
          child: const Center(
            child: Text(
              "No Products",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
      : Column(
          children: [
            GridView.builder(
              shrinkWrap: true, // Important: allows grid to size itself
              physics:
                  const NeverScrollableScrollPhysics(), // Disable grid's own scrolling
              padding: const EdgeInsets.only(top: 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.8,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return list.isEmpty
                    ? const Center(
                        child: Text(
                        'No Product to Show',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ))
                    : screenWidth >= 600
                        ? buildProductCardTab(
                            list[index],
                            screenHeight,
                            screenWidth,
                            context,
                          )
                        : ProductCardRow(
                            product: list[index],
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                          );
              },
            ),
          ],
        );
}

// New scrollable function for row-based layout (itemlistpage2)
Widget buildItemListRowScrollable(double screenHeight, double screenWidth,
    PurchaseItemListProvider provider, List<ProductDatum> list) {
  return provider.filteredProductDatas.isEmpty
      ? SizedBox(
          height: screenHeight * 0.5,
          child: const Center(
            child: Text(
              "No Products",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
      : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.builder(
            shrinkWrap: true, // Important: allows grid to size itself
            physics:
                const NeverScrollableScrollPhysics(), // Disable grid's own scrolling
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0, // Better horizontal spacing
              mainAxisSpacing: 20.0, // Better vertical spacing
              childAspectRatio: 0.75, // Better aspect ratio for taller cards
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return list.isEmpty
                  ? const Center(
                      child: Text(
                      'No Product to Show',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ))
                  : screenWidth >= 600
                      ? buildProductCardTab(
                          list[index],
                          screenHeight,
                          screenWidth,
                          context,
                        )
                      : ProductCardRow(
                          product: list[index],
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                        );
            },
          ),
        );
}
