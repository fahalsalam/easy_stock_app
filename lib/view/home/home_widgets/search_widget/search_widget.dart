import 'package:easy_stock_app/controllers/providers/home_provider/home_provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/item_master_provider/item_master_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    final itemmasterProvider = Provider.of<ItemMasterProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Consumer<HomepageProvider>(
      builder: (context, provider, child) {
        return Container(
          height: screenHeight * 0.05,
          width: screenWidth * 0.88,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 95, 92, 49).withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 0.3, color: Colors.white)),
          child: Center(
            child: TextFormField(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              controller: provider.searchController,
              decoration: InputDecoration(
               suffixIcon: IconButton(onPressed: (){
                  
               },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 25,
                )),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                hintText: 'Search item name  or item code',
                border: InputBorder.none,
                hintStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 211, 209, 154),
                ),
              ),
              onChanged: (value) {
                itemmasterProvider.updateSearchQuery(value);

              },

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter text';
                }
                // Additional validation can be added here
                return null;
              },
            ),
          ),
        );
      },
    );
  }
}
