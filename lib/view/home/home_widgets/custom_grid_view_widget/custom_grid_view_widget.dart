import 'dart:ui';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/utils/constants/loginConstants.dart';
import 'package:easy_stock_app/view/masters/masters_main_page/masters_main_page.dart';
import 'package:easy_stock_app/view/purchase/purchase_mainmenu/purchase_main_menu_page.dart';
import 'package:easy_stock_app/view/purchase_request/purchase_request_mainmenu/purchase_request_mainmenu.dart';
import 'package:easy_stock_app/view/purchase_request/vehicle_details/vehicle_list_page/vehicle_list_page.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class CustomGridView extends StatefulWidget {
  const CustomGridView({
    super.key,
  });

  @override
  State<CustomGridView> createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<CustomGridView> {
  bool isLoading = true;
  String? errorMessage;

  // Helper method to validate boolean string
  bool _isValidBoolean(String value) {
    return value.toLowerCase() == 'true' || value.toLowerCase() == 'false';
  }

  // Helper method to get boolean value
  bool _getBooleanValue(String value) {
    return value.toLowerCase() == 'true';
  }

  @override
  void initState() {
    super.initState();
    fetchMenuValues();
  }

  Future<void> fetchMenuValues() async {
    try {
      // Log menu visibility status
      developer.log('Menu Visibility Status:', name: 'MenuList');
      developer.log('isMasters: $isMaster', name: 'MenuList');
      developer.log('isConsolidatedPurchase: $isOrder', name: 'MenuList');
      developer.log('isPurchaseRequest: $isPurchase', name: 'MenuList');
      developer.log('isDriver: $isDriver', name: 'MenuList');

      // Validate all required values are present and valid
      if (isMaster.isEmpty ||
          isOrder.isEmpty ||
          isPurchase.isEmpty ||
          isDriver.isEmpty) {
        throw Exception('Required menu configuration values are missing');
      }

      // Validate boolean values
      if (!_isValidBoolean(isMaster) ||
          !_isValidBoolean(isOrder) ||
          !_isValidBoolean(isPurchase) ||
          !_isValidBoolean(isDriver)) {
        throw Exception('Invalid boolean values in menu configuration');
      }

      // Get boolean values
      final bool isUserDriver = _getBooleanValue(isDriver);
      final bool isMasters = _getBooleanValue(isMaster);
      final bool isConsolidatedPurchase = _getBooleanValue(isOrder);
      final bool isPurchaseRequest = _getBooleanValue(isPurchase);

      // Determine which menus to show based on the rules
      List<Map<String, dynamic>> items = [];

      // Rule 1: If all are true, show all menus
      if (isMasters && isConsolidatedPurchase && isPurchaseRequest) {
        items = [
          {
            'image': purchase_request_image,
            'page': RequestMainMenu(isDriver: isUserDriver.toString()),
            'title': 'Purchase Request',
            'showItem': true,
          },
          {
            'image': purchase_order_image,
            'page': const PurchaseMainMenuPage(),
            'title': 'Purchase Order',
            'showItem': true,
          },
          {
            'image': masters_image,
            'page': const MastersMainPage(),
            'title': 'Masters',
            'showItem': true,
          },
        ];
      }
      // Rule 2: If only Consolidated Purchase is true, show Purchase Request
      else if (isConsolidatedPurchase && !isMasters && !isPurchaseRequest) {
        items = [
          {
            'image': purchase_request_image,
            'page': RequestMainMenu(isDriver: isUserDriver.toString()),
            'title': 'Purchase Request',
            'showItem': true,
          },
        ];
      }
      // Rule 3: If driver is true, show Vehicle Details
      else if (isUserDriver) {
        items = [
          {
            'image': vehicle_details_img,
            'page': const VehicleListPage(),
            'title': 'Vehicle Details',
            'showItem': true,
          },
        ];
      }
      // Default case: Show menus based on individual flags
      else {
        items = [
          if (isConsolidatedPurchase)
            {
              'image': purchase_request_image,
              'page': RequestMainMenu(isDriver: isUserDriver.toString()),
              'title': 'Purchase Request',
              'showItem': true,
            },
          if (isPurchaseRequest)
            {
              'image': purchase_order_image,
              'page': const PurchaseMainMenuPage(),
              'title': 'Purchase Order',
              'showItem': true,
            },
          if (isMasters)
            {
              'image': masters_image,
              'page': const MastersMainPage(),
              'title': 'Masters',
              'showItem': true,
            },
        ];
      }

      // Log menu items configuration
      developer.log('Menu Items Configuration:', name: 'MenuList');
      for (var item in items) {
        developer.log('Item: ${item['title']}', name: 'MenuList');
        developer.log('  - Page: ${item['page'].runtimeType}',
            name: 'MenuList');
        developer.log('  - Visible: ${item['showItem']}', name: 'MenuList');
      }

      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = null;
        });
      }
    } catch (e) {
      developer.log('Error in fetchMenuValues: $e', name: 'MenuList', error: e);
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load menu: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchMenuValues,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Get boolean values
    final bool isUserDriver = _getBooleanValue(isDriver);
    final bool isMasters = _getBooleanValue(isMaster);
    final bool isConsolidatedPurchase = _getBooleanValue(isOrder);
    final bool isPurchaseRequest = _getBooleanValue(isPurchase);

    // Determine which menus to show based on the rules
    List<Map<String, dynamic>> items = [];

    // Rule 1: If all are true, show all menus
    if (isMasters && isConsolidatedPurchase && isPurchaseRequest) {
      items = [
        {
          'image': purchase_request_image,
          'page': RequestMainMenu(isDriver: isUserDriver.toString()),
          'title': 'Purchase Request',
          'showItem': true,
        },
        {
          'image': purchase_order_image,
          'page': const PurchaseMainMenuPage(),
          'title': 'Purchase Order',
          'showItem': true,
        },
        {
          'image': masters_image,
          'page': const MastersMainPage(),
          'title': 'Masters',
          'showItem': true,
        },
      ];
    }
    // Rule 2: If only Consolidated Purchase is true, show Purchase Request
    else if (isConsolidatedPurchase && !isMasters && !isPurchaseRequest) {
      items = [
        {
          'image': purchase_request_image,
          'page': RequestMainMenu(isDriver: isUserDriver.toString()),
          'title': 'Purchase Request',
          'showItem': true,
        },
      ];
    }
    // Rule 3: If driver is true, show Vehicle Details
    else if (isUserDriver) {
      items = [
        {
          'image': vehicle_details_img,
          'page': const VehicleListPage(),
          'title': 'Vehicle Details',
          'showItem': true,
        },
      ];
    }
    // Default case: Show menus based on individual flags
    else {
      items = [
        if (isConsolidatedPurchase)
          {
            'image': purchase_request_image,
            'page': RequestMainMenu(isDriver: isUserDriver.toString()),
            'title': 'Purchase Request',
            'showItem': true,
          },
        if (isPurchaseRequest)
          {
            'image': purchase_order_image,
            'page': const PurchaseMainMenuPage(),
            'title': 'Purchase Order',
            'showItem': true,
          },
        if (isMasters)
          {
            'image': masters_image,
            'page': const MastersMainPage(),
            'title': 'Masters',
            'showItem': true,
          },
      ];
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 6.6 / 7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => items[index]['page']),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Material(
                  color: Colors.transparent,
                  elevation: 3,
                  borderRadius: BorderRadius.circular(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            items[index]['image'],
                            height: 80,
                            width: 80,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        items[index]['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
