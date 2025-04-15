import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final double width;

  const FilterButton({
    super.key,
    required this.label,
    this.isSelected = false,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orangeAccent : Colors.black12,
        border: Border.all(color: Colors.white, width: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: isSelected
                  ? Colors.black
                  : const Color.fromARGB(255, 196, 141, 14),
            ),
          ),
        ),
      ),
    );
  }
}
