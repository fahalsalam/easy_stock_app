import 'package:easy_stock_app/controllers/providers/purchase_providers/po_provider/po_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/providers/masters_provider/customer_master/customer_master_provider.dart';
import 'controllers/providers/drop_down_providers/dropdown_provider.dart';
import 'controllers/providers/home_provider/home_provider.dart';
import 'controllers/providers/image_provider/image_provider.dart';
import 'controllers/providers/masters_provider/category_master/add_category_provider.dart';
import 'controllers/providers/masters_provider/category_master/category_list_provider.dart';
import 'controllers/providers/masters_provider/category_master/edit_category_provider.dart';
import 'controllers/providers/masters_provider/general_settings_provider/general_Setting_provider.dart';
import 'controllers/providers/masters_provider/item_master_provider/item_master_add_item_provider/item_master_add_item_provider.dart';
import 'controllers/providers/masters_provider/item_master_provider/item_master_edit_item_provider/item_master_edit_item_provider.dart';
import 'controllers/providers/masters_provider/item_master_provider/item_master_provider.dart';
import 'controllers/providers/masters_provider/uom_master/uom_master_provider.dart';
import 'controllers/providers/masters_provider/user_configure_provider/userEdit_provider.dart';
import 'controllers/providers/masters_provider/user_configure_provider/user_configure_provider.dart';
import 'controllers/providers/masters_provider/vehicle_management_provider/vehicle_management_provider.dart';
import 'controllers/providers/masters_provider/vehicle_management_provider/vehicledetails_edit_provider.dart';
import 'controllers/providers/masters_provider/vehicle_management_provider/vehicleimagepicker.dart';
import 'controllers/providers/purchase_providers/history/historyProvider.dart';
import 'controllers/providers/purchase_providers/item_list_provider/itemlist_provider.dart';
import 'controllers/providers/purchase_providers/lpoList_providers/lpoList_provider.dart';
import 'controllers/providers/purchase_request/NoStock/nostock_provider.dart';
import 'controllers/providers/purchase_request/bpo/bpoProvider.dart';
import 'controllers/providers/purchase_request/completed/completed_provider.dart';
import 'controllers/providers/purchase_request/pending/pending_provider.dart';
import 'controllers/providers/purchase_request/vehicle/vehicleProvider.dart';
import 'controllers/providers/signIn_provider/signin_provider.dart';
import 'controllers/providers/splash_screen_provider/splash_screen_provider.dart';
import 'utils/constants/colors/colors.dart';
import 'view/splash_screens/splash_screens/splash_screen.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrintGestureArenaDiagnostics = false;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DropdownProvider()),
        ChangeNotifierProvider(create: (context) => SplashProvider(context)),
        ChangeNotifierProvider(create: (context) => SignInProvider()),
        ChangeNotifierProvider(create: (context) => HomepageProvider()),
        ChangeNotifierProvider(create: (context) => ProductMasterProvider()),
        ChangeNotifierProvider(create: (context) => EditItemProvider()),
        ChangeNotifierProvider(create: (context) => UserConfigureProvider()),
        ChangeNotifierProvider(
            create: (context) => VehicleManagementProvider()),
        ChangeNotifierProvider(create: (context) => PurchaseItemListProvider()),
        ChangeNotifierProvider(create: (context) => DropdownProvider()),
        ChangeNotifierProvider(create: (context) => AddCategoryProvider()),
        ChangeNotifierProvider(create: (context) => CategoryListProvider()),
        ChangeNotifierProvider(create: (context) => EditCategoryProvider()),
        ChangeNotifierProvider(create: (context) => ItemMasterProvider()),
        ChangeNotifierProvider(create: (context) => UomMasterProvider()),
        ChangeNotifierProvider(create: (context) => ImagePickerProvider()),
        ChangeNotifierProvider(
            create: (context) => EditVehicleDetailsProvider()),
        ChangeNotifierProvider(create: (context) => LpolistProvider()),
        ChangeNotifierProvider(create: (context) => PoProvider()),
        ChangeNotifierProvider( 
            create: (context) => CustomerManagementProvider()),
        ChangeNotifierProvider(create: (context) => UserEditProvider()),
        ChangeNotifierProvider(create: (context) => BpoProvider()),
        ChangeNotifierProvider(create: (context) => BpoVehicleProvider()),
        ChangeNotifierProvider(create: (context) => PendingProvider()),
        ChangeNotifierProvider(create: (context) => CompletedProvider()),
        ChangeNotifierProvider(create: (context) => NostockProvider()),
        ChangeNotifierProvider(create: (context) => PurchaseHistoryProvider()),
        ChangeNotifierProvider(create: (context) => Vehicleimagepicker()),
        ChangeNotifierProvider(create: (context) => GeneralSettingProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primaryColor,
        ),
        navigatorObservers: [routeObserver],
        home: const SplashScreen(),
        builder: (context, widget) {
          return widget!;
        },
      ),
    );
  }
}
