import 'dart:developer';

import 'package:easy_stock_app/controllers/providers/masters_provider/customer_master/customer_master_provider.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/user_configure_provider/user_configure_provider.dart';
import 'package:easy_stock_app/utils/common_widgets/dropdown_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/view/masters/customer/customer_widgets/customer_textfield_widget.dart';
import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/gradient_button.dart';
import 'package:easy_stock_app/view/masters/user_configure/user_configure_widgets/checkbox_widget.dart';
import 'package:easy_stock_app/view/masters/user_configure/user_configure_widgets/multi_select_dropdown.dart';
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
      Provider.of<UserConfigureProvider>(context, listen: false).removeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final userConfigureProvider = Provider.of<UserConfigureProvider>(context);
    final customerManagementProvider =
        Provider.of<CustomerManagementProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenHeight * 0.015),
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
        SizedBox(height: screenHeight * 0.01),
        Center(
          child: Container(
            // height: screenHeight * 0.324,
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
                  buildUserTextField("User Code",
                      userConfigureProvider.userCodeController, screenWidth,true),
                  buildUserTextField("Name",
                      userConfigureProvider.userNameController, screenWidth,true),
                  buildPasswordField(screenHeight, userConfigureProvider,screenWidth),
                  SizedBox(
                    height: 15,
                  ),
                  Consumer<UserConfigureProvider>(
                    builder: (context, provider, child) {
                      return buildAutoCompleteField(
                        hintText: provider.customerName.isEmpty
                            ? 'Select Customer'
                            : provider.customerName,
                        controller:
                            customerManagementProvider.vehicle_controller,
                        suggestionsCallback: (query) async {
                          return customerManagementProvider.customers;
                        },
                        onSuggestionSelected: (suggestion) {
                          provider.addCustomer(
                              suggestion['id'], suggestion['name']);
                          log("Selected Customer: ${suggestion['id']}, ${suggestion['name']}");
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  MultiSelectCategoryDropdown(
                    categories: userConfigureProvider.categoryList,
                    onSelectionChanged: (selectedCategories) {
                      // Handle selected categories here
                      print("Selected Categories: $selectedCategories");
                      userConfigureProvider
                          .selectedCategories(selectedCategories);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        buildUserMenuSelection(
            screenHeight, screenWidth, userConfigureProvider),
        SizedBox(height: screenHeight * 0.01),
        buildSaveButton(screenHeight, screenWidth, userConfigureProvider),
        SizedBox(height: screenHeight * 0.01),
      ],
    );
  }

  Widget buildUserTextField(
      String label, TextEditingController controller, double screenWidth,bool mandatory) {
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
            mandatory: mandatory,
            controller: controller,
            txt: "",
            color: Colors.grey.withOpacity(0.2),
            hintText: "",
            suffixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.visibility,
                size: 18,
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordField(
      double screenHeight, UserConfigureProvider provider,screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
           SizedBox(
       width: screenWidth * 0.225,
            child: Text(
              "Password",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
         SizedBox(width: screenWidth*0.59,
            child: Container(
              height: screenHeight * 0.056,
              
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1,color: Colors.red)
              ),
              child: TextFormField(
                controller: provider.userPasswordController,
                obscureText: provider.isshowPassword,
                cursorColor: primaryColor,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(15),
                  suffixIcon: IconButton(
                    onPressed: provider.togglePasswordVisibility,
                    icon: Icon(
                      provider.isshowPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserMenuSelection(
      double screenHeight, double screenWidth, UserConfigureProvider provider) {
    return Center(
      child: Container(
        height: screenHeight * 0.3,
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
              // CheckboxWidget(
              //   onChanged: (bool? value) {
              //     provider.toggleCheckbox1();
              //   },
              //   isChecked: provider.isChecked1,
              //   txt: "Purchase Request",
              // ),
              // CheckboxWidget(
              //   onChanged: (bool? value) {
              //     provider.toggleCheckbox3();
              //   },
              //   isChecked: provider.isChecked3,
              //   txt: "Driver",
              // ),
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
                  if (provider.isDriver == true &&
                      provider.isPurchase == false) {
                    provider.toggleDriver();
                  }
                },
                isChecked: provider.isRequest,
                txt: "Purchase Request",
              ),
              CheckboxWidget(
                onChanged: (bool? value) {
                  provider.toggleDriver();
                  if (provider.isRequest == false &&
                      provider.isDriver == true) {
                    provider.toggleRequest();
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
      double screenHeight, double screenWidth, UserConfigureProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        gradientElevatedButton(
          child: Center(
            child: provider.isLoading
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
             if (provider.userCodeController.text.isEmpty) {
              showSnackBarWithsub(
                context,
                "Please Enter User Code",
                "Error",
                Colors.red,
              );

              return; // Exit early if validation fails
            }
             if (provider.userNameController.text.isEmpty) {
              showSnackBarWithsub(
                context,
                "Please Enter User Name",
                "Error",
                Colors.red,
              );

              return; // Exit early if validation fails
            }
            if (provider.selectedcategoryIds.isEmpty) {
              showSnackBarWithsub(
                context,
                "Please select category",
                "Error",
                Colors.red,
              );

              return; // Exit early if validation fails
            }
            yesnoAlertDialog(
              context: context,
              message: "Do you want to save?",
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              onNo: () {
                Navigator.pop(context);
              },
              onYes: () {
                provider.userSave(context);
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
