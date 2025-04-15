// ignore_for_file: non_constant_identifier_names
import 'dart:developer';
import 'package:easy_stock_app/controllers/providers/purchase_request/bpo/bpoProvider.dart';
import 'package:easy_stock_app/main.dart';
import 'package:easy_stock_app/models/purchase/bpo_model.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase_request/Bpo/bpo_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/common_widgets/background_image_widget.dart';

class BpoItemListPage extends StatefulWidget {
  const BpoItemListPage({super.key});

  @override
  State<BpoItemListPage> createState() => _BpoItemListPageState();
}

class _BpoItemListPageState extends State<BpoItemListPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    // Fetch data on init
    await Provider.of<BpoProvider>(context, listen: false).fetchData();
  }

 

  @override
  void didPopNext() {
    // Called when this route is visible again after a pop
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final BpolistProvider = Provider.of<BpoProvider>(context);
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
            child: CustomAppBar(txt: "BPO"),
          ),
          Positioned(
            top: screenHeight * 0.13,
            left: 20,
            right: 20,
            child: Column(
              children: [
                SizedBox(
                  width: screenWidth * 0.87,
                  child: const Row(
                    children: [
                      Icon(Icons.info,color:Colors.white,size: 18,),
                      SizedBox(width: 5,),
                      Text(
                        "Just tap to edit your orders!",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                BpolistProvider.isLoading
                    ? SizedBox(
                        height: screenHeight * 0.3,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: screenHeight * 0.7,
                        child: BpolistProvider.data.isEmpty
                            ? const Center(
                                child: Text(
                                  "No Data",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : Consumer<BpoProvider>(
                                builder: (context, BpolistProvider, child) {
                                  return ListView.builder(
                                    padding: const EdgeInsets.only(
                                        top: 25, bottom: 25),
                                    shrinkWrap: true,
                                    itemCount: BpolistProvider.data.length,
                                    itemBuilder: (context, index) {
                                      BpoCategoryData data =
                                          BpolistProvider.data[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BpoListPage(
                                                         id: data.categoryId,
                                                         items: data.items)),
                                            );
                                            log("bpo items len: ${data.items.length}");
                                          },
                                          child: Container(
                                              padding: const EdgeInsets.all(8),
                                              height: screenHeight * 0.058,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[900]!,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    data.categoryName,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 112, 186, 20),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  const Icon(
                                                    Icons.keyboard_arrow_right,
                                                    color: Color.fromARGB(
                                                        255, 112, 186, 20),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      );
                                     
                                    },
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
