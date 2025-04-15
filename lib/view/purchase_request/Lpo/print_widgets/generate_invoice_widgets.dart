//  import 'dart:io';

// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdfx/pdfx.dart';

// Future<void> generatePDF(widget) async {
//     final today = DateFormat('dd/MM/yyyy').format(DateTime.now());
//     final pdf = pw.Document();
//     final subTotal = _calculateSubTotal();
//     final totalQty = _calculateQtyTotal();
//     final totalVat = _calculateVatTotal();
//     final totalInWords = _convertToWords((subTotal) - (0));
//     // Determine the maximum number of rows that fit on a single page
//     const int rowsPerPage = 15; // Adjust this number as needed
//     final pages = (widget.dataList.length / rowsPerPage).ceil();

//     for (var page = 0; page < pages; page++) {
//       // Get the items for the current page
//       final items =
//           widget.dataList.skip(page * rowsPerPage).take(rowsPerPage).toList();

//       pdf.addPage(
//         pw.MultiPage(
//           build: (pw.Context context) {
//             return [
//               pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   if (page == 0) ...[
//                     pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.center,
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Text(widget.header.printHeader,
//                               style: pw.TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: pw.FontWeight.bold)),
//                         ]),
//                     pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.center,
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Text(
//                               '${widget.header.state},${widget.header.country}',
//                               style: pw.TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: pw.FontWeight.bold)),
//                         ]),

//                     pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.center,
//                         crossAxisAlignment: pw.CrossAxisAlignment.start,
//                         children: [
//                           pw.Text('TRN NO: ${widget.header.trnNo}',
//                               style: pw.TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: pw.FontWeight.bold)),
//                         ]),
//                     pw.SizedBox(height: 20),

//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [],
//                         ),
//                         pw.Text('DELIVERY NOTE',
//                             style: pw.TextStyle(
//                                 fontSize: 24, fontWeight: pw.FontWeight.bold)),
//                         pw.SizedBox(height: 5),
//                       ],
//                     ),
//                     pw.SizedBox(height: 10),

//                     // Customer information - Only on the first page
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.Text('Bill To:'),
//                             pw.Text(widget.customerName,
//                                 style: pw.TextStyle(
//                                     fontWeight: pw.FontWeight.bold)),
//                           ],
//                         ),
//                         pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.Text(
//                               'LPO Number: ${widget.lpoNumber}',
//                             ),
//                             pw.Text('Invoice Date: $today'),
//                             // pw.Text('Due Date: $today'),
//                             // pw.Text('Terms: Due on Receipt'),
//                           ],
//                         ),
//                       ],
//                     ),
//                     pw.SizedBox(height: 28),
//                   ],

//                   // Item table
//                   pw.Table(
//                     border: pw.TableBorder.all(width: 0.5),
//                     children: [
//                       pw.TableRow(
//                         children: [
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(8.0),
//                             child: pw.Text('ITEM & DESCRIPTION',
//                                 style: pw.TextStyle(
//                                     fontWeight: pw.FontWeight.bold)),
//                           ),
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(8.0),
//                             child: pw.Text('UNIT',
//                                 style: pw.TextStyle(
//                                     fontWeight: pw.FontWeight.bold)),
//                           ),
//                           pw.Padding(
//                             padding: const pw.EdgeInsets.all(8.0),
//                             child: pw.Text('QTY',
//                                 style: pw.TextStyle(
//                                     fontWeight: pw.FontWeight.bold)),
//                           ),
//                           // pw.Padding(
//                           //   padding: const pw.EdgeInsets.all(8.0),
//                           //   child: pw.Text('RATE',
//                           //       style: pw.TextStyle(
//                           //           fontWeight: pw.FontWeight.bold)),
//                           // ),
//                           // pw.Padding(
//                           //   padding: const pw.EdgeInsets.all(8.0),
//                           //   child: pw.Text('VAT',
//                           //       style: pw.TextStyle(
//                           //           fontWeight: pw.FontWeight.bold)),
//                           // ),
//                           // pw.Padding(
//                           //   padding: const pw.EdgeInsets.all(8.0),
//                           //   child: pw.Text('AMOUNT',
//                           //       style: pw.TextStyle(
//                           //           fontWeight: pw.FontWeight.bold)),
//                           // ),
//                         ],
//                       ),
//                       ...items.map((item) {
//                         final total =
//                             double.parse(item.price) * double.parse(item.qty);
//                         return pw.TableRow(
//                           children: [
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(8.0),
//                               child: pw.Text(item.productName),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(8.0),
//                               child: pw.Text(item.uomCode),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(8.0),
//                               child: pw.Text(
//                                   double.parse(item.qty).toStringAsFixed(2)),
//                             ),
//                             // pw.Padding(
//                             //   padding: const pw.EdgeInsets.all(8.0),
//                             //   child: pw.Text(
//                             //       double.parse(item.price).toStringAsFixed(2)),
//                             // ),
//                             // pw.Padding(
//                             //   padding: const pw.EdgeInsets.all(8.0),
//                             //   child: pw.Text(
//                             //       double.parse(item.vat).toStringAsFixed(2)),
//                             // ),
//                             // pw.Padding(
//                             //   padding: const pw.EdgeInsets.all(8.0),
//                             //   child: pw.Text(total.toStringAsFixed(2)),
//                             // ),
//                           ],
//                         );
//                       }).toList(),
//                     ],
//                   ),
//                   pw.SizedBox(height: 20),

//                   // Footer with totals (only on last page)
//                   if (page == pages - 1)
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.end,
//                       children: [
//                         pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.end,
//                           children: [
//                             // pw.Text(
//                             //     'Sub Total: ${subTotal.toStringAsFixed(2)} AED'),
//                             // pw.SizedBox(height: 5),
//                             // pw.Text(
//                             //     'Total Vat: ${totalVat.toStringAsFixed(2)} AED'),
//                             pw.SizedBox(height: 5),
//                             pw.Text('Total Quantity:${totalQty.toStringAsFixed(2)}',
//                                 //  ${((subTotal) + (totalVat)).toStringAsFixed(2)} AED',
//                                 style: pw.TextStyle(
//                                     fontWeight: pw.FontWeight.bold)),
//                             pw.SizedBox(height: 20),
//                             // pw.Text('Total In Words: $totalInWords'),
//                           ],
//                         ),
//                       ],
//                     ),
//                   if (page == pages - 1) ...[
//                     pw.SizedBox(height: 20),
//                     pw.Text('Notes'),
//                     pw.SizedBox(height: 10),
//                     pw.Text('Thanks for your business'),
//                     pw.SizedBox(height: 50),
//                     pw.Text('Authorized Signature __________________'),
//                   ],
//                 ],
//               ),
//             ];
//           },
//         ),
//       );
//     }

//     final outputDir = await getTemporaryDirectory();
//     final outputFile = File('${outputDir.path}/invoice.pdf');
//     await outputFile.writeAsBytes(await pdf.save());

//     setState(() {
//       pdfFile = outputFile;
//       pdfController =
//           PdfControllerPinch(document: PdfDocument.openFile(pdfFile!.path));
//     });
//   }

//    double _calculateSubTotal() {
//     return widget.dataList.fold(0.0, (sum, item) {
//       return sum + (double.parse(item.price) * double.parse(item.qty));
//     });
//   }

//   double _calculateQtyTotal() {
//     return widget.dataList.fold(0.0, (sum, item) {
//       return sum + (double.parse(item.qty));
//     });
//   }

//   double _calculateVatTotal() {
//     return widget.dataList.fold(0.0, (sum, item) {
//       return sum + (double.parse(item.vat));
//     });
//   }

//   String _convertToWords(double amount) {
//     if (amount == 0) return "Zero ";

//     int rupees = amount.toInt();
//     String words = NumberToWord().convert('en-in', rupees);

//     return '${words[0].toUpperCase()}${words.substring(1)}';
//   }