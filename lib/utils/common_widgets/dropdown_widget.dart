import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';



Widget buildAutoCompleteField({
  required String hintText,
  required TextEditingController controller,
  required Future<List<Map<String, dynamic>>> Function(String)
      suggestionsCallback,
  required Function(Map<String, dynamic>) onSuggestionSelected,
  bool mandatory = false,
}) {
  return TypeAheadFormField<Map<String, dynamic>>(
    textFieldConfiguration: TextFieldConfiguration(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 16, color: Colors.white),
        filled: true,
        fillColor: Colors.black,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: mandatory ? Colors.red : Colors.grey,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: mandatory ? Colors.red : Colors.blue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    ),
    suggestionsCallback: suggestionsCallback,
    itemBuilder: (context, Map<String, dynamic> suggestion) {
      return ListTile(
        title: Text(
          suggestion['name'],
          style: const TextStyle(fontSize: 16),
        ),
      );
    },
    onSuggestionSelected: onSuggestionSelected,
    transitionBuilder: (context, suggestionsBox, controller) {
      return suggestionsBox;
    },
    hideOnError: true,
    hideSuggestionsOnKeyboardHide: true,
  );
}







// Widget buildAutoCompleteField({
//   required String hintText,
//   required TextEditingController controller,
//   required Future<List<Map<String, dynamic>>> Function(String)
//       suggestionsCallback,
//   required Function(Map<String, dynamic>) onSuggestionSelected,
//    bool mandatory=false,
// }) {
//   return TypeAheadFormField<Map<String, dynamic>>(
//     textFieldConfiguration: TextFieldConfiguration(
//       style: const TextStyle(color: Colors.white),
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: const TextStyle(fontSize: 16, color: Colors.white),
//         filled: true,
//         fillColor: Colors.black,
//         contentPadding:
//             const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide:BorderSide(
//             color: mandatory?Colors.red: Colors.black,
//             width: 1,
//           ),
//         ),
//       ),
//     ),
//     suggestionsCallback: suggestionsCallback,
//     itemBuilder: (context, Map<String, dynamic> suggestion) {
//       return ListTile(
//         title: Text(
//           suggestion['name'],
//           style: const TextStyle(fontSize: 16),
//         ),
//       );
//     },
//     onSuggestionSelected: onSuggestionSelected,
//     transitionBuilder: (context, suggestionsBox, controller) {
//       return suggestionsBox;
//     },
//     hideOnError: true,
//     hideSuggestionsOnKeyboardHide: true,
//   );
// }
