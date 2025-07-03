import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String txt;
  final List<Widget>? actions;
  const CustomAppBar({super.key, required this.txt, this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 22,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              txt,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
