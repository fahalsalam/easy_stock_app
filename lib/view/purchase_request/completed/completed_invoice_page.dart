import 'dart:developer';
import 'dart:io';
import 'package:easy_stock_app/controllers/printing/request_printing.dart';
import 'package:easy_stock_app/models/purchase/pending/pending_details_model.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfx/pdfx.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:share_plus/share_plus.dart';

class CompletedInvoicePage extends StatefulWidget {
  List<PendingDetailsData> dataList;
  String lpoNumber;
  String customerName;
  String companyname;
  String country;
  String state;
  String trnno;
  String invoiceType;
  CompletedInvoicePage({
    super.key,
    required this.dataList,
    required this.lpoNumber,
    required this.customerName,
    required this.companyname,
    required this.country,
    required this.state,
    required this.trnno,
    required this.invoiceType,
  });

  @override
  State<CompletedInvoicePage> createState() => _CompletedInvoicePageState();
}

class _CompletedInvoicePageState extends State<CompletedInvoicePage> {
  File? pdfFile;
  PdfControllerPinch? pdfController;

  @override
  void initState() {
    super.initState();
    _generatePDF();
  }

  Future<void> _generatePDF() async {
    final today = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final pdf = pw.Document();
    final subTotal = _calculateSubTotal();
    final totalVat = _calculateVatTotal();
    final grandTotal = subTotal + totalVat;
    final totalInWords = _convertToWords(grandTotal);

    final headers = [
      'SL No',
      'Description of Goods',
      'Unit',
      'Qty',
      'Rate',
      if (widget.invoiceType.contains('Tax')) 'VAT',
      if (widget.invoiceType.contains('Tax')) 'Amount Excl. VAT',
      if (widget.invoiceType.contains('Tax')) 'Amount Incl. VAT',
      if (!widget.invoiceType.contains('Tax')) 'Amount'
    ];

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(16),
        header: (context) {
          if (context.pageNumber == 1) {
            return _buildHeader(context, widget.invoiceType, today);
          }
          return pw.Container();
        },
        // header: (context) => _buildHeader(context, widget.invoiceType, today),
        build: (context) {
          return [
            _buildCustomerDetails(widget.customerName),
            pw.SizedBox(height: 10),

            /// Table Content
            pw.Table.fromTextArray(
              headers: headers,
              cellAlignment: pw.Alignment.centerLeft,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(fontSize: 10),
              columnWidths: {
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(3),
                2: pw.FlexColumnWidth(1.5),
                3: pw.FlexColumnWidth(1.5),
                4: pw.FlexColumnWidth(1.5),
                5: pw.FlexColumnWidth(1.2),
                6: pw.FlexColumnWidth(2),
                7: pw.FlexColumnWidth(2),
              },
              data: List<List<String>>.generate(
                widget.dataList.length,
                (index) {
                  final item = widget.dataList[index];
                  final qty = double.tryParse(item.qty) ?? 0;
                  final rate = double.tryParse(item.price) ?? 0;
                  final amount = qty * rate;
                  final vat = amount * 0.05;
                  final totalWithVat = amount + vat;

                  return [
                    '${index + 1}',
                    item.productName,
                    item.uomCode,
                    qty.toStringAsFixed(2),
                    rate.toStringAsFixed(2),
                    if (widget.invoiceType.contains('Tax')) '5%',
                    amount.toStringAsFixed(2),
                    if (widget.invoiceType.contains('Tax'))
                      totalWithVat.toStringAsFixed(2),
                  ];
                },
              ),
            ),

            pw.SizedBox(height: 20),

            /// Totals Section (only on last page)
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  if (widget.invoiceType.contains('Tax'))
                    pw.Text(
                        'Amount Excl. VAT: ${subTotal.toStringAsFixed(2)} AED'),
                  if (widget.invoiceType.contains('Tax'))
                    pw.Text('VAT @ 5%: ${totalVat.toStringAsFixed(2)} AED'),
                  pw.Text('Total Amount: ${grandTotal.toStringAsFixed(2)} AED',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Text('Amount in words: $totalInWords AED Only'),
                ],
              ),
            ),

            pw.SizedBox(height: 20),
            pw.Text('Declaration:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(
                'We declare that this invoice shows the actual price of the goods described and that all particulars are true.'),
            pw.SizedBox(height: 20),
            pw.Text('Goods received in good condition'),
            pw.SizedBox(height: 50),
            pw.Text('Authorized Signature __________________'),
          ];
        },
      ),
    );

    final outputDir = await getTemporaryDirectory();
    final outputFile = File('${outputDir.path}/invoice.pdf');
    await outputFile.writeAsBytes(await pdf.save());

    setState(() {
      pdfFile = outputFile;
      pdfController =
          PdfControllerPinch(document: PdfDocument.openFile(pdfFile!.path));
    });
  }

  pw.Widget _buildHeader(pw.Context context, String invoiceType, String today) {
    return pw.Column(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 1),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text('ONIONPOT',
                  style: pw.TextStyle(
                      fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.Text('FOODSTUFF TRADING L.L.C',
                  style: pw.TextStyle(fontSize: 12)),
              pw.Divider(),
              pw.Text(invoiceType,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline,
                  )),
            ],
          ),
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget _buildCustomerDetails(String customerName) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 220,
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Customer:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(customerName),
              pw.SizedBox(height: 5),
              pw.Text('TRN: 76746'),
            ],
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Container(
          width: 220,
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('TRN: 100472823200003',
                  style: pw.TextStyle(fontSize: 10)),
              pw.Text('INVOICE NO: ${widget.lpoNumber}',
                  style: pw.TextStyle(fontSize: 10)),
              pw.Text(
                  'INVOICE DATE: ${DateFormat('dd/MM/yyyy').format(DateTime.now())} ',
                  style: pw.TextStyle(fontSize: 10)),
              pw.Text('DELIVERY REF: 575757',
                  style: pw.TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

// -->pagination errror
  // Future<void> _generatePDF() async {
  //   final today = DateFormat('dd/MM/yyyy').format(DateTime.now());
  //   final pdf = pw.Document();
  //   final subTotal = _calculateSubTotal();
  //   final totalVat = _calculateVatTotal();
  //   final grandTotal = subTotal + totalVat;
  //   final totalInWords = _convertToWords(grandTotal);

  //   const int rowsPerPage = 15;
  //   final pages = (widget.dataList.length / rowsPerPage).ceil();

  //   for (var page = 0; page < pages; page++) {
  //     final items =
  //         widget.dataList.skip(page * rowsPerPage).take(rowsPerPage).toList();

  //     pdf.addPage(
  //       pw.MultiPage(
  //         build: (pw.Context context) {
  //           return [
  //             pw.Column(
  //               crossAxisAlignment: pw.CrossAxisAlignment.start,
  //               children: [
  //                 if (page == 0) ...[
  //                   /// Header with company details
  //                   // Company Header Block
  //                   pw.Container(
  //                     padding: const pw.EdgeInsets.all(8),
  //                     decoration: pw.BoxDecoration(
  //                       border: pw.Border.all(width: 1),
  //                     ),
  //                     child: pw.Column(
  //                       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                       children: [
  //                         pw.Row(
  //                           mainAxisAlignment: pw.MainAxisAlignment.center,
  //                           children: [
  //                             pw.Column(
  //                               crossAxisAlignment:
  //                                   pw.CrossAxisAlignment.center,
  //                               children: [
  //                                 pw.Text('ONIONPOT',
  //                                     style: pw.TextStyle(
  //                                       fontSize: 22,
  //                                       fontWeight: pw.FontWeight.bold,
  //                                     )),
  //                                 pw.Text('FOODSTUFF TRADING L.L.C',
  //                                     style: pw.TextStyle(fontSize: 12)),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                         pw.Divider(),
  //                         pw.Center(
  //                           child: pw.Text(widget.invoiceType,
  //                               style: pw.TextStyle(
  //                                   fontSize: 14,
  //                                   fontWeight: pw.FontWeight.bold,
  //                                   decoration: pw.TextDecoration.underline)),
  //                         ),
  //                       ],
  //                     ),
  //                   ),

  //                   /// Customer Details
  //                   pw.SizedBox(height: 6),
  //                   pw.Row(
  //                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                     children: [
  //                       /// Left container
  //                       pw.Container(
  //                         width: 220,
  //                         padding: const pw.EdgeInsets.all(8),
  //                         decoration: pw.BoxDecoration(
  //                           border: pw.Border.all(width: 1),
  //                         ),
  //                         child: pw.Column(
  //                           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                           children: [
  //                             pw.Text('Customer:',
  //                                 style: pw.TextStyle(
  //                                     fontWeight: pw.FontWeight.bold)),
  //                             pw.Text(widget.customerName),
  //                             pw.SizedBox(height: 5),
  //                             pw.Text('TRN: 76746'),
  //                           ],
  //                         ),
  //                       ),
  //                       pw.SizedBox(width: 20),

  //                       /// Right container
  //                       pw.Container(
  //                         width: 220,
  //                         padding: const pw.EdgeInsets.all(8),
  //                         decoration: pw.BoxDecoration(
  //                           border: pw.Border.all(width: 1),
  //                         ),
  //                         child: pw.Column(
  //                           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                           children: [
  //                             pw.Text('TRN: 100472823200003',
  //                                 style: pw.TextStyle(fontSize: 10)),
  //                             pw.Text('INVOICE NO: 757475757',
  //                                 style: pw.TextStyle(fontSize: 10)),
  //                             pw.Text('INVOICE DATE: $today',
  //                                 style: pw.TextStyle(fontSize: 10)),
  //                             pw.Text('DELIVERY REF: 575757',
  //                                 style: pw.TextStyle(fontSize: 10)),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),

  //                   pw.SizedBox(height: 6),
  //                 ],

  //                 /// Table Header
  //                 pw.Table(
  //                   border: pw.TableBorder.all(width: 0.5),
  //                   columnWidths: {
  //                     0: pw.FlexColumnWidth(1), // SL No
  //                     1: pw.FlexColumnWidth(3), // Description
  //                     2: pw.FlexColumnWidth(1.5), // Unit
  //                     3: pw.FlexColumnWidth(1.5), // Quantity
  //                     4: pw.FlexColumnWidth(1.5), // Rate
  //                     5: pw.FlexColumnWidth(1.2), // VAT
  //                     6: pw.FlexColumnWidth(2), // Amount Excl. VAT
  //                     7: pw.FlexColumnWidth(2), // Amount Incl. VAT
  //                   },
  //                   children: [
  //                     /// Table Header
  //                     pw.TableRow(
  //                       decoration: pw.BoxDecoration(),
  //                       children: [
  //                         'SL No',
  //                         'Description of Goods',
  //                         'Unit',
  //                         'Qty',
  //                         'Rate',
  //                         'VAT',
  //                         'Amount Excl. VAT',
  //                         'Amount Incl. VAT',
  //                       ].map((text) {
  //                         return pw.Padding(
  //                           padding: const pw.EdgeInsets.all(5),
  //                           child: pw.Text(text,
  //                               style: pw.TextStyle(
  //                                   fontWeight: pw.FontWeight.bold)),
  //                         );
  //                       }).toList(),
  //                     ),

  //                     /// Data Rows
  //                     ...items.asMap().entries.map((entry) {
  //                       int index = entry.key + (page * rowsPerPage) + 1;
  //                       final item = entry.value;
  //                       final qty = double.tryParse(item.qty) ?? 0;
  //                       final rate = double.tryParse(item.price) ?? 0;
  //                       final amount = qty * rate;
  //                       final vat = amount * 0.05;
  //                       final totalWithVat = amount + vat;

  //                       return pw.TableRow(
  //                         children: [
  //                           index.toString(),
  //                           item.productName,
  //                           item.uomCode,
  //                           qty.toStringAsFixed(2),
  //                           rate.toStringAsFixed(2),
  //                           '5%',
  //                           amount.toStringAsFixed(2),
  //                           totalWithVat.toStringAsFixed(2),
  //                         ]
  //                             .map((text) => pw.Padding(
  //                                   padding: const pw.EdgeInsets.all(5),
  //                                   child: pw.Text(text),
  //                                 ))
  //                             .toList(),
  //                       );
  //                     }),

  //                     /// Total Row (only on last page)
  //                     /// Total Row (only on last page)
  //                     if (page == pages - 1)
  //                       pw.TableRow(
  //                         decoration: pw.BoxDecoration(),
  //                         children: [
  //                           pw.SizedBox(), // SL No - leave empty

  //                           /// "Total" label in 2nd column
  //                           pw.Padding(
  //                             padding: const pw.EdgeInsets.all(5),
  //                             child: pw.Text('Total',
  //                                 style: pw.TextStyle(
  //                                     fontWeight: pw.FontWeight.bold)),
  //                           ),

  //                           /// Empty cells (3rd to 6th column)
  //                           pw.SizedBox(),
  //                           pw.SizedBox(),
  //                           pw.SizedBox(),
  //                           pw.SizedBox(),

  //                           /// Subtotal
  //                           pw.Padding(
  //                             padding: const pw.EdgeInsets.all(5),
  //                             child: pw.Text(
  //                               subTotal.toStringAsFixed(2),
  //                               style: pw.TextStyle(
  //                                   fontWeight: pw.FontWeight.bold),
  //                             ),
  //                           ),

  //                           /// Grand Total
  //                           pw.Padding(
  //                             padding: const pw.EdgeInsets.all(5),
  //                             child: pw.Text(
  //                               (subTotal + totalVat).toStringAsFixed(2),
  //                               style: pw.TextStyle(
  //                                   fontWeight: pw.FontWeight.bold),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                   ],
  //                 ),

  //                 pw.SizedBox(height: 20),

  //                 /// Totals Section (Only on last page)
  //                 if (page == pages - 1)
  //                   pw.Align(
  //                     alignment: pw.Alignment.centerRight,
  //                     child: pw.Column(
  //                       crossAxisAlignment: pw.CrossAxisAlignment.end,
  //                       children: [
  //                         pw.Text(
  //                             'Amount Excl. VAT: ${subTotal.toStringAsFixed(2)} AED'),
  //                         pw.Text(
  //                             'VAT @ 5%: ${totalVat.toStringAsFixed(2)} AED'),
  //                         pw.Text(
  //                             'Total Amount: ${grandTotal.toStringAsFixed(2)} AED',
  //                             style:
  //                                 pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //                         pw.SizedBox(height: 10),
  //                         pw.Text('Amount in words: $totalInWords AED Only'),
  //                       ],
  //                     ),
  //                   ),

  //                 if (page == pages - 1) ...[
  //                   pw.SizedBox(height: 20),
  //                   pw.Text('Declaration:',
  //                       style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //                   pw.Text(
  //                       'We declare that this invoice shows the actual price of the goods described and that all particulars are true.'),
  //                   pw.SizedBox(height: 20),
  //                   pw.Text('Goods received in good condition'),
  //                   pw.SizedBox(height: 50),
  //                   pw.Text('Authorized Signature __________________'),
  //                 ],
  //               ],
  //             ),
  //           ];
  //         },
  //       ),
  //     );
  //   }

  //   final outputDir = await getTemporaryDirectory();
  //   final outputFile = File('${outputDir.path}/invoice.pdf');
  //   await outputFile.writeAsBytes(await pdf.save());

  //   setState(() {
  //     pdfFile = outputFile;
  //     pdfController =
  //         PdfControllerPinch(document: PdfDocument.openFile(pdfFile!.path));
  //   });
  // }

  // Future<void> _generatePDF() async {
  //   final today = DateFormat('dd/MM/yyyy').format(DateTime.now());
  //   final pdf = pw.Document();
  //   final subTotal = _calculateSubTotal();

  //   final totalVat = _calculateVatTotal();
  //   final totalInWords = _convertToWords((subTotal) - (0));
  //   // Determine the maximum number of rows that fit on a single page
  //   const int rowsPerPage = 15; // Adjust this number as needed
  //   final pages = (widget.dataList.length / rowsPerPage).ceil();

  //   for (var page = 0; page < pages; page++) {
  //     // Get the items for the current page
  //     final items =
  //         widget.dataList.skip(page * rowsPerPage).take(rowsPerPage).toList();

  //     pdf.addPage(
  //       pw.MultiPage(
  //         build: (pw.Context context) {
  //           return [
  //             pw.Column(
  //               crossAxisAlignment: pw.CrossAxisAlignment.start,
  //               children: [
  //                 if (page == 0) ...[
  //                   pw.SizedBox(height: 20),
  //                   // Header (company details) - Only on the first page
  //                   pw.Row(
  //                     mainAxisAlignment: pw.MainAxisAlignment.center,
  //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                     children: [
  //                       pw.Text('DELIVERY NOTE',
  //                           style: pw.TextStyle(
  //                               fontSize: 24, fontWeight: pw.FontWeight.bold)),
  //                       pw.SizedBox(height: 5),
  //                     ],
  //                   ),
  //                   pw.SizedBox(height: 10),

  //                   // Customer information - Only on the first page
  //                   pw.Row(
  //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         pw.Container(
  //                             padding: const pw.EdgeInsets.all(8),
  //                             decoration: pw.BoxDecoration(
  //                               border: pw.Border.all(width: 1),
  //                               borderRadius: pw.BorderRadius.circular(4),
  //                             ),
  //                             child: pw.SizedBox(
  //                               width: 80,
  //                               child: pw.Column(
  //                                 crossAxisAlignment:
  //                                     pw.CrossAxisAlignment.start,
  //                                 children: [
  //                                   pw.Text('Bill To:'),
  //                                   pw.Text(widget.customerName,
  //                                       style: pw.TextStyle(
  //                                           fontWeight: pw.FontWeight.bold)),
  //                                 ],
  //                               ),
  //                             )),
  //                         pw.Container(
  //                           padding: const pw.EdgeInsets.all(8),
  //                           decoration: pw.BoxDecoration(
  //                             border: pw.Border.all(width: 1),
  //                             borderRadius: pw.BorderRadius.circular(4),
  //                           ),
  //                           child: pw.Column(
  //                             crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                             children: [
  //                               pw.Text('LPO Number: ${widget.lpoNumber}'),
  //                               pw.Text('Invoice Date: $today'),
  //                             ],
  //                           ),
  //                         ),
  //                       ]),

  //                   pw.SizedBox(height: 28),
  //                 ],

  //                 // Item table
  //                 pw.Table(
  //                   border: pw.TableBorder.all(width: 0.5),
  //                   children: [
  //                     pw.TableRow(
  //                       children: [
  //                         pw.Padding(
  //                           padding: const pw.EdgeInsets.all(8.0),
  //                           child: pw.Text('S.No',
  //                               style: pw.TextStyle(
  //                                   fontWeight: pw.FontWeight.bold)),
  //                         ),
  //                         pw.Padding(
  //                           padding: const pw.EdgeInsets.all(8.0),
  //                           child: pw.Text('ITEM & DESCRIPTION',
  //                               style: pw.TextStyle(
  //                                   fontWeight: pw.FontWeight.bold)),
  //                         ),
  //                         pw.Padding(
  //                           padding: const pw.EdgeInsets.all(8.0),
  //                           child: pw.Text('UNIT',
  //                               style: pw.TextStyle(
  //                                   fontWeight: pw.FontWeight.bold)),
  //                         ),
  //                         pw.Padding(
  //                           padding: const pw.EdgeInsets.all(8.0),
  //                           child: pw.Text('QTY',
  //                               style: pw.TextStyle(
  //                                   fontWeight: pw.FontWeight.bold)),
  //                         ),
  //                         pw.Padding(
  //                           padding: const pw.EdgeInsets.all(8.0),
  //                           child: pw.Text('RATE',
  //                               style: pw.TextStyle(
  //                                   fontWeight: pw.FontWeight.bold)),
  //                         ),
  //                         pw.Padding(
  //                           padding: const pw.EdgeInsets.all(8.0),
  //                           child: pw.Text('AMOUNT',
  //                               style: pw.TextStyle(
  //                                   fontWeight: pw.FontWeight.bold)),
  //                         ),
  //                       ],
  //                     ),
  //                     ...items.asMap().entries.map((entry) {
  //                       // ...items.map((item) {
  //                       int index = entry.key + (page * rowsPerPage) + 1;
  //                       final item = entry.value;
  //                       final total =
  //                           double.parse(item.price) * double.parse(item.qty);
  //                       return pw.TableRow(
  //                         children: [
  //                           pw.Padding(
  //                             padding: const pw.EdgeInsets.all(8.0),
  //                             child: pw.Text(index.toString()),
  //                           ),
  //                           pw.Padding(
  //                             padding: const pw.EdgeInsets.all(8.0),
  //                             child: pw.Text(item.productName),
  //                           ),
  //                           pw.Padding(
  //                             padding: const pw.EdgeInsets.all(8.0),
  //                             child: pw.Text(item.uomCode),
  //                           ),
  //                           pw.Padding(
  //                             padding: const pw.EdgeInsets.all(8.0),
  //                             child: pw.Text(
  //                                 double.parse(item.qty).toStringAsFixed(2)),
  //                           ),
  //                           pw.Padding(
  //                             padding: const pw.EdgeInsets.all(8.0),
  //                             child: pw.Text(
  //                                 double.parse(item.price).toStringAsFixed(2)),
  //                           ),
  //                           pw.Padding(
  //                             padding: const pw.EdgeInsets.all(8.0),
  //                             child: pw.Text(total.toStringAsFixed(2)),
  //                           ),
  //                         ],
  //                       );
  //                     }).toList(),
  //                   ],
  //                 ),
  //                 pw.SizedBox(height: 20),

  //                 // Footer with totals (only on last page)
  //                 if (page == pages - 1)
  //                   pw.Row(
  //                     mainAxisAlignment: pw.MainAxisAlignment.end,
  //                     children: [
  //                       pw.Column(
  //                         crossAxisAlignment: pw.CrossAxisAlignment.end,
  //                         children: [
  //                           pw.Text(
  //                               'Sub Total: ${subTotal.toStringAsFixed(2)} AED'),
  //                           pw.SizedBox(height: 5),
  //                           pw.Text(
  //                               'Total: ${((subTotal) + (totalVat)).toStringAsFixed(2)} AED',
  //                               style: pw.TextStyle(
  //                                   fontWeight: pw.FontWeight.bold)),
  //                           pw.SizedBox(height: 20),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 if (page == pages - 1) ...[
  //                   pw.SizedBox(height: 20),
  //                   pw.Text('Notes'),
  //                   pw.SizedBox(height: 10),
  //                   pw.Text('Thanks for your business'),
  //                   pw.SizedBox(height: 50),
  //                   pw.Text('Authorized Signature __________________'),
  //                 ],
  //               ],
  //             ),
  //           ];
  //         },
  //       ),
  //     );
  //   }

  //   final outputDir = await getTemporaryDirectory();
  //   final outputFile = File('${outputDir.path}/invoice.pdf');
  //   await outputFile.writeAsBytes(await pdf.save());

  //   setState(() {
  //     pdfFile = outputFile;
  //     pdfController =
  //         PdfControllerPinch(document: PdfDocument.openFile(pdfFile!.path));
  //   });
  // }

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
            style: const TextStyle(
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
                    Navigator.pop(context, device); // Return selected printer
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
      log('No printer selected.');
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

    // Function to right-align text with left margin
    String rightAlignText(String text) {
      int padding = totalWidth - text.length - leftMarginSpaces;
      return '$leftMargin${' ' * padding}$text';
    }

    // **Company Header**
    // **Company Header**
    // bytes += generator.text(
    //     centerText(
    //       widget.companyname,
    //       // 'RAFA INTERNATIONAL GENERAL TRADING LLC'
    //     ),
    //     styles: const PosStyles(height: PosTextSize.size2, bold: true));
    // bytes += generator.text(
    //   centerText(
    //     '${widget.state},${widget.country}',
    //     // 'DUBAI- UAE'
    //   ),
    // );
    // bytes += generator.text(
    //   centerText(
    //     'TRN No: ${widget.trnno}',
    //     // 'TRN: 100241961000003'
    //   ),
    // );
    bytes += generator.text('-' * totalWidth); // Divider line

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
    int nameWidth = 20; // 25 Item name (largest)
    int qtyWidth = 7; // Quantity
    int rateWidth = 10; // Rate
    int amountWidth = 14; // Amount

    String headers = '$leftMargin${'S.No'.padRight(snoWidth)}'
        '$leftMargin${'ITEM'.padRight(nameWidth)}'
        '${'QTY'.padLeft(qtyWidth)}'
        '${'RATE'.padLeft(rateWidth)}'
        // '${'VAT'.padLeft(rateWidth)}'
        '${'AMOUNT'.padLeft(amountWidth)}';

    bytes += generator.text(headers, styles: const PosStyles(bold: true));
    bytes += generator.text(
        '$leftMargin${'-' * (totalWidth - leftMarginSpaces)}'); // Line separator

    // **Print Items with Proper Spacing**
    // Items loop with serial number
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

    bytes += generator.text(
      rightAlignText('Total: ${_calculateSubTotal().toStringAsFixed(2)} AED'),
      styles: const PosStyles(bold: true),
    );

    // double vat = _calculateSubTotal() * 0.05; // Example: 5% VAT
    double grandTotal = _calculateSubTotal();
    //  + vat;

    // bytes += generator.text(rightAlignText('Total VAT: ${vat.toStringAsFixed(2)} AED'));
    bytes += generator.text(
      rightAlignText('Grand Total: ${grandTotal.toStringAsFixed(2)} AED'),
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
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   onPressed: () async {
      //     if (await requestPrintingPermissions(context)) {
      //       await scanAndPrint(context);
      //     }
      //   },
      //   child: const Icon(Icons.print),
      // ),
    );
  }

  @override
  void dispose() {
    pdfController?.dispose();
    super.dispose();
  }
}
