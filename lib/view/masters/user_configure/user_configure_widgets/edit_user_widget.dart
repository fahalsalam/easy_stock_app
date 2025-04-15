import 'dart:developer';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/customer_master/customer_master_provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/user_configure_provider/userEdit_provider.dart';
import 'package:easy_stock_app/models/masters/user_master/user_model.dart';
import 'package:easy_stock_app/utils/common_widgets/dropdown_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/view/masters/customer/customer_widgets/customer_textfield_widget.dart';
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

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(backgroundColor:Colors.black,
          title: const Text(
            "Update Password",
            style: TextStyle(fontSize: 15,color: Colors.white),
          ),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Enter new password",
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Cancel",style: TextStyle(color: primaryColor),),
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
              onPressed: () {},
              width: MediaQuery.of(context).size.width * 0.23,
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            // ElevatedButton(

            //   onPressed: () {
            //     String newPassword = passwordController.text;
            //     if (newPassword.isNotEmpty) {
            //       // Handle password update logic here
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(
            //             content: Text("Password updated successfully!")),
            //       );
            //       Navigator.pop(context);
            //     }
            //   },
            //   child: const Text("Change Password"),
            // ),
          ],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * .015),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
          child: Text(
            "Details",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: screenHeight * .01),
        Center(
          child: Container(
            width: screenWidth * 0.9,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildUserTextField(
                    "User Code",
                    editUserProvider.editUserCodeController,
                    screenWidth,
                  ),
                  buildUserTextField(
                    "Name",
                    editUserProvider.editUserNameController,
                    screenWidth,
                  ),
                  const SizedBox(height: 15),
                  buildAutoCompleteField(
                    hintText: editUserProvider.customerName.isEmpty
                        ? 'Select Customer'
                        : editUserProvider.customerName,
                    controller: customerProvider.customer_controller,
                    suggestionsCallback: (query) async {
                      return customerProvider.customers;
                    },
                    onSuggestionSelected: (suggestion) {
                      customerProvider.customer_controller.text =
                          suggestion['name'];
                      editUserProvider.customerID = suggestion['id'];
                      editUserProvider.customerName = suggestion['name'];
                      log("Selected Customer: ${suggestion['id']}, ${suggestion['name']}");
                    },
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      _showUpdatePasswordDialog(context);
                    },
                    child: Container(
                      height: screenHeight * 0.05,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text(
                          "Update Password ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isCategoryVisible = !isCategoryVisible;
                      });
                    },
                    child: Container(
                      height: screenHeight * 0.05,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text(
                          "Select Categories ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  isCategoryVisible
                      ? Container(
                          height: screenHeight * 0.2,
                          color: Colors.black,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 15, top: 5),
                            itemCount: editUserProvider.categoryList.length,
                            itemBuilder: (context, index) {
                              final data = editUserProvider.categoryList[index];

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (mappedCategories.any((category) =>
                                        category['id'] == data['id'])) {
                                      mappedCategories.removeWhere((category) =>
                                          category['id'] == data['id']);
                                    } else {
                                      mappedCategories.add({
                                        "id": data['id'],
                                        "name": data['name'],
                                      });
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: getCategoryColor(data['id']),
                                        border: Border.all(
                                            color: Colors.grey.shade200),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          data['name'],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        buildUserMenuSelection(screenHeight, screenWidth, editUserProvider),
        SizedBox(height: screenHeight * 0.01),
        buildSaveButton(screenHeight, screenWidth, editUserProvider),
        SizedBox(height: screenHeight * 0.01),
      ],
    );
  }

  Widget buildUserTextField(
      String label, TextEditingController controller, double screenWidth) {
    return Row(
      children: [
        SizedBox(
          width: screenWidth * 0.2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: CustomerTextfield(
            controller: controller,
            txt: "",
            color: Colors.grey.withOpacity(0.2),
            hintText: "",
            suffixIcon: const Icon(
              Icons.visibility,
              size: 18,
              color: Colors.transparent,
            ),
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
          onPressed: () {
            if (provider.editUserCodeController.text.isEmpty) {
              showSnackBarWithsub(
                context,
                "Please Enter User Code",
                "Error",
                Colors.red,
              );

              return; // Exit early if validation fails
            }
            if (provider.editUserNameController.text.isEmpty) {
              showSnackBarWithsub(
                context,
                "Please Enter User Name",
                "Error",
                Colors.red,
              );

              return; // Exit early if validation fails
            }
            // if (provider.mappedCategories.isEmpty) {
            //   showSnackBarWithsub(
            //     context,
            //     "Please select category",
            //     "Error",
            //     Colors.red,
            //   );

            //   return; // Exit early if validation fails
            // }
            yesnoAlertDialog(
              context: context,
              message: "Do you want to save?",
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              onNo: () {
                Navigator.pop(context);
              },
              onYes: () {
                provider.userEdit(context, mappedCategories);
                Navigator.pop(context);
              },
              buttonNoText: "No",
              buttonYesText: "Yes",
            );
          },
          width: screenWidth * 0.23,
          height: screenHeight * 0.04,
        ),
      ],
    );
  }
}
