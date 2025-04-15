import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/report/overall_bussiness_configure/circle_progress_indicator/circle_progress_indicator.dart';
import 'package:flutter/material.dart';
import '../../../utils/common_widgets/background_image_widget.dart';

class UserConfigurePage extends StatefulWidget {
  const UserConfigurePage({super.key});

  @override
  _UserConfigurePageState createState() => _UserConfigurePageState();
}

class _UserConfigurePageState extends State<UserConfigurePage> {
  String? _selectedValue;
  DateTime? _fromDate;
  DateTime? _toDate;

  final List<String> _dropdownItems = ['Option 1', 'Option 2', 'Option 3'];
  final List<String> barchart_Items = ["80", "40", "20", "10", "15", "35"];

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   
final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(
            image: common_backgroundImage,
          ),
          Positioned(
                top:screenHeight* 0.06,
              left: screenWidth *0.05,
            child: CustomAppBar(
              txt: "User Configure",
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top:screenHeight* 0.12,
              left: 15,
              right: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDropdownMenu(),
                _buildDatePickers(context),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildWhiteContainer(screenHeight,screenWidth),
                        // _buildBarChart(),
                        _buildGridView(screenHeight,screenWidth),
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

  Widget _buildDropdownMenu() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Container(
        height: 35,
        width: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
          ),
          value: _selectedValue,
          items: _dropdownItems.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
          },
          hint: Text(
            'Select',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickers(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDatePicker(context, true, _fromDate, 'From'),
          _buildDatePicker(context, false, _toDate, 'To'),
        ],
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, bool isFromDate,
      DateTime? selectedDate, String placeholder) {
    return GestureDetector(
      onTap: () => _selectDate(context, isFromDate),
      child: Container(
        width: 150,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? '${selectedDate.toLocal()}'.split(' ')[0]
                  : placeholder,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.calendar_today,
              size: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhiteContainer(screenHeight,screenWidth) {
    return Container(
      height:screenHeight* 0.3,
      width:screenWidth* 0.8,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: Center(
          child: DynamicCircularIndicator(
            percentage: 20.0, // Example percentage
            color: Colors.grey, // Background color
            progressColor: Colors.amber, // Progress color
            size: 250.0, // Diameter of the circle
          ),
        ),
      ),
    );
  }

  // Widget _buildBarChart() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 10.h),
  //     child: SizedBox(
  //       height: 0.32.sh,
  //       width: 0.98.sw,
  //       child: BarChart(
  //         BarChartData(
  //           titlesData: FlTitlesData(
  //             bottomTitles: AxisTitles(
  //               sideTitles: SideTitles(
  //                 showTitles: true,
  //                 reservedSize: 50,
  //                 getTitlesWidget: (value, meta) {
  //                   int index = value.toInt();
  //                   return SideTitleWidget(
  //                     axisSide: meta.axisSide,
  //                     child: Text(
  //                       '${barchart_Items[index]}',
  //                       style: TextStyle(fontSize: 14.sp, color: Colors.white),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //             leftTitles: AxisTitles(
  //               sideTitles: SideTitles(
  //                 showTitles: true,
  //                 reservedSize: 70.w,
  //                 interval: 1,
  //                 getTitlesWidget: (value, meta) {
  //                   return SideTitleWidget(
  //                     axisSide: meta.axisSide,
  //                     child: Text(
  //                       '${(value.toInt() * 1000)}',
  //                       style: TextStyle(fontSize: 14.sp, color: Colors.white),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //           ),
  //           borderData: FlBorderData(
  //             show: true,
  //             border: Border.all(color: Colors.white),
  //           ),
  //           barGroups: _buildBarGroups(),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // List<BarChartGroupData> _buildBarGroups() {
  //   final colors = [
  //     Colors.blue,
  //     Colors.green,
  //     Colors.yellow,
  //     Colors.pink,
  //     Colors.purple,
  //     Colors.indigo,
  //   ];

  //   final barValues = [10, 2, 8, 6, 6.5, 4.566];

  //   return List.generate(
  //     barValues.length,
  //     (index) => BarChartGroupData(
  //       x: index,
  //       barRods: [
  //         BarChartRodData(
  //           width: 18,
  //           toY: double.parse(barValues[index].toString()),
  //           color: colors[index],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildGridView(screenHeight,screenWidth) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.pink,
      Colors.purple,
      Colors.indigo,
    ];

    final barList = [
      "Electronics",
      "Bakery",
      "Diary",
      "Beverages",
      "Vegetables",
      "Fruits"
    ];

    return Center(
      child: SizedBox(
        height:screenHeight* 0.24,
        width: screenWidth * 0.75,
        child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 2,
          ),
          itemCount: colors.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: colors[index],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    barList[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
