import 'package:easy_stock_app/controllers/providers/masters_provider/item_master_provider/item_master_provider.dart';
import 'package:easy_stock_app/utils/common_widgets/background_image_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/home/home_widgets/search_widget/search_widget.dart';
import 'package:easy_stock_app/view/masters/item_master/add_item/item_master_add_itempage.dart';
import 'package:easy_stock_app/view/masters/item_master/edit_item/edit_item_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MastersProductListPage extends StatefulWidget {
  const MastersProductListPage({super.key});

  @override
  State<MastersProductListPage> createState() => _MastersProductListPageState();
}

class _MastersProductListPageState extends State<MastersProductListPage> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ItemMasterProvider>(context, listen: false)
          .fetchData()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemmasterProvider = Provider.of<ItemMasterProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: CustomAppBar(txt: "Item Master"),
          ),
          Positioned(
            top: screenHeight * 0.14,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: const SearchWidget(),
          ),
          Positioned(
            top: screenHeight * 0.20,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: Consumer<ItemMasterProvider>(
                builder: (context, provider, child) {
              return SizedBox(
                height: screenHeight * 0.75,
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : itemmasterProvider.items.isEmpty
                        ? const Center(
                            child: Text(
                              "No products",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding:
                                EdgeInsets.only(bottom: screenHeight * 0.15),
                            shrinkWrap: true,
                            itemCount: itemmasterProvider.items.length,
                            itemBuilder: (context, index) {
                              final product = itemmasterProvider.items[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  height: screenHeight *
                                      0.15, // Adjust height to fit 2-line display
                                  width: screenWidth * 0.3,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: screenWidth * 0.02,
                                        ),
                                        // Image Container
                                        Center(
                                          child: Container(
                                            height: screenHeight *
                                                0.075, // Adjust image height
                                            width: screenWidth *
                                                0.2, // Adjust image width
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12), // Rounded corners
                                              // You can adjust the border radius value to make the corners more or less rounded
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(
                                                  12), // Apply rounded corners to the image as well
                                              child: Image.network(
                                                product.imageUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Icon(
                                                  Icons.panorama,
                                                  size: 45,
                                                  color: Color.fromARGB(
                                                      255, 97, 92, 74),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.05,
                                        ),

                                        // Text Column with 2-line layout
                                        SizedBox(
                                          height: screenHeight * 0.2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // First Line: Product Name and Edit Icon
                                              Row(
                                                children: [
                                                  // Product name
                                                  SizedBox(
                                                    width: screenWidth * 0.5,
                                                    child: Text(
                                                      product.productName,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      overflow: TextOverflow
                                                          .ellipsis, // Handle long text
                                                    ),
                                                  ),

                                                  // Edit icon
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ItemMasterEditItemPage(
                                                                  product:
                                                                      product),
                                                        ),
                                                      ).then((_) {
                                                        WidgetsBinding.instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          Provider.of<ItemMasterProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .fetchData();
                                                        });
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              // Second Line: Product Details (Price, UOM, Barcode)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Text(
                                                      "Price: ${(product.price).toStringAsFixed(2)} AED",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Text(
                                                      "UOM: ${product.unitName}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Text(
                                                      "Category: ${product.categoryName}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
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
                          ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor.withOpacity(0.5),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ItemMasterAddItemPage(),
            ),
          ).then((_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Provider.of<ItemMasterProvider>(context, listen: false)
                  .fetchData();
            });
          });
        },
      ),
    );
  }
}
