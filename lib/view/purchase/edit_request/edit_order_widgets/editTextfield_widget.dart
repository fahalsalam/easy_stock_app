
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';


class QtyButtonWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final String initialQuantity;
  final void Function(String value) onSubmit;

  QtyButtonWidget({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.initialQuantity,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _QtyButtonWidgetState createState() => _QtyButtonWidgetState();
}

class _QtyButtonWidgetState extends State<QtyButtonWidget> {
 late  TextEditingController quantityController = TextEditingController(text: widget.initialQuantity);

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  void _handleQuantitySubmit(String value) {
    final enteredQuantity = double.tryParse(value) ?? 0;
    log("enteredQuantity: $enteredQuantity, $value");
    if (enteredQuantity > 0) {
      widget.onSubmit(enteredQuantity.toString());
      log("Quantity submitted: $enteredQuantity");
      // Uncomment if you want to show a snackbar
      showSnackBar(context, "", "Quantity Updated", Colors.white);
    } else {
      showSnackBar(context, "", "Enter a valid quantity", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.screenHeight * 0.032,
      width: widget.screenWidth * 0.32,
      margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TextField to input quantity
            Expanded(
              child: TextField(
                
                controller: quantityController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                  // hintText: widget.initialQuantity.isEmpty
                  //     ? '0'
                  //     : widget.initialQuantity,
                  hintStyle: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _handleQuantitySubmit(quantityController.text), // Pass the value
              child: const Text(
                'ADD',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


