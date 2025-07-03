import 'package:easy_stock_app/controllers/providers/masters_provider/vehicle_management_provider/vehicle_management_provider.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/customer_master/customer_master_provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/user_configure_provider/userEdit_provider.dart';
import 'package:easy_stock_app/models/masters/user_master/user_model.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/gradient_button.dart';
import 'package:easy_stock_app/view/masters/user_configure/user_configure_widgets/checkbox_widget.dart';

class EditUserWidget extends StatefulWidget {
  final User data;
  final List<UserCategory> category;

  EditUserWidget({super.key, required this.data, required this.category});

  @override
  State<EditUserWidget> createState() => _EditUserWidgetState();
}

class _EditUserWidgetState extends State<EditUserWidget> {
  late List<Map<String, String>> mappedCategories;
  bool isCategoryVisible = false;

  void _showUpdatePasswordDialog(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final editUserProvider =
        Provider.of<UserEditProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: const Text(
                "Update Password",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              content: TextField(
                controller: passwordController,
                obscureText: !editUserProvider.isShowPassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter new password",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      editUserProvider.isShowPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      setState(() {
                        editUserProvider.togglePasswordVisibility();
                      });
                    },
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                gradientElevatedButton(
                  child: Center(
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    String newPassword = passwordController.text;
                    if (newPassword.isNotEmpty) {
                      await editUserProvider.updatePassword(newPassword);
                      if (context.mounted) {
                        Navigator.pop(context);
                        showSnackBarWithsub(
                          context,
                          "Password updated successfully!",
                          "Success",
                          Colors.green,
                        );
                      }
                    } else {
                      if (context.mounted) {
                        showSnackBarWithsub(
                          context,
                          "Please enter a password",
                          "Error",
                          Colors.red,
                        );
                      }
                    }
                  },
                  width: MediaQuery.of(context).size.width * 0.23,
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CustomerManagementProvider>(context, listen: false)
          .fetchData();
      Provider.of<VehicleManagementProvider>(context, listen: false)
          .fetchData();
      final editUserProvider =
          Provider.of<UserEditProvider>(context, listen: false);
      editUserProvider.initializeData(widget.data, widget.category);
      editUserProvider.fetchCategory();

      // Initialize mappedCategories once
      mappedCategories = editUserProvider.initializeCategory(
        widget.category,
        widget.data.userId.toString(),
      );
    });
  }

  Color getCategoryColor(String id) {
    return mappedCategories.any((category) => category['id'] == id)
        ? primaryColor
        : Colors.grey.shade400;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final editUserProvider = Provider.of<UserEditProvider>(context);
    final customerProvider = Provider.of<CustomerManagementProvider>(context);
    final userConfigureProvider = Provider.of<UserEditProvider>(context);
    final vehicleManagementProvider =
        Provider.of<VehicleManagementProvider>(context);
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
              // Title
              const Row(
                children: [
                  Icon(Icons.edit, color: primaryColor, size: 28),
                  const SizedBox(width: 10),
                  const Text(
                    "Edit User",
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
                controller: editUserProvider.editUserCodeController,
                icon: Icons.badge_outlined,
                isPassword: false,
              ),
              const SizedBox(height: 14),
              _modernTextField(
                label: "Name",
                controller: editUserProvider.editUserNameController,
                icon: Icons.person_outline,
                isPassword: false,
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () {
                  _showUpdatePasswordDialog(context);
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Update Password",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.lock_outline, color: Colors.white54),
                    ],
                  ),
                ),
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
              // Customer Selection Section
              Visibility(
                visible: !userConfigureProvider.isDriver,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Default Customer",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            TextEditingController searchController =
                                TextEditingController();
                            List customers = customerProvider.customers;
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                List filteredCustomers = customers
                                    .where((c) => c['name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(searchController.text
                                            .toLowerCase()))
                                    .toList();
                                return Container(
                                  height: screenHeight * 0.7,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.9),
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: searchController,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: "Search customers...",
                                          hintStyle: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.5)),
                                          prefixIcon: const Icon(Icons.search,
                                              color: Colors.white54),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.white24),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.white24),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide:
                                                BorderSide(color: primaryColor),
                                          ),
                                        ),
                                        onChanged: (_) => setModalState(() {}),
                                      ),
                                      const SizedBox(height: 16),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: filteredCustomers.length,
                                          itemBuilder: (context, index) {
                                            final customer =
                                                filteredCustomers[index];
                                            return ListTile(
                                              title: Text(
                                                customer['name'],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onTap: () {
                                                customerProvider
                                                    .customer_controller
                                                    .text = customer['name'];
                                                editUserProvider.customerID =
                                                    customer['id'];
                                                editUserProvider.customerName =
                                                    customer['name'];
                                                Navigator.pop(context);
                                                setState(() {});
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
                                editUserProvider.customerName.isEmpty
                                    ? 'Select Customer'
                                    : editUserProvider.customerName,
                                style: TextStyle(
                                  color: editUserProvider.customerName.isEmpty
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
                  ],
                ),
              ),
              const SizedBox(height: 22),
              // Vehicle Selection Section
              Visibility(
                visible: userConfigureProvider.isDriver,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vehicle",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
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
                            String selectedId =
                                editUserProvider.selectedVehicleId ?? '';
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                List filteredVehicles = vehicles
                                    .where((v) => v['name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(searchController.text
                                            .toLowerCase()))
                                    .toList();
                                return Container(
                                  height: screenHeight * 0.7,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.9),
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: searchController,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText: "Search vehicles...",
                                          hintStyle: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.5)),
                                          prefixIcon: const Icon(Icons.search,
                                              color: Colors.white54),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.white24),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.white24),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide:
                                                BorderSide(color: primaryColor),
                                          ),
                                        ),
                                        onChanged: (_) => setModalState(() {}),
                                      ),
                                      const SizedBox(height: 16),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: filteredVehicles.length,
                                          itemBuilder: (context, index) {
                                            final vehicle =
                                                filteredVehicles[index];
                                            return RadioListTile<String>(
                                              value: vehicle['id'].toString(),
                                              groupValue: selectedId,
                                              onChanged: (val) {
                                                setModalState(() {
                                                  selectedId = val!;
                                                });
                                                editUserProvider
                                                    .selectedVehicles(
                                                        selectedId);
                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                              title: Text(
                                                vehicle['name'],
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              activeColor: primaryColor,
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
                                editUserProvider.selectedVehicleId == null
                                    ? 'Select Vehicle'
                                    : vehicleManagementProvider.vehicles
                                        .firstWhere((v) =>
                                            v['id'].toString() ==
                                            editUserProvider
                                                .selectedVehicleId)['name'],
                                style: TextStyle(
                                  color:
                                      editUserProvider.selectedVehicleId == null
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
                  ],
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
              // Category Selection as Bottom Sheet (already implemented)
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
                      List categories = editUserProvider.categoryList;
                      List selectedIds = List<String>.from(
                        mappedCategories.map((cat) => cat['id'].toString()),
                      );
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
                            decoration: BoxDecoration(
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
                                    // Update mappedCategories
                                    setState(() {
                                      mappedCategories = categories
                                          .where((cat) => selectedIds
                                              .contains(cat['id'].toString()))
                                          .map<Map<String, String>>((cat) => {
                                                'id': cat['id'].toString(),
                                                'name': cat['name'],
                                              })
                                          .toList();
                                    });
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
                          mappedCategories.isEmpty
                              ? 'Select Categories'
                              : mappedCategories
                                  .map((cat) => cat['name'])
                                  .join(', '),
                          style: TextStyle(
                            color: mappedCategories.isEmpty
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
              buildUserMenuSelection(
                  screenHeight, screenWidth, editUserProvider),
              const SizedBox(height: 28),
              // Save Button
              buildSaveButton(screenHeight, screenWidth, editUserProvider),
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
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.08),
            prefixIcon: Icon(icon, color: Colors.white54),
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

  Widget buildUserMenuSelection(
      double screenHeight, double screenWidth, UserEditProvider provider) {
    return Center(
      child: Container(
        height: screenHeight * 0.35,
        width: screenWidth * 0.9,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 18),
                child: Text(
                  "User Menu Selection",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              CheckboxWidget(
                onChanged: (bool? value) {
                  provider.consolidateToggleCheck();
                },
                isChecked: provider.isConsolidate,
                txt: "Consolidated Purchase",
              ),
              CheckboxWidget(
                onChanged: (bool? value) {
                  provider.mastersToggleCheck();
                },
                isChecked: provider.isMasters,
                txt: "Masters",
              ),
              CheckboxWidget(
                onChanged: (bool? value) {
                  provider.purchaseToggleCheck();
                  if (provider.isDriver == true &&
                      provider.isPurchase == false) {
                    provider.DriverToggleCheck();
                  }
                },
                isChecked: provider.isPurchase,
                txt: "Purchase Request",
              ),
              CheckboxWidget(
                onChanged: (bool? value) {
                  provider.DriverToggleCheck();
                  if (provider.isPurchase == false &&
                      provider.isDriver == true) {
                    provider.purchaseToggleCheck();
                  }
                },
                isChecked: provider.isDriver,
                txt: "Driver",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSaveButton(
      double screenHeight, double screenWidth, UserEditProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        gradientElevatedButton(
          onPressed: () {
            yesnoAlertDialog(
              context: context,
              message: "Do you want to save the changes?",
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              onNo: () {
                Navigator.pop(context);
              },
              onYes: () async {
                Navigator.pop(context); // Close the alert dialog
                await provider.userEdit(context, mappedCategories);
              },
              buttonNoText: "Cancel",
              buttonYesText: "Save",
            );
          },
          width: screenWidth * 0.23,
          height: screenHeight * 0.04,
          child: Center(
            child: provider.isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 4.0,
                    ),
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
        ),
      ],
    );
  }
}
