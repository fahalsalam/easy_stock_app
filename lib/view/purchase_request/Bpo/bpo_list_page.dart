import 'dart:developer';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/view/purchase_request/Bpo/bpo_details/bpo_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/providers/purchase_request/bpo/bpoProvider.dart';
import '../../../utils/common_widgets/background_image_widget.dart';
import '../../../utils/common_widgets/custom_appbar.dart';
import '../../../utils/constants/images/images.dart';
import '../../../models/purchase/bpo_model.dart';

class BpoListPage extends StatefulWidget {
  String id;
  List<Item> items;
  BpoListPage({Key? key, required this.id, required this.items})
      : super(key: key);

  @override
  State<BpoListPage> createState() => _BpoListPageState();
}

class _BpoListPageState extends State<BpoListPage> with RouteAware {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadData();
    log('log form init ,len: ${widget.items.length}');
    isLoading = false;
  }

  void _loadData() async {
    try {
      await Provider.of<BpoProvider>(context, listen: false).fetchData();
      await Provider.of<BpoProvider>(context, listen: false)
          .fetchDatabyid(widget.id);
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  Future<void> _loadDatas() async {
    setState(() {
      isLoading = true;
    });
    try {
      final bpoProvider = Provider.of<BpoProvider>(context, listen: false);
      await bpoProvider.fetchData();
      await bpoProvider.fetchDatabyid(widget.id);
    } catch (e) {
      log('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bpoProvider = Provider.of<BpoProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          // Positioned(
          //   top: screenHeight * 0.05,
          //   left: screenWidth * 0.05,
          //   child: CustomAppBar(txt: "BPO"),
          // ),
          Positioned(
            top: screenHeight * 0.05,
            // screenHeight * 0.13,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back,
                                color: Colors.white, size: 22)),
                        SizedBox(width: 6),
                        Text(
                          "BPO List",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white12, width: 1),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.white70, size: 14),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "View and manage your BPO items here",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  bpoProvider.isLoading || isLoading
                      ? _buildShimmerLoading(screenHeight, screenWidth)
                      : bpoProvider.products.isEmpty
                          ? SizedBox(
                              height: screenHeight * 0.25,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 36,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      "No BPO Items Found",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Consumer<BpoProvider>(
                              builder: (context, provider, child) {
                                return Container(
                                  height: screenHeight * 0.82,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.white24, width: 1),
                                  ),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: provider.products.length,
                                    itemBuilder: (context, index) {
                                      Item data = provider.products[index];
                                      return GestureDetector(
                                        onTap: () {
                                          bool isLast =
                                              provider.products.length == 1;
                                          log("BPO details page last: $isLast");
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BpoDetailsPage(
                                                productID: data.productId,
                                                data: data,
                                                isLast: isLast,
                                              ),
                                            ),
                                          ).then((_) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            _loadData();
                                            Future.delayed(
                                                const Duration(seconds: 2));
                                            setState(() {
                                              isLoading = false;
                                            });
                                          });
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Container(
                                            height: screenHeight * 0.08,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.white24,
                                                  width: 1),
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: Container(
                                                    height: screenHeight * 0.06,
                                                    width: screenWidth * 0.12,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      border: Border.all(
                                                          color: Colors.white24,
                                                          width: 1),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: Image.network(
                                                        data.imageUrl,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            const Icon(
                                                                Icons.image,
                                                                size: 24,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 6),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          data.productName,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            height: 3),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          6,
                                                                      vertical:
                                                                          1),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                              ),
                                                              child: Text(
                                                                '${double.parse(data.qty).toStringAsFixed(2)} ${data.uomCode}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      primaryColor,
                                                                  fontSize: 11,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 6),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          6,
                                                                      vertical:
                                                                          1),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: primaryColor
                                                                    .withOpacity(
                                                                        0.2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                              ),
                                                              child: Text(
                                                                'AED ${double.parse(data.price).toStringAsFixed(2)}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      primaryColor,
                                                                  fontSize: 11,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
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
                              },
                            ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openEditPriceDialog(BuildContext context, double value, int id,
      double screenWidth, double screenHeight, BpoProvider bpoProvider) {
    final TextEditingController _priceController =
        TextEditingController(text: value.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white24, width: 1),
          ),
          title: const Text(
            "Edit Price",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Container(
            width: screenWidth * 0.8,
            height: screenHeight * 0.06,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: TextField(
              controller: _priceController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Enter Price',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedPrice = _priceController.text;
                if (updatedPrice.isNotEmpty) {
                  Navigator.of(context).pop();
                  try {
                    await bpoProvider.updateBulkPrice(
                      productId: id,
                      price: double.parse(updatedPrice),
                      context: context,
                    );
                    await _loadDatas();
                  } catch (e) {
                    log('Error updating price: $e');
                  }
                } else {
                  showSnackBar(context, "", 'Enter valid data', Colors.red);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Update",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildShimmerLoading(double screenHeight, double screenWidth) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[700]!,
    highlightColor: Colors.grey[400]!,
    child: Container(
      height: screenHeight * 0.7,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: screenHeight * 0.12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    ),
  );
}
