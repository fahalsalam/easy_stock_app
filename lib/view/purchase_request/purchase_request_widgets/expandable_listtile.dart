import 'package:easy_stock_app/models/purchase/bpo_model.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/colors/colors.dart';

class ExpandableListTile extends StatelessWidget {
  final String title; // Title of the ExpansionTile
  final Color titleColor; // Color of the title and icons
  final Color backgroundColor; // Background color of the tile
  final List<Item> contents; // Contents to display in the expanded area
  final TextStyle titleStyle; // Style for the title text
  Function(int value) onPressed;

  ExpandableListTile({
    super.key,
    required this.title,
    required this.titleColor,
    required this.backgroundColor,
    required this.contents,
    required this.onPressed,
    TextStyle? titleStyle, // Make titleStyle optional
  }) : titleStyle = titleStyle ??
            TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: titleColor,
            );

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
          color: backgroundColor, 
          borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        trailing: Icon(
          Icons.keyboard_arrow_down,
          color: titleColor,
        ),
        collapsedIconColor: titleColor,
        iconColor: titleColor,
        title: Text(
          title,
          style: titleStyle,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: screenHeight * 0.25,
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: contents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final content = contents[index];
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () => onPressed(index),
                      child: Container(
                        height: screenHeight * 0.082,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: primaryColor,
                                child: Center(
                                  child: Text( content.productName.isEmpty?"":
                                    content.productName[0]
                                        .toUpperCase(), // First letter of product name
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        content.productName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ), overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildContentText(
                                            "Price:",
                                            content.price.toString(),
                                            screenWidth),
                                        _buildContentText(
                                            "Qty:",
                                            content.qty.toString(),
                                            screenWidth),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildContentText("UOM:",
                                            content.uomCode, screenWidth),
                                      ],
                                    ),
                                  )
                                ],
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
          )
        ],
      ),
    );
  }

  // Helper method to build content text with consistent style
  Widget _buildContentText(String label, String value, double screenWidth) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(width: screenWidth * 0.08),
      ],
    );
  }
}
