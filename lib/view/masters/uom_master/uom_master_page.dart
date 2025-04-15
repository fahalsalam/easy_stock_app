import 'package:easy_stock_app/controllers/providers/masters_provider/uom_master/uom_master_provider.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/masters/uom_master/uom_widgets/uom_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/common_widgets/background_image_widget.dart';
import '../../../utils/constants/colors/colors.dart';

class UOMMasterListPage extends StatefulWidget {
  UOMMasterListPage({super.key});

  @override
  State<UOMMasterListPage> createState() => _UOMMasterListPageState();
}

class _UOMMasterListPageState extends State<UOMMasterListPage> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Provider.of<UomMasterProvider>(context, listen: false).fetchData().then((_) {
        setState(() {
          isLoading = false;
        });
      });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uomProvider = Provider.of<UomMasterProvider>(context);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Removed Positioned here, CustomAppBar is now directly inside the Column
                CustomAppBar(txt: "UOM Master"),
                SizedBox(height: screenHeight * 0.031),
                // const SearchWidget(),
                // SizedBox(height: screenHeight * 0.031),
                Consumer<UomMasterProvider>(
                    builder: (context, provider, child) {
                  return Container(
                    height: screenHeight * 0.8,
                    child: isLoading
                        ? SizedBox(
                            height: screenHeight * 0.8,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : uomProvider.UomList.isEmpty
                            ? const Center(
                                child: Text(
                                  "No Data",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.only(
                                    bottom: screenHeight * 0.03),
                                    // reverse: true,
                                shrinkWrap: true,
                                itemCount: uomProvider.UomList.length,
                                itemBuilder: (context, index) {
                                  final product = uomProvider.UomList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Container(
                                      height: screenHeight * 0.081,
                                      width: screenWidth * 0.3,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor: primaryColor,
                                                child: Text(
                                                  product.uomCode != null &&
                                                          product.uomCode!
                                                              .isNotEmpty
                                                      ? product.uomCode![0]
                                                          .toUpperCase()
                                                      : '', // Display nothing or a fallback if uomCode is null or empty
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.uomCode.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  product.uomDescription
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              onPressed: () {
                                                UOMshowBottomSheet(
                                                  context,
                                                  "Edit",
                                                  UomID:
                                                      product.uomid.toString(),
                                                  unitName: product.uomCode
                                                      .toString(),
                                                  unitDesc: product
                                                      .uomDescription
                                                      .toString(),
                                                  onRefresh: () {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    Provider.of<UomMasterProvider>(
                                                            context,
                                                            listen: false)
                                                        .fetchData()
                                                        .then((_) {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                    });
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 20,
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
              ],
            ),
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
          UOMshowBottomSheet(
            context,
            "ADD",
            onRefresh: () {
              setState(() {
                isLoading = true;
              });
              Provider.of<UomMasterProvider>(context, listen: false)
                  .fetchData()
                  .then((_) {
                setState(() {
                  isLoading = false;
                });
              });
            },
          );
        },
      ),
    );
  }
}
