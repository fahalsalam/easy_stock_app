import 'dart:developer';
import 'package:easy_stock_app/controllers/providers/masters_provider/customer_master/customer_master_provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/user_configure_provider/user_configure_provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/vehicle_management_provider/vehicle_management_provider.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/gradient_button.dart';
import 'package:easy_stock_app/view/masters/user_configure/user_configure_widgets/checkbox_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/constants/colors/colors.dart';

class AddUserWidget extends StatefulWidget {
  const AddUserWidget({super.key});

  @override
  State<AddUserWidget> createState() => _AddUserWidgetState();
}

class _AddUserWidgetState extends State<AddUserWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CustomerManagementProvider>(context, listen: false)
          .fetchData();
      Provider.of<UserConfigureProvider>(context, listen: false)
          .fetchCategory();
      Provider.of<VehicleManagementProvider>(context, listen: false)
          .fetchData();
      Provider.of<UserConfigureProvider>(context, listen: false).removeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final userConfigureProvider = Provider.of<UserConfigureProvider>(context);
    final vehicleManagementProvider =
        Provider.of<VehicleManagementProvider>(context);
    final customerManagementProvider =
        Provider.of<CustomerManagementProvider>(context);
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: screenWidth * 0.95,
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person_add_alt_1, color: primaryColor, size: 28),
                  const SizedBox(width: 10),
                  const Text(
                    "Add User",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Section: User Details
              const Text(
                "User Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              _modernTextField(
                label: "User Code",
                controller: userConfigureProvider.userCodeController,
                icon: Icons.badge_outlined,
                isPassword: false,
                mandatory: true,
              ),
              const SizedBox(height: 14),
              _modernTextField(
                label: "Name",
                controller: userConfigureProvider.userNameController,
                icon: Icons.person_outline,
                isPassword: false,
                mandatory: true,
              ),
              const SizedBox(height: 14),
              _modernTextField(
                label: "Password",
                controller: userConfigureProvider.userPasswordController,
                icon: Icons.lock_outline,
                isPassword: true,
                mandatory: true,
                isObscure: userConfigureProvider.isshowPassword,
                onToggleVisibility:
                    userConfigureProvider.togglePasswordVisibility,
              ),
              const SizedBox(height: 22),
              // Section: Customer
              const Text(
                "Customer",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      TextEditingController searchController =
                          TextEditingController();
                      List customers = customerManagementProvider.customers;
                      return StatefulBuilder(
                        builder: (context, setModalState) {
                          List filteredCustomers = customers
                              .where((c) => c['name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      searchController.text.toLowerCase()))
                              .toList();
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 45,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextField(
                                    controller: searchController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Search customer...',
                                      hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.5)),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.search,
                                          color: Colors.white.withOpacity(0.5)),
                                    ),
                                    onChanged: (_) => setModalState(() {}),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: filteredCustomers.length,
                                    itemBuilder: (context, index) {
                                      final customer = filteredCustomers[index];
                                      return ListTile(
                                        title: Text(
                                          customer['name'],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        onTap: () {
                                          userConfigureProvider.addCustomer(
                                              customer['id'], customer['name']);
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userConfigureProvider.customerName.isEmpty
                            ? 'Select Customer'
                            : userConfigureProvider.customerName,
                        style: TextStyle(
                          color: userConfigureProvider.customerName.isEmpty
                              ? Colors.white54
                              : Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.white54),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              // Section: Categories
              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      TextEditingController searchController =
                          TextEditingController();
                      List categories = userConfigureProvider.categoryList;
                      List selectedIds = List<String>.from(
                          userConfigureProvider.selectedcategoryIds);
                      return StatefulBuilder(
                        builder: (context, setModalState) {
                          List filteredCategories = categories
                              .where((c) => c['name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      searchController.text.toLowerCase()))
                              .toList();
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 45,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextField(
                                    controller: searchController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Search categories...',
                                      hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.5)),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.search,
                                          color: Colors.white.withOpacity(0.5)),
                                    ),
                                    onChanged: (_) => setModalState(() {}),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: filteredCategories.length,
                                    itemBuilder: (context, index) {
                                      final category =
                                          filteredCategories[index];
                                      final isSelected = selectedIds
                                          .contains(category['id'].toString());
                                      return CheckboxListTile(
                                        value: isSelected,
                                        onChanged: (val) {
                                          setModalState(() {
                                            if (val == true) {
                                              selectedIds.add(
                                                  category['id'].toString());
                                            } else {
                                              selectedIds.remove(
                                                  category['id'].toString());
                                            }
                                          });
                                        },
                                        title: Text(
                                          category['name'],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        activeColor: primaryColor,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    userConfigureProvider.selectedCategories(
                                        selectedIds
                                            .map((e) => e.toString())
                                            .toList());
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Done",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          userConfigureProvider.selectedcategoryIds.isEmpty
                              ? 'Select Categories'
                              : userConfigureProvider.categoryList
                                  .where((cat) => userConfigureProvider
                                      .selectedcategoryIds
                                      .contains(cat['id'].toString()))
                                  .map((cat) => cat['name'])
                                  .join(', '),
                          style: TextStyle(
                            color: userConfigureProvider
                                    .selectedcategoryIds.isEmpty
                                ? Colors.white54
                                : Colors.white,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.white54),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: userConfigureProvider.isDriver,
                child: const SizedBox(height: 22),
              ),
              // Section: Categories
              Visibility(
                visible: userConfigureProvider.isDriver,
                child: const Text(
                  "Vehicles",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Visibility(
                visible: userConfigureProvider.isDriver,
                child: const SizedBox(height: 10),
              ),
              Visibility(
                visible: userConfigureProvider.isDriver,
                child: GestureDetector(
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        TextEditingController searchController =
                            TextEditingController();
                        List vehicles = vehicleManagementProvider.vehicles;
                        String selectedIds =
                            userConfigureProvider.selectedVehicleIds;

                        return StatefulBuilder(
                          builder: (context, setModalState) {
                            List filteredVehicles = vehicles
                                .where((c) => c['name']
                                    .toString()
                                    .toLowerCase()
                                    .contains(
                                        searchController.text.toLowerCase()))
                                .toList();

                            return Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Select Vehicles",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    height: 45,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextField(
                                      controller: searchController,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: 'Search vehicles...',
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.search,
                                            color:
                                                Colors.white.withOpacity(0.5)),
                                      ),
                                      onChanged: (_) => setModalState(() {}),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: filteredVehicles.length,
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      itemBuilder: (context, index) {
                                        final vehicle = filteredVehicles[index];
                                        final isSelected =
                                            selectedIds.contains(vehicle['id']);

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: GestureDetector(
                                            onTap: () {
                                              setModalState(() {
                                                if (isSelected) {
                                                  selectedIds = '';
                                                  // .remove(vehicle['id']);
                                                } else {
                                                  selectedIds = vehicle['id'];
                                                  // .add(vehicle['id']);
                                                }
                                              });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? primaryColor
                                                    : Colors.white
                                                        .withOpacity(0.08),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      vehicle['name'],
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: isSelected
                                                            ? Colors.black
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  if (isSelected)
                                                    const Icon(
                                                      Icons.check_circle,
                                                      color: Colors.black,
                                                      size: 24,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        userConfigureProvider
                                            .selectedVehicles(selectedIds);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Done",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            vehicleManagementProvider.vehicles.isEmpty
                                ? 'Select Vehicles'
                                : vehicleManagementProvider.vehicles
                                    .where((vehicle) => userConfigureProvider
                                        .selectedVehicleIds
                                        .contains(vehicle['id']))
                                    .map((vehicle) => vehicle['name'])
                                    .join(', '),
                            style: TextStyle(
                              color: vehicleManagementProvider.vehicles.isEmpty
                                  ? Colors.white54
                                  : Colors.white,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded,
                            color: Colors.white54),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              // Section: Menu Selection
              const Text(
                "Menu Selection",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              _modernMenuSelection(userConfigureProvider),
              const SizedBox(height: 28),
              // Save Button (restored to bottom of card)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  gradientElevatedButton(
                    child: Center(
                      child: userConfigureProvider.isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                    ),
                    onPressed: () {
                      if (userConfigureProvider
                          .userCodeController.text.isEmpty) {
                        showSnackBarWithsub(
                          context,
                          "Please Enter User Code",
                          "Error",
                          Colors.red,
                        );
                        return;
                      }
                      if (userConfigureProvider
                          .userNameController.text.isEmpty) {
                        showSnackBarWithsub(
                          context,
                          "Please Enter User Name",
                          "Error",
                          Colors.red,
                        );
                        return;
                      }
                      if (userConfigureProvider.selectedcategoryIds.isEmpty) {
                        showSnackBarWithsub(
                          context,
                          "Please select category",
                          "Error",
                          Colors.red,
                        );
                        return;
                      }
                      yesnoAlertDialog(
                        context: context,
                        message: "Do you want to save?",
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        onNo: () {
                          Navigator.pop(context);
                        },
                        onYes: () async {
                          await userConfigureProvider.userSave(context);

                          await Provider.of<UserConfigureProvider>(context,
                                  listen: false)
                              .fetchData();

                          Navigator.pop(context); // Close alert dialog
                          Navigator.pop(context); // Close add user page
                        },
                        buttonNoText: "No",
                        buttonYesText: "Yes",
                      );
                    },
                    width: screenWidth * 0.23,
                    height: screenHeight * 0.05,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modernTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    bool mandatory = false,
    bool isObscure = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            if (mandatory)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? isObscure : false,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.08),
            prefixIcon: Icon(icon, color: Colors.white54),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white54,
                      size: 20,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white24, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _modernMenuSelection(UserConfigureProvider provider) {
    return Column(
      children: [
        CheckboxWidget(
          onChanged: (bool? value) {
            provider.togglePurchase();
          },
          isChecked: provider.isPurchase,
          txt: "Consolidated Purchase",
        ),
        CheckboxWidget(
          onChanged: (bool? value) {
            provider.toggleMasters();
          },
          isChecked: provider.isMasters,
          txt: "Masters",
        ),
        CheckboxWidget(
          onChanged: (bool? value) {
            provider.toggleRequest();
            if (provider.isDriver == true && provider.isPurchase == false) {
              provider.toggleDriver();
            }
          },
          isChecked: provider.isRequest,
          txt: "Purchase Request",
        ),
        CheckboxWidget(
          onChanged: (bool? value) {
            provider.toggleDriver();
            if (provider.isRequest == false && provider.isDriver == true) {
              provider.toggleRequest();
            }
          },
          isChecked: provider.isDriver,
          txt: "Driver",
        ),
      ],
    );
  }
}
