import 'package:easy_stock_app/controllers/providers/masters_provider/customer_master/customer_master_provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/vehicle_management_provider/vehicle_management_provider.dart';
import 'package:easy_stock_app/models/masters/customer_model/customer_model.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/masters/customer/customer_add_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/common_widgets/background_image_widget.dart';
import 'edit_customer_page.dart';

class MastersCustomerPage extends StatefulWidget {
  const MastersCustomerPage({super.key});

  @override
  State<MastersCustomerPage> createState() => _MastersCustomerPageState();
}

class _MastersCustomerPageState extends State<MastersCustomerPage> {
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  List<CustomerData> _filteredCustomers = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<VehicleManagementProvider>(context, listen: false)
          .fetchData();
      Provider.of<CustomerManagementProvider>(context, listen: false)
          .fetchData()
          .then((_) {
        setState(() {
          isLoading = false;
          _filteredCustomers =
              Provider.of<CustomerManagementProvider>(context, listen: false)
                  .data;
        });
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCustomers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCustomers =
            Provider.of<CustomerManagementProvider>(context, listen: false)
                .data;
        _isSearching = false;
      } else {
        _filteredCustomers =
            Provider.of<CustomerManagementProvider>(context, listen: false)
                .data
                .where((customer) =>
                    customer.customerName
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    customer.customerCode
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .toList();
        _isSearching = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final customerManagementProvider =
        Provider.of<CustomerManagementProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),

          // Modern Header with Search
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: Container(
              height: screenHeight * 0.12,
              width: screenWidth * 0.9,
              decoration: BoxDecoration(
                  // color: Colors.black.withOpacity(0.3),
                  // borderRadius: BorderRadius.circular(15),
                  // border: Border.all(
                  //   color: Colors.white.withOpacity(0.1),
                  //   width: 1,
                  // ),
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button and title
                  Container(
                    height: screenHeight * 0.05,
                    width: screenWidth * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 22,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Customers',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search customers...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterCustomers('');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onChanged: _filterCustomers,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading indicator
          if (isLoading)
            SizedBox(
              height: screenHeight * 0.85,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          else
            // Customer list
            Padding(
              padding: EdgeInsets.only(
                top: screenWidth >= 600
                    ? screenHeight * 0.25
                    : screenHeight * 0.2,
                left: 15,
                right: 15,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_filteredCustomers.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            _isSearching
                                ? "No matching customers found"
                                : "No customers to show",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        padding: const EdgeInsets.only(bottom: 70, top: 10),
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _filteredCustomers.length,
                        itemBuilder: (context, index) {
                          CustomerData customer = _filteredCustomers[
                              _filteredCustomers.length - 1 - index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: primaryColor.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Text(
                                    customer.customerName.isEmpty
                                        ? 'C'
                                        : customer.customerName[0]
                                            .toUpperCase(),
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  customer.customerName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  "Code: ${customer.customerCode}",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      size: screenHeight * 0.022,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditCustomerPage(
                                            name: customer.customerName,
                                            id: customer.customerId.toString(),
                                            code: customer.customerCode,
                                            group: customer.group,
                                            city: customer.city,
                                            vehicles: customer.vehicles,
                                          ),
                                        ),
                                      ).then((_) {
                                        setState(() {
                                          Provider.of<
                                              CustomerManagementProvider>(
                                            context,
                                            listen: false,
                                          ).fetchData();
                                        });
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        elevation: 4,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MastersCustomerAddPage(),
            ),
          );
          setState(() {
            customerManagementProvider.setLoading(true);
          });
          await customerManagementProvider.fetchData();
          setState(() {
            _filteredCustomers = customerManagementProvider.data;
          });
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: primaryColor,
      //   elevation: 4,
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.white,
      //     size: 25,
      //   ),
      //   onPressed: () async {
      //     // Navigate and wait for return
      //     final result = await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const MastersCustomerAddPage(),
      //       ),
      //     );
      //     if (result != null) {
      //       // Refresh data after returning
      //       setState(() => isLoading = true);
      //       await Provider.of<CustomerManagementProvider>(context,
      //               listen: false)
      //           .fetchData();
      //       setState(() => isLoading = false);
      //     }
      //   },
      // ),
    );
  }
}
