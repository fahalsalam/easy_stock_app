import 'package:easy_stock_app/controllers/providers/purchase_providers/history/historyProvider.dart';
import 'package:easy_stock_app/models/purchase_order/historyModel/historymodel.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase/history/history_totalitem_list/history_totalitem_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/common_widgets/background_image_widget.dart';
import '../../../../utils/constants/colors/colors.dart';

class HistoryLpoListPage extends StatefulWidget {
  const HistoryLpoListPage({super.key});

  @override
  State<HistoryLpoListPage> createState() => _HistoryLpoListPageState();
}

class _HistoryLpoListPageState extends State<HistoryLpoListPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PurchaseHistoryProvider>(context, listen: false).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final historyProvider = Provider.of<PurchaseHistoryProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          Positioned(
              top: screenHeight * 0.05,
              left: screenWidth * 0.04,
              child: CustomAppBar(txt: "History")),
          Positioned(
            top: screenHeight * 0.13,
            left: 0,
            right: 0,
            bottom: 0, // Allow content to extend to the bottom of the screen
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeader(),
                  const SizedBox(height: 10),
                  historyProvider.data.isEmpty
                      ? SizedBox(
                          height: screenHeight * 0.3,
                          child: const Center(
                            child: Text(
                              "No Data",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              padding:
                                  const EdgeInsets.only(bottom: 10, top: 10),
                              itemCount: historyProvider.data.length,
                              itemBuilder: (context, index) {
                                return buildLpoListSection(
                                    historyProvider.data[index].timeRange,
                                    screenHeight,
                                    screenWidth,
                                    historyProvider.data[index].records);
                              })),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return const Row(
      children: [
        Text(
          "LPO list",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        // const Spacer(),
        // PopupMenuButton<String>(
        //   color: Colors.grey.withOpacity(0.2),
        //   onSelected: (value) {
        //     // Handle sorting logic
        //     if (value == 'byDate') {
        //       // Sort by date logic
        //     } else if (value == 'byTime') {
        //       // Sort by time logic
        //     }
        //   },
        //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        //     PopupMenuItem<String>(
        //       value: 'byDate',
        //       child: buildPopupMenuItem('By Date', Icons.calendar_today),
        //     ),
        //     PopupMenuItem<String>(
        //       value: 'byTime',
        //       child: buildPopupMenuItem('By Time', Icons.access_time),
        //     ),
        //   ],
        //   child: const Text(
        //     "Sort",
        //     style: TextStyle(
        //       fontSize: 14,
        //       fontWeight: FontWeight.w500,
        //       color: primaryColor,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget buildPopupMenuItem(String text, IconData icon) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Icon(
          icon,
          color: Colors.white,
          size: 16,
        )
      ],
    );
  }

  Widget buildLpoListSection(String time, double screenHeight,
      double screenWidth, List<HistoryRecord> records) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            time,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          // height: screenHeight * 0.52,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: records.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return buildLpoItem(index, context, records[index], time,
                  screenWidth, screenHeight);
            },
          ),
        ),
      ],
    );
  }

  Widget buildLpoItem(int index, BuildContext context, HistoryRecord record,
      String time, double screenWidth, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.068,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: primaryColor,
                  child: Text(
                    record.customerName.isEmpty
                        ? ""
                        : record.customerName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth * 0.5,
                    child: Text(
                      record.customerName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "LPO: #${record.orderId}",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),

// Format the parsed DateTime to 12-hour format with AM/PM
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryTotalItemListPage(
                            orderId: record.orderId,
                            editno: record.editNo,
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.visibility,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
