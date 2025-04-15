// ignore_for_file: deprecated_member_use, camel_case_types

import 'dart:developer';

import 'package:easy_stock_app/models/purchase_order/order_details_model.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:number_to_words/number_to_words.dart';

class poinvoicePage extends StatefulWidget {
  List<Detail> dataList;
  String lpoNumber;
  String customerName;
  String companyname;
  String country;
  String state;
  String trnno;

  poinvoicePage(
      {Key? key,
      required this.dataList,
      required this.lpoNumber,
      required this.customerName,
      required this.companyname,
      required this.country,
      required this.state,
      required this.trnno})
      : super(key: key);

  @override
  State<poinvoicePage> createState() => _poinvoicePageState();
}

class _poinvoicePageState extends State<poinvoicePage> {
  File? pdfFile;
  PdfControllerPinch? pdfController;

  @override
  void initState() {
    super.initState();
    log('company name: ${widget.companyname}');
    _generatePDF();
  }

  Future<void> _generatePDF() async {
    final today = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final pdf = pw.Document();
    final subTotal = _calculateSubTotal();

    final totalVat = _calculateVatTotal();
    final totalInWords = _convertToWords((subTotal) - (totalVat));
    // Determine the maximum number of rows that fit on a single page
    const int rowsPerPage = 15; // Adjust this number as needed
    final pages = (widget.dataList.length / rowsPerPage).ceil();

    for (var page = 0; page < pages; page++) {
      // Get the items for the current page
      final items =
          widget.dataList.skip(page * rowsPerPage).take(rowsPerPage).toList();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (page == 0) ...[
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                            widget.companyname != 'null'
                                ? widget.companyname
                                : "",
                            // 'RAFA INTERNATIONAL GENERAL TRADING LLC ',
                            style: pw.TextStyle(
                                fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      ]),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                            '${widget.state != 'null' ? widget.state : ""}, ${widget.country != 'null' ? widget.country : ""}',
                            // 'DUBAI- UAE',
                            style: pw.TextStyle(
                                fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      ]),

                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                            widget.trnno != 'null'
                                ? 'TRN No: ${widget.trnno}'
                                : "",
                            // 'TRN: 100241961000003',
                            style: pw.TextStyle(
                                fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      ]),
                  pw.SizedBox(height: 20),
                  // Header (company details) - Only on the first page
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                   
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
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('ITEM & DESCRIPTION',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('UNIT',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('QTY',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('RATE',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                       
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text('AMOUNT',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
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
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(
                                double.parse(item.price).toStringAsFixed(2)),
                          ),
                    
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(total.toStringAsFixed(2)),
                          ),
                        ],
                      );
                    }),
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
                          pw.Text(
                              'Sub Total: ${subTotal.toStringAsFixed(2)} AED'),
                          pw.SizedBox(height: 5),
                          // pw.Text(
                          //     'Total Vat: ${totalVat.toStringAsFixed(2)} AED'),
                          // pw.SizedBox(height: 5),
                          pw.Text(
                              'Total: ${((subTotal)).toStringAsFixed(2)} AED',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 20),
                          pw.Text('Total In Words: $totalInWords'),
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
            );
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
    );
  }

  @override
  void dispose() {
    pdfController?.dispose();
    super.dispose();
  }
}

   // pw.Column(
                      //   crossAxisAlignment: pw.CrossAxisAlignment.start,
                      //   children: [
                      //     // pw.Text('SCANNTEK',
                      //     //     style: pw.TextStyle(
                      //     //         fontSize: 18,
                      //     //         fontWeight: pw.FontWeight.bold)),
                      //     // pw.SizedBox(height: 2),
                      //     // pw.Text('Maharashtra, India'),
                      //     // pw.SizedBox(height: 2),
                      //     // pw.Text('GSTIN 27ABCDE1234F1Z5'),
                      //     // pw.SizedBox(height: 2),
                      //     // pw.Text('8281009267'),
                      //     // pw.SizedBox(height: 2),
                      //     // pw.Text('fahal@scantek.com'),
                      //     // pw.SizedBox(height: 20),
                      //   ],
                      // ),


 // pw.Padding(
                        //   padding: const pw.EdgeInsets.all(8.0),
                        //   child: pw.Text('VAT',
                        //       style:
                        //           pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        // ),
                              // pw.Padding(
                          //   padding: const pw.EdgeInsets.all(8.0),
                          //   child: pw.Text(
                          //       double.parse(item.vat).toStringAsFixed(2)),
                          // ),