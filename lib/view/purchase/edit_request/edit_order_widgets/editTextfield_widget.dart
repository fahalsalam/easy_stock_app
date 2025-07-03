import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';

class QtyButtonWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final String initialQuantity;
  final Function(String) onSubmit;

  const QtyButtonWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.initialQuantity,
    required this.onSubmit,
  });

  @override
  State<QtyButtonWidget> createState() => _QtyButtonWidgetState();
}

class _QtyButtonWidgetState extends State<QtyButtonWidget> {
  late TextEditingController _controller;
  double currentQty = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuantity);
    currentQty = double.tryParse(widget.initialQuantity) ?? 0;
  }

  void _updateQuantity(double newQty) {
    if (newQty >= 0) {
      setState(() {
        currentQty = newQty;
        _controller.text = newQty.toStringAsFixed(2);
      });
      widget.onSubmit(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.screenHeight * 0.04,
      width: widget.screenWidth * 0.25,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Minus button
          SizedBox(
            width: widget.screenWidth * 0.06,
            child: IconButton(
              onPressed: currentQty <= 0
                  ? null
                  : () {
                      _updateQuantity(currentQty - 1);
                    },
              icon: Icon(
                Icons.remove,
                size: 16,
                color: currentQty <= 0 ? Colors.grey : Colors.white,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
          // Text field
          Container(
            width: widget.screenWidth * 0.13,
            alignment: Alignment.center,
            child: TextFormField(
              controller: _controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                double? newQty = double.tryParse(value);
                if (newQty != null && newQty >= 0) {
                  setState(() {
                    currentQty = newQty;
                  });
                  widget.onSubmit(value);
                }
              },
            ),
          ),
          // Plus button
          SizedBox(
            width: widget.screenWidth * 0.06,
            child: IconButton(
              onPressed: () {
                _updateQuantity(currentQty + 1);
              },
              icon: const Icon(
                Icons.add,
                size: 16,
                color: Colors.white,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
