import 'dart:developer';

import 'package:easy_stock_app/controllers/providers/purchase_request/completed/completed_provider.dart';
import 'package:easy_stock_app/models/purchase/pending/pending_details_model.dart';
import 'package:easy_stock_app/utils/common_widgets/background_image_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/common_widgets/smackbar.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/purchase_request/common_widgets/buildTextRow.dart';
import 'package:easy_stock_app/view/purchase_request/completed/completed_invoice_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompletedDetailsPage extends StatefulWidget {
  String orderID, editNo, customerName, orderId;
  String companyname;
  String country;
  String state;
  String trnno;
  CompletedDetailsPage(
      {super.key,
      required this.orderID,
      required this.editNo,
      required this.customerName,
      required this.orderId,
      required this.companyname,
      required this.country,
      required this.state,
      required this.trnno});

  @override
  State<CompletedDetailsPage> createState() => _CompletedDetailsPageState();
}

class _CompletedDetailsPageState extends State<CompletedDetailsPage> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<CompletedProvider>(context, listen: false)
          .initializeDetails(orderID: widget.orderID, editNo: widget.editNo)
          .then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  Future<void> _loadDatas() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<CompletedProvider>(context, listen: false)
          .initializeDetails(
        orderID: widget.orderID,
        editNo: widget.editNo,
      );
    } catch (e) {
      log('Error reloading data: $e');
      if (mounted) {
        showSnackBar(
          context,
          "Failed to refresh data",
          "Error",
          Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    final provider = Provider.of<CompletedProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: CustomAppBar(txt: 'Completed Details'),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadDatas,
                    backgroundColor: Colors.white,
                    color: primaryColor,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isLoading &&
                              !provider.isLoading &&
                              provider.pendingDetails.isNotEmpty)
                            _buildHeader(context, provider, screenWidth),
                          SizedBox(height: screenHeight * 0.02),
                          if (isLoading || provider.isLoading)
                            _buildLoadingIndicator(screenHeight)
                          else if (provider.pendingDetails.isEmpty)
                            _buildEmptyState(screenHeight)
                          else
                            _buildDetailsList(provider),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, CompletedProvider provider, double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.person_outline, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Text(
                widget.customerName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              try {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompletedInvoicePage(
                      dataList: provider.pendingDetails,
                      lpoNumber: widget.orderId.toString(),
                      customerName: widget.customerName,
                      companyname: widget.companyname,
                      country: widget.country,
                      state: widget.state,
                      trnno: widget.trnno,
                    ),
                  ),
                );
              } catch (e) {
                log("Error occurred: $e");
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primaryColor, width: 1),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      color: Colors.black, size: 14),
                  SizedBox(width: 6),
                  Text(
                    "Invoice",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.5,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              "Loading details...",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.5,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 48,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              "No Details Found",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsList(CompletedProvider provider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: provider.pendingDetails.length,
      itemBuilder: (context, index) {
        PendingDetailsData detail = provider.pendingDetails[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            detail.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.image,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detail.productName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'UOM: ${detail.uomCode}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 20),
                  BuildTextRow(
                      label: "Price",
                      value:
                          '${double.parse(detail.price).toStringAsFixed(2)} AED'),
                  const SizedBox(height: 8),
                  BuildTextRow(
                      label: "Quantity",
                      value: double.parse(detail.qty).toStringAsFixed(2)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class BuildTextRow extends StatelessWidget {
  final String label;
  final String value;
  const BuildTextRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
