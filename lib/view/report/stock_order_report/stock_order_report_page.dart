import 'package:easy_stock_app/models/report/stock_item_model.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:flutter/material.dart';
import '../../../utils/common_widgets/background_image_widget.dart';
import '../../../utils/constants/colors/colors.dart';

class StockOrderReportPage extends StatelessWidget {
  StockOrderReportPage({super.key});

  final List<StockItem> stockItems = [
    StockItem(name: 'Rice', demand: '100kg', allocate: '80kg'),
    StockItem(name: 'Wheat', demand: '200kg', allocate: '150kg'),
    StockItem(name: 'Corn', demand: '300kg', allocate: '250kg'),
    StockItem(name: 'Rice', demand: '100kg', allocate: '80kg'),
    StockItem(name: 'Wheat', demand: '200kg', allocate: '150kg'),
    StockItem(name: 'Corn', demand: '300kg', allocate: '250kg'),
    StockItem(name: 'Rice', demand: '100kg', allocate: '80kg'),
    StockItem(name: 'Wheat', demand: '200kg', allocate: '150kg'),
    StockItem(name: 'Corn', demand: '300kg', allocate: '250kg'),
  ];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(
            image: common_backgroundImage,
          ),
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: CustomAppBar(txt: "Order Report"),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.142,
            left: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    "Check out the differences between Demand Stock and Allocate Stock.",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "Stock Difference",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  height: MediaQuery.of(context).size.height * 0.78,
                  width: MediaQuery.of(context).size.width * 0.82,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: stockItems.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final item = stockItems[index];
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 0.2, color: Colors.white),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          "Demand",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: primaryColor,
                                          ),
                                        ),
                                        Text(
                                          item.demand,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Text(
                                          "Allocate",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: primaryColor,
                                          ),
                                        ),
                                        Text(
                                          item.allocate,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
