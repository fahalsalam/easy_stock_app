import 'package:dotted_border/dotted_border.dart';
import 'package:easy_stock_app/controllers/providers/masters_provider/category_master/add_category_provider.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/custom_textformfield.dart';
import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/common_widgets/background_image_widget.dart';

class CategoryMasterAddCategoryPage extends StatefulWidget {
  const CategoryMasterAddCategoryPage({super.key});

  @override
  State<CategoryMasterAddCategoryPage> createState() =>
      _CategoryMasterAddCategoryPageState();
}

class _CategoryMasterAddCategoryPageState
    extends State<CategoryMasterAddCategoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddCategoryProvider>(context, listen: false)
          .changeLoading(false);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddCategoryProvider>(context, listen: false).removeImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final addCategoryProvider =
        Provider.of<AddCategoryProvider>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: CustomAppBar(txt: "Add Category"),
          ),
          Positioned(
            top: screenHeight * 0.14,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Category Image",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Consumer<AddCategoryProvider>(
                  builder: (context, imagePickerProvider, child) {
                    return DottedBorder(
                      color: Colors.grey,
                      strokeWidth: 2,
                      borderType: BorderType.RRect,
                      dashPattern: const [6, 3],
                      radius: const Radius.circular(12),
                      child: InkWell(
                        onTap: () {
                          if (imagePickerProvider.selectedImage == null) {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  _imageSourceBottomSheet(context),
                            );
                          }
                        },
                        child: Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.2,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              imagePickerProvider.selectedImage != null
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    yesnoAlertDialog(
                                                        context: context,
                                                        message:
                                                            'Do you want to remove Image?',
                                                        screenHeight:
                                                            screenHeight,
                                                        screenWidth:
                                                            screenWidth,
                                                        onNo: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        onYes: () {
                                                          imagePickerProvider
                                                              .deleteImage1();
                                                          Navigator.pop(
                                                              context);
                                                          showModalBottomSheet(
                                                            context: context,
                                                            builder: (context) =>
                                                                _imageSourceBottomSheet(
                                                                    context),
                                                          );
                                                        },
                                                        buttonNoText: 'No',
                                                        buttonYesText: 'Yes');
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.grey,
                                                  ))
                                            ],
                                          ),
                                        ),
                                        // SizedBox(
                                        //   height: screenHeight * 0.05,
                                        // ),
                                      ],
                                    )
                                  : SizedBox(),
                              imagePickerProvider.selectedImage != null
                                  ? SizedBox(
                                      height: screenHeight * 0.00,
                                    )
                                  : SizedBox(
                                      height: screenHeight * 0.08,
                                    ),
                              imagePickerProvider.isimageLoading
                                  ? SizedBox(
                                      height: screenHeight * 0.1,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : imagePickerProvider.selectedImage != null
                                      ? SizedBox(
                                          height: screenHeight * 0.12,
                                          width: screenWidth * 0.6,
                                          child: Image.file(
                                            imagePickerProvider.selectedImage!,
                                            fit: BoxFit.contain,
                                            width: screenWidth * 0.8,
                                            height: screenHeight * 0.2,
                                          ),
                                        )
                                      : const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'Tap to select image',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                CustomTextfield(mandatory : true,
                  txt: "Category Name",
                  hintText: "",
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.close,
                      color: Colors.transparent,
                    ),
                  ),
                  onChanged: (value) {
                    context.read<AddCategoryProvider>().setCategoryName(value);
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      gradientElevatedButton(
                        child: Consumer<AddCategoryProvider>(
                            builder: (context, provider, child) {
                          return Center(
                            child: provider.isLoading
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 2),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 5,
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                      "Add Category",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                          );
                        }),
                        onPressed: () {
                          if (addCategoryProvider.categoryNameController.text.isEmpty) {
                            showSnackBarWithsub(
                              context,
                              "Please Enter Category Name",
                              "Error",
                              Colors.red,
                            );

                            return; // Exit early if validation fails
                          }
                          yesnoAlertDialog(
                            context: context,
                            message: "Do you want to add?",
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                            onNo: () {
                              Navigator.pop(context);
                            },
                            onYes: () {
                              addCategoryProvider.submitCategory(
                                  addCategoryProvider.filename, context);
                              Navigator.pop(context);
                            },
                            buttonYesText: "No",
                            buttonNoText: "Yes",
                          );
                        },
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.04,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageSourceBottomSheet(BuildContext context) {
    final imageProvider =
        Provider.of<AddCategoryProvider>(context, listen: false);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: () {
              imageProvider.pickImageFromCamera();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Gallery"),
            onTap: () {
              imageProvider.pickImageFromGallery();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
