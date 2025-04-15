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
        });
      });
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
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: Builder(
              builder: (BuildContext context) {
                return Container(
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 22,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(
                              context); // This context should now work
                          print("pop");
                        },
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        'Customers',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          isLoading
              ? SizedBox(
                  height: screenHeight * 0.85,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(
                      top: screenWidth >= 600
                          ? screenHeight * 0.15
                          : screenHeight * 0.1,
                      left: 15,
                      right: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customerManagementProvider.data.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Text(
                                    "No customers to show",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.only(bottom: 70, top: 50),
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    customerManagementProvider.data.length,
                                itemBuilder: (context, index) {
                                  CustomerData customer =
                                      customerManagementProvider.data[
                                          customerManagementProvider
                                                  .data.length -
                                              1 -
                                              index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: primaryColor,
                                          child: Text(
                                            customer.customerName.isEmpty
                                                ? 'C'
                                                : customer.customerName[0]
                                                    .toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
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
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                        trailing: IconButton(
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
                                                          name: customer
                                                              .customerName,
                                                          id: customer
                                                              .customerId
                                                              .toString(),
                                                          code: customer
                                                              .customerCode,
                                                          group: customer
                                                              .group,
                                                          city: customer
                                                              .city,
                                                          vehicles: customer.vehicles,
                                                        ))).then((_) {
                                              setState(() {
                                                Provider.of<CustomerManagementProvider>(
                                                        context,
                                                        listen: false)
                                                    .fetchData();
                                              });
                                            });
                                          },
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
        backgroundColor: primaryColor.withOpacity(0.5),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MastersCustomerAddPage()),
          ).then((_) {
            setState(() {
              Provider.of<CustomerManagementProvider>(context, listen: false)
                  .fetchData();
            });
          });
        },
      ),
    );
  }
}
