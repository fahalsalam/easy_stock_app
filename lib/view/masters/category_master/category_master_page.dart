import 'package:easy_stock_app/controllers/providers/masters_provider/category_master/category_list_provider.dart';
import 'package:easy_stock_app/utils/common_widgets/background_image_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/masters/category_master/add_category_page.dart';
import 'package:easy_stock_app/view/masters/category_master/edit_category_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryMasterListPage extends StatefulWidget {
  CategoryMasterListPage({super.key});

  @override
  State<CategoryMasterListPage> createState() => _CategoryMasterListPageState();
}

class _CategoryMasterListPageState extends State<CategoryMasterListPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCategories();
    });
  }

  void _fetchCategories() {
    setState(() {
      isLoading = true;
    });
    Provider.of<CategoryListProvider>(context, listen: false)
        .fetchCategory()
        .then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          // Search Box
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomAppBar(
                  txt: "Category Master",
                ),
                SizedBox(
                  height: screenHeight * 0.031,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: SizedBox(
                    height: screenHeight * 0.85,
                    child: Consumer<CategoryListProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          return SizedBox(
                              height: screenHeight * 0.8,
                              child: Center(
                                  child: const CircularProgressIndicator(
                                color: Colors.white,
                              ))); // Show loading spinner
                        } else if (provider.errorMessage.isNotEmpty) {
                          return Text(
                              provider.errorMessage); // Show error message
                        } else if (provider.categoryList.isEmpty) {
                          return SizedBox(
                            height: screenHeight * 0.8,
                            child: Center(
                              child: const Text("No categories available"),
                            ),
                          ); // Show empty message
                        } else {
                          return ListView.builder(
                            padding:
                                EdgeInsets.only(bottom: screenHeight * 0.1),
                            shrinkWrap: true,
                            itemCount: provider.categoryList.length,
                            itemBuilder: (context, index) {
                              final product = provider.categoryList[index];

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  height: screenHeight * 0.061,
                                  width: screenWidth * 0.3,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: primaryColor,
                                            child: Text(
                                              product.categoryName.isEmpty
                                                  ? 'C'
                                                  : product.categoryName[0]
                                                      .toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.categoryName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoryMasterEditCategoryPage(
                                                        data: product),
                                              ),
                                            ).then((_) =>
                                                provider.fetchCategory());
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
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
              builder: (context) => const CategoryMasterAddCategoryPage(),
            ),
          ).then((_) => context.read<CategoryListProvider>().fetchCategory());
        },
      ),
    );
  }
}
