// ignore_for_file: unused_local_variable, deprecated_member_use, use_super_parameters

import 'dart:developer';
import 'package:easy_stock_app/controllers/printing/request_printing.dart';
import 'package:easy_stock_app/models/purchase_order/order_details_model.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:share_plus/share_plus.dart';

class LpoinvoicePage extends StatefulWidget {
  List<Detail> dataList;
  String lpoNumber;
  String customerName;
  Header header;
  LpoinvoicePage(
      {super.key,
      required this.dataList,
      required this.lpoNumber,
      required this.header,
      required this.customerName});

  @override
  State<LpoinvoicePage> createState() => _CompletedInvoicePageState();
}

class _CompletedInvoicePageState extends State<LpoinvoicePage> {
  File? pdfFile;
  PdfControllerPinch? pdfController;

  @override
  void initState() {
    super.initState();
    _generatePDF();
  }

  Future<List<int>> _generateEscPosInvoice() async {
    final profile = await CapabilityProfile.load();
    final generator =
        Generator(PaperSize.mm80, profile); // Adjusted for 4-inch printers

    List<int> bytes = [];
    int totalWidth = 69; // Approximate character width for a 4-inch printer
    int leftMarginSpaces = 2; // Adjust this value for more margin
    String leftMargin = ' ' * leftMarginSpaces;

    // Function to manually center text with left margin
    String centerText(String text) {
      int padding = (totalWidth - text.length) ~/ 2;
      return '${' ' * padding}$text${' ' * padding}';
    }
    // String centerText(String text) {
    //   int padding = ((totalWidth - text.length) ~/ 2);
    //   return '$leftMargin${' ' * padding}$text${' ' * padding}';
    // }

    // Function to right-align text with left margin
    String rightAlignText(String text) {
      int padding = totalWidth - text.length - leftMarginSpaces;
      return '$leftMargin${' ' * padding}$text';
    }

    // **Company Header**
    // bytes += generator.text(
    //   '${centerText('$leftMargin${widget.header.printHeader}')}',
    //   styles: const PosStyles(height: PosTextSize.size2, bold: true),
    // );
    // bytes += generator.text(centerText(
    //     '$leftMargin${widget.header.state}, ${widget.header.country}'));
    // bytes += generator
    //     .text(centerText('$leftMargin TRN NO: ${widget.header.trnNo}'));
    // bytes += generator.text(centerText(
    //     '$leftMargin${'-' * (totalWidth - leftMarginSpaces)}')); // Divider line

    // **Centered TAX INVOICE Title**
    bytes += generator.text(
      centerText('DELIVERY NOTE'),
      styles: const PosStyles(height: PosTextSize.size2, bold: true),
    );

    bytes += generator.text(
        '$leftMargin${'-' * (totalWidth - leftMarginSpaces)}'); // Divider line again

    // **Customer Details**
    bytes += generator.text('$leftMargin Bill To: ${widget.customerName}');
    bytes += generator.text('$leftMargin LPO Number: ${widget.lpoNumber}');
    bytes += generator.text(
        '$leftMargin${'-' * (totalWidth - leftMarginSpaces)}'); // Divider line

    // **Column Headers with Proper Spacing**
    int snoWidth = 5; // S.No width
    int nameWidth = 20;
    int qtyWidth = 16; //7 Quantity
    int rateWidth = 10; // Rate
    int amountWidth = 14; // Amount

    String headers = '$leftMargin${'S.No'.padRight(snoWidth)}'
        '$leftMargin${'ITEM'.padRight(nameWidth)}'
        '${'UNIT'.padLeft(qtyWidth)}'
        '${'QTY'.padLeft(qtyWidth)}'
        // '${'RATE'.padLeft(rateWidth)}'
        // '${'VAT'.padLeft(rateWidth)}'
        // '${'AMOUNT'.padLeft(amountWidth)}'
        ;

    bytes += generator.text(headers, styles: const PosStyles(bold: true));
    bytes += generator.text(
        '$leftMargin${'-' * (totalWidth - leftMarginSpaces)}'); // Line separator

    // **Print Items with Proper Spacing**
    for (int i = 0; i < widget.dataList.length; i++) {
      var item = widget.dataList[i];
      double total = double.parse(item.price) * double.parse(item.qty);
      String serial = (i + 1).toString().padRight(snoWidth);

      bytes += generator.text('$leftMargin$serial'
          '${item.productName.padRight(nameWidth)}'
          '${double.parse(item.qty).toStringAsFixed(2).padLeft(qtyWidth)}'
          '${double.parse(item.price).toStringAsFixed(2).padLeft(rateWidth)}'
          '${total.toStringAsFixed(2).padLeft(amountWidth)}');

      bytes +=
          generator.text('$leftMargin${'-' * (totalWidth - leftMarginSpaces)}');
    }
    // for (var item in widget.dataList) {
    //   double total = double.parse(item.price) * double.parse(item.qty);

    //   bytes += generator.text(
    //       '$leftMargin${item.productName.padRight(nameWidth)}'
    //       '${(item.uomCode).padLeft
    //       (qtyWidth)}'
    //       '${double.parse(item.qty).toStringAsFixed(2).padLeft(qtyWidth)}'
    //       // '${double.parse(item.price).toStringAsFixed(2).padLeft(rateWidth)}'
    //       // '${double.parse(item.vat).toStringAsFixed(2).padLeft(rateWidth)}'
    //       // '${total.toStringAsFixed(2).padLeft(amountWidth)}'
    //       );

    //   bytes += generator.text(
    //       '$leftMargin${'-' * (totalWidth - leftMarginSpaces)}'); // Line separator
    // }

    // bytes += generator.text(
    //   rightAlignText('Total: ${_calculateSubTotal().toStringAsFixed(2)} AED'),
    //   styles: const PosStyles(bold: true),
    // );

    // double vat = _calculateSubTotal() * 0.05; // Example: 5% VAT
    double grandTotal = _calculateSubTotal();
    // ; + vat;
    double totalQty = _calculateQtyTotal();
    // bytes += generator
    //     .text(rightAlignText('Total VAT: ${vat.toStringAsFixed(2)} AED'));
    bytes += generator.text(
      rightAlignText('Total Qty: ${totalQty.toStringAsFixed(2)}'),
      styles: const PosStyles(
        height: PosTextSize.size2,
        bold: true,
        align: PosAlign.right,
      ),
    );

    bytes +=
        generator.text('$leftMargin${'-' * (totalWidth - leftMarginSpaces)}');
    bytes += generator.text(
      centerText('Thank You! Visit Again!'),
      styles: const PosStyles(bold: true),
    );

    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }

