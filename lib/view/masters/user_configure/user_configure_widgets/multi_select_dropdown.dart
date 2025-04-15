import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';

class MultiSelectCategoryDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> categories; // Full list of categories
  final List<Map<String, dynamic>> selectedCategories; // Pre-selected categories
  final Function(List<String>) onSelectionChanged; // Callback to notify selected IDs

  MultiSelectCategoryDropdown({
    Key? key,
    required this.categories,
    required this.onSelectionChanged,
    this.selectedCategories = const [],
  }) : super(key: key);

  @override
  _MultiSelectCategoryDropdownState createState() =>
      _MultiSelectCategoryDropdownState();
}

class _MultiSelectCategoryDropdownState
    extends State<MultiSelectCategoryDropdown> {
  late List<Map<String, dynamic>> _selectedCategories;

  @override
  void initState() {
    super.initState();

    // Initialize _selectedCategories by matching IDs
    _selectedCategories = widget.categories
        .where((category) => widget.selectedCategories.any(
            (selected) => selected['id'] == category['id']))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField<Map<String, dynamic>>(
      items: widget.categories
          .map((category) => MultiSelectItem(category, category['name']))
          .toList(),
      initialValue: _selectedCategories,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: const Text(
          "Select Categories",
          style: TextStyle(fontSize: 15),
        ),
      ),
      selectedColor: Colors.black,
      buttonText: Text(
        _selectedCategories.isEmpty
            ? "Select Categories"
            : _selectedCategories.map((e) => e['name']).join(", "),
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      onConfirm: (values) {
        setState(() {
          _selectedCategories = values;
        });

        // Extract IDs from selected categories and pass them back
        List<String> selectedCategoryIds = _selectedCategories
            .map((category) => category['id'].toString())
            .toList();
        widget.onSelectionChanged(selectedCategoryIds);
      },
      chipDisplay: MultiSelectChipDisplay(
        items: _selectedCategories
            .map((category) => MultiSelectItem(category, category['name']))
            .toList(),
        chipColor: Colors.grey.shade400,
        textStyle: const TextStyle(color: Colors.black),
        onTap: (value) {
          yesnoAlertDialog(
            context: context,
            message: 'Do you want to remove this category?',
            screenHeight: MediaQuery.of(context).size.height,
            screenWidth: MediaQuery.of(context).size.width,
            onYes: () {
              setState(() {
                _selectedCategories.remove(value);
              });

              // Update IDs after removal and pass them back
              List<String> selectedCategoryIds = _selectedCategories
                  .map((category) => category['id'].toString())
                  .toList();
              widget.onSelectionChanged(selectedCategoryIds);
              Navigator.pop(context);
            },
            onNo: () {
              Navigator.pop(context);
            },
            buttonYesText: 'Yes',
            buttonNoText: 'No',
          );
        },
      ),
    );
  }
}









// import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
// import 'package:flutter/material.dart';
// import 'package:multi_select_flutter/multi_select_flutter.dart';

// class MultiSelectCategoryDropdown extends StatefulWidget {
//   final List<Map<String, dynamic>> categories; // List of categories
//   final Function(List<String>) onSelectionChanged; // Callback with selected category IDs
// List<Map<String, dynamic>> selectedCategories; // List to hold selected categories
//   MultiSelectCategoryDropdown({
//     Key? key,
//     required this.categories,
//     required this.onSelectionChanged,
//     this.selectedCategories=[]
//   }) : super(key: key);

//   @override
//   _MultiSelectCategoryDropdownState createState() =>
//       _MultiSelectCategoryDropdownState();
// }

// class _MultiSelectCategoryDropdownState extends State<MultiSelectCategoryDropdown> {
  

//   @override
//   Widget build(BuildContext context) {
//     return MultiSelectDialogField<Map<String, dynamic>>(
//       items: widget.categories
//           .map((category) => MultiSelectItem(category, category['name']))
//           .toList(),
//       title: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: const Text(
//           "Select Categories",
//           style: TextStyle(
//             fontSize: 15,
//           ),
//         ),
//       ),
//       selectedColor: Colors.black,
//       buttonText: Text(
//         selectedCategories.isEmpty
//             ? "Select Categories"
//             : selectedCategories.map((e) => e['name']).join(", "),
//         style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),
//       ),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         border: Border.all(color: Colors.grey,width: 1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       onConfirm: (values) {
//         setState(() {
//           selectedCategories = values;
//         });
        
//         // Extract IDs from selected categories and pass them back
//         List<String> selectedCategoryIds =
//             selectedCategories.map((category) => category['id'] as String).toList();
        
//         widget.onSelectionChanged(selectedCategoryIds);
//       },
//       chipDisplay: MultiSelectChipDisplay(
//         items: selectedCategories
//             .map((category) => MultiSelectItem(category, category['name']))
//             .toList(),
//         chipColor: Colors.grey.shade400,
//         textStyle: const TextStyle(color: Colors.black),
//         onTap: (value) {
//           yesnoAlertDialog(
//             context: context,
//             message: 'Do you want to Remove Category?',
//             screenHeight: MediaQuery.of(context).size.height,
//             screenWidth: MediaQuery.of(context).size.width,
//             onYes: () {
//               setState(() {
//                 selectedCategories.remove(value);
//               });
              
//               // Update IDs after removal and pass them back
//               List<String> selectedCategoryIds =
//                   selectedCategories.map((category) => category['id'] as String).toList();
              
//               widget.onSelectionChanged(selectedCategoryIds);
//               Navigator.pop(context);
//             },
//             onNo: () {
//               Navigator.pop(context);
//             },
//             buttonYesText: 'Yes',
//             buttonNoText: 'No',
//           );
//         },
//       ),
//     );
//   }
// }
