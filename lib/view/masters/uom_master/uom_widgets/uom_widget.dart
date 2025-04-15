import 'package:easy_stock_app/controllers/providers/masters_provider/uom_master/uom_master_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/constants/colors/colors.dart';

void UOMshowBottomSheet(BuildContext context, String txt,
    {String UomID = "0",
    String unitName = "",
    String unitDesc = "",
    VoidCallback? onRefresh}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return ChangeNotifierProvider(
        create: (_) => UomMasterProvider(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Using Row instead of Stack to properly align title and close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      txt,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Close the popup
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Consumer<UomMasterProvider>(
                    builder: (context, provider, child) {
                  provider.uomProductnameController.text = unitName;
                  provider.uomEditProductnameController.text = unitName;
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: primaryColor,
                      controller: txt.toUpperCase() == 'ADD'
                          ? provider.uomProductnameController
                          : provider.uomEditProductnameController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Unit Name',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 15),
                Consumer<UomMasterProvider>(
                    builder: (context, provider, child) {
                  provider.uomProductDescriptionController.text = unitDesc;
                  provider.uomEditProductDescriptionController.text = unitDesc;
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      controller: txt.toUpperCase() == 'ADD'
                          ? provider.uomProductDescriptionController
                          : provider.uomEditProductDescriptionController,
                      cursorColor: primaryColor,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Unit Description',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 15),
                Consumer<UomMasterProvider>(
                    builder: (context, provider, child) {
                  return ElevatedButton(
                    onPressed: () {
                      txt.toUpperCase() == 'ADD'
                          ? provider.addFunction(context)
                          : provider.editFunction(
                              UomID, context, );

                      onRefresh?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      fixedSize: const Size(150, 30), // Width and height
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Border radius
                      ),
                    ),
                    child: provider.isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            txt,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                }),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    },
  );
}
