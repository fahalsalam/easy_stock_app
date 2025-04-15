import 'dart:developer';
import 'package:easy_stock_app/controllers/providers/purchase_providers/item_list_provider/itemlist_provider.dart';
import 'package:easy_stock_app/models/masters/category_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/constants/colors/colors.dart';

Widget buildCategoryItem(PurchaseItemListProvider provider, int index,
    CategoryData categorydata, double screenHeight, double screenWidth) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300), // Faster animation
    curve: Curves.easeInOutCubic,
    decoration: BoxDecoration(
      color: provider.clickedIndex == index
          ? primaryColor.withOpacity(0.7)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        if (provider.clickedIndex == index)
          BoxShadow(
            color: primaryColor.withOpacity(0.4), // More visible shadow
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
      ],
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            provider.clickedIndex == index
                ? CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.network(
                        categorydata.imageUrl,
                        fit: BoxFit.cover, // Changed to cover for a better fit
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image,
                          size: 30,
                          color: provider.clickedIndex == index
                              ? Colors.grey.shade700 // Softer color
                              : Colors.white,
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 40,
                    width: 40,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        categorydata.imageUrl,
                        fit: BoxFit.cover, // Changed to cover for a better fit
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image,
                          size: 30,
                          color: provider.clickedIndex == index
                              ? Colors.grey.shade700 // Softer color
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: screenHeight * 0.02,
              child: Text(
                categorydata.categoryName,
                style: TextStyle(
                  fontSize: 11, // Slightly increased font size
                  fontWeight: FontWeight.w600,
                  color: provider.clickedIndex == index
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildCategoryListRow(
  PurchaseItemListProvider itemListProvider,
  double screenHeight,
  double screenWidth,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      width: screenWidth * 0.85,
      height: 60,
      // decoration: BoxDecoration(
      //   color: Colors.grey.withOpacity(0.2),
      //   borderRadius: BorderRadius.circular(15),
      // ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(right: 10),
        shrinkWrap: true,
        itemCount: itemListProvider.categoryList.length,
        itemBuilder: (context, index) {
          CategoryData categoryData = itemListProvider.categoryList[index];
          return GestureDetector(
            onTap: () {
              itemListProvider.cartVisibility(false);
              log("Selected Category ID: ${categoryData.categoryId}");
          
              itemListProvider.startLoading(); // Show loading spinner
              itemListProvider
                  .getProducts(categoryData.categoryId.toString());
          
              itemListProvider.updateClickedIndex(index);
          
              Future.delayed(const Duration(seconds: 2), () {
                itemListProvider
                    .stopLoading(); // Hide loading spinner after data fetch
                itemListProvider.cartVisibility(true);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: screenHeight * 0.12,
                // width: screenWidth * 0.185,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: itemListProvider.clickedIndex == index
                      ? primaryColor.withOpacity(0.7)
                      : Colors.grey.shade100.withOpacity(0.25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image.network(
                            categoryData.imageUrl,
                            fit: BoxFit
                                .cover, // Changed to cover for a better fit
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(
                              Icons.image,
                              size: 30,
                              color: itemListProvider.clickedIndex == index
                                  ? Colors.grey.shade700 // Softer color
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      SizedBox(
                        height: screenHeight * 0.02,
                        child: Text(
                          categoryData.categoryName,
                          style: TextStyle(
                            fontSize: 11, // Slightly increased font size
                            fontWeight: FontWeight.w600,
                            color: itemListProvider.clickedIndex == index
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

Widget buildCategoryList(
  PurchaseItemListProvider itemListProvider,
  double screenHeight,
  double screenWidth,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Container(
      height: screenHeight * 0.88,
      width: 50, // Adjusted width for category list
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListView.builder(
        // scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(bottom: 10),
        shrinkWrap: true,
        itemCount: itemListProvider.categoryList.length,
        itemBuilder: (context, index) {
          CategoryData categoryData = itemListProvider.categoryList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: GestureDetector(
              onTap: () {
                itemListProvider.cartVisibility(false);
                log("Selected Category ID: ${categoryData.categoryId}");

                itemListProvider.startLoading(); // Show loading spinner
                itemListProvider
                    .getProducts(categoryData.categoryId.toString());

                itemListProvider.updateClickedIndex(index);

                Future.delayed(const Duration(seconds: 2), () {
                  itemListProvider
                      .stopLoading(); // Hide loading spinner after data fetch
                  itemListProvider.cartVisibility(true);
                });
              },
              child: Consumer<PurchaseItemListProvider>(
                builder: (context, provider, child) {
                  return buildCategoryItem(
                      provider, index, categoryData, screenHeight, screenWidth);
                },
              ),
            ),
          );
        },
      ),
    ),
  );
}
