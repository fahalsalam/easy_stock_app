import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/providers/masters_provider/user_configure_provider/user_configure_provider.dart';

class CheckboxWidget extends StatelessWidget {
  String txt;
  bool isChecked;
  ValueChanged<bool?> onChanged;
  CheckboxWidget(
      {super.key,
      required this.txt,
      required this.isChecked,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserConfigureProvider>(
      builder: (context, checkboxProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              activeColor: primaryColor,
              checkColor: Colors.black,
              value: isChecked,
              side: const BorderSide(
                color: primaryColor,
              ),
              onChanged: onChanged,
            ),
            Text(
              txt,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );
      },
    );
  }
}