  Future<void> scanAndPrint(BuildContext context) async {
    // Scan for paired Bluetooth devices
    final List<BluetoothInfo> devices =
        await PrintBluetoothThermal.pairedBluetooths;

    if (devices.isEmpty) {
      log('No Bluetooth devices found.');
      return;
    }

    // Convert to list of maps for UI
    List<Map<String, String>> deviceList = devices
        .map((device) => {
              'name': device.name,
              'macAddress': device.macAdress,
            })
        .toList();

    // Show dialog for printer selection
    Map<String, String>? selectedPrinter =
        await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Select a Printer',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: deviceList.map((device) {
                return ListTile(
                  title: Text(
                    device['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    device['macAddress'] ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, device);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    // If no printer selected, exit function
    if (selectedPrinter == null) {
      log(
        'No printer selected.',
      );
      return;
    }

    String macAddress = selectedPrinter['macAddress']!.trim();
    log('Selected Printer: $macAddress');

    // Check connection status
    bool isConnected = await PrintBluetoothThermal.connectionStatus;
    log("Printer connection status: $isConnected");

    // Connect if not already connected
    if (!isConnected) {
      bool connected =
          await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
      log('Connection attempt: $connected');

      isConnected = await PrintBluetoothThermal.connectionStatus;
    }

    // Proceed with printing if connected
    if (isConnected) {
      List<int> bytes = await _generateEscPosInvoice();
      bool success = await PrintBluetoothThermal.writeBytes(bytes);
      log(success ? 'Print successful' : 'Print failed');
    } else {
      log('Printer not connected. Cannot print.');
    }
  }

  Future<void> _generatePDF() async {
    final today = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final pdf = pw.Document();
    final subTotal = _calculateSubTotal();
    final totalQty = _calculateQtyTotal();
    final totalVat = _calculateVatTotal();
    final totalInWords = _convertToWords((subTotal) - (0));
    // Determine the maximum number of rows that fit on a single page
    const int rowsPerPage = 15; // Adjust this number as needed
    final pages = (widget.dataList.length / rowsPerPage).ceil();

    for (var page = 0; page < pages; page++) {
      // Get the items for the current page
      final items =
          widget.dataList.skip(page * rowsPerPage).take(rowsPerPage).toList();

      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) {
            return [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (page == 0) ...[
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // pw.Text(widget.header.printHeader,
                          //     style: pw.TextStyle(
                          //         fontSize: 18,
                          //         fontWeight: pw.FontWeight.bold)),
                        ]),
                    // pw.Row(
                    //     mainAxisAlignment: pw.MainAxisAlignment.center,
                    //     crossAxisAlignment: pw.CrossAxisAlignment.start,
                    //     children: [
                    //       pw.Text(
                    //           '${widget.header.state},${widget.header.country}',
                    //           style: pw.TextStyle(
                    //               fontSize: 18,
                    //               fontWeight: pw.FontWeight.bold)),
                    //     ]),

                    // pw.Row(
                    //     mainAxisAlignment: pw.MainAxisAlignment.center,
                    //     crossAxisAlignment: pw.CrossAxisAlignment.start,
                    //     children: [
                    //       pw.Text('TRN NO: ${widget.header.trnNo}',
                    //           style: pw.TextStyle(
                    //               fontSize: 18,
                    //               fontWeight: pw.FontWeight.bold)),
                    //     ]),
                    // pw.SizedBox(height: 20),

                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [],
                        ),
                        pw.Text('DELIVERY NOTE',
                            style: pw.TextStyle(
                                fontSize: 24, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 5),
                      ],
                    ),
                    pw.SizedBox(height: 10),

                    // Customer information - Only on the first page
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Bill To:'),
                            pw.Text(widget.customerName,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'LPO Number: ${widget.lpoNumber}',
                            ),
                            pw.Text('Invoice Date: $today'),
                            // pw.Text('Due Date: $today'),
                            // pw.Text('Terms: Due on Receipt'),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 28),
                  ],

                  // Item table
                  pw.Table(
                    border: pw.TableBorder.all(width: 0.5),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('S.No',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('ITEM & DESCRIPTION',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('UNIT',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text('QTY',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ),
                          // pw.Padding(
                          //   padding: const pw.EdgeInsets.all(8.0),
                          //   child: pw.Text('RATE',
                          //       style: pw.TextStyle(
                          //           fontWeight: pw.FontWeight.bold)),
                          // ),
                          // pw.Padding(
                          //   padding: const pw.EdgeInsets.all(8.0),
                          //   child: pw.Text('VAT',
                          //       style: pw.TextStyle(
                          //           fontWeight: pw.FontWeight.bold)),
                          // ),
                          // pw.Padding(
                          //   padding: const pw.EdgeInsets.all(8.0),
                          //   child: pw.Text('AMOUNT',
                          //       style: pw.TextStyle(
                          //           fontWeight: pw.FontWeight.bold)),
                          // ),
                        ],
                      ),
                      ...items.asMap().entries.map((entry) {
                        // ...items.map((item) {
                        int index = entry.key + (page * rowsPerPage) + 1;
                        final item = entry.value;
                        final total =
                            double.parse(item.price) * double.parse(item.qty);
                        return pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(index.toString()),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(item.productName),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(item.uomCode),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Text(
                                  double.parse(item.qty).toStringAsFixed(2)),
                            ),
                            // pw.Padding(
                            //   padding: const pw.EdgeInsets.all(8.0),
                            //   child: pw.Text(
                            //       double.parse(item.price).toStringAsFixed(2)),
                            // ),
                            // pw.Padding(
                            //   padding: const pw.EdgeInsets.all(8.0),
                            //   child: pw.Text(
                            //       double.parse(item.vat).toStringAsFixed(2)),
                            // ),
                            // pw.Padding(
                            //   padding: const pw.EdgeInsets.all(8.0),
                            //   child: pw.Text(total.toStringAsFixed(2)),
                            // ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                  pw.SizedBox(height: 20),

                  // Footer with totals (only on last page)
                  if (page == pages - 1)
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            // pw.Text(
                            //     'Sub Total: ${subTotal.toStringAsFixed(2)} AED'),
                            // pw.SizedBox(height: 5),
                            // pw.Text(
                            //     'Total Vat: ${totalVat.toStringAsFixed(2)} AED'),
                            pw.SizedBox(height: 5),
                            pw.Text(
                                'Total Quantity:${totalQty.toStringAsFixed(2)}',
                                //  ${((subTotal) + (totalVat)).toStringAsFixed(2)} AED',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 20),
                            // pw.Text('Total In Words: $totalInWords'),
                          ],
                        ),
                      ],
                    ),
                  if (page == pages - 1) ...[
                    pw.SizedBox(height: 20),
                    pw.Text('Notes'),
                    pw.SizedBox(height: 10),
                    pw.Text('Thanks for your business'),
                    pw.SizedBox(height: 50),
                    pw.Text('Authorized Signature __________________'),
                  ],
                ],
              ),
            ];
          },
        ),
      );
    }

    final outputDir = await getTemporaryDirectory();
    final outputFile = File('${outputDir.path}/invoice.pdf');
    await outputFile.writeAsBytes(await pdf.save());

    setState(() {
      pdfFile = outputFile;
      pdfController =
          PdfControllerPinch(document: PdfDocument.openFile(pdfFile!.path));
    });
  }

  double _calculateSubTotal() {
    return widget.dataList.fold(0.0, (sum, item) {
      return sum + (double.parse(item.price) * double.parse(item.qty));
    });
  }

  double _calculateQtyTotal() {
    return widget.dataList.fold(0.0, (sum, item) {
      return sum + (double.parse(item.qty));
    });
  }

  double _calculateVatTotal() {
    return widget.dataList.fold(0.0, (sum, item) {
      return sum + (double.parse(item.vat));
    });
  }

  String _convertToWords(double amount) {
    if (amount == 0) return "Zero ";

    int rupees = amount.toInt();
    String words = NumberToWord().convert('en-in', rupees);

    return '${words[0].toUpperCase()}${words.substring(1)}';
  }

  void _sharePDF() {
    if (pdfFile != null) {
      Share.shareFiles([pdfFile!.path], text: 'Invoice PDF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Invoice Preview',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, size: 20, color: Colors.white),
            onPressed: _sharePDF,
          ),
        ],
      ),
      body: pdfController == null
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : PdfViewPinch(
              controller: pdfController!,
              scrollDirection: Axis.vertical,
              backgroundDecoration: const BoxDecoration(
                color: Color.fromARGB(255, 250, 250, 250),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x73000000),
                      blurRadius: 4,
                      offset: Offset(2, 2))
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          if (await requestPrintingPermissions(context)) {
            await scanAndPrint(context);
          }
        },
        child: const Icon(Icons.print),
      ),
    );
  }

  @override
  void dispose() {
    pdfController?.dispose();
    super.dispose();
  }
}
