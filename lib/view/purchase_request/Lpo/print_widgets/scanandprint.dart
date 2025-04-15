//   import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

// Future<void> scanAndPrint(BuildContext context) async {
//     // Scan for paired Bluetooth devices
//     final List<BluetoothInfo> devices =
//         await PrintBluetoothThermal.pairedBluetooths;

//     if (devices.isEmpty) {
//       log('No Bluetooth devices found.');
//       return;
//     }

//     // Convert to list of maps for UI
//     List<Map<String, String>> deviceList = devices
//         .map((device) => {
//               'name': device.name,
//               'macAddress': device.macAdress,
//             })
//         .toList();

//     // Show dialog for printer selection
//     Map<String, String>? selectedPrinter =
//         await showDialog<Map<String, String>>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Select a Printer',
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w700,
//               color: Colors.black,
//             ),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               children: deviceList.map((device) {
//                 return ListTile(
//                   title: Text(
//                     device['name'] ?? 'Unknown',
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black,
//                     ),
//                   ),
//                   subtitle: Text(
//                     device['macAddress'] ?? '',
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black,
//                     ),
//                   ),
//                   onTap: () {
//                     Navigator.pop(context, device);
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//         );
//       },
//     );

//     // If no printer selected, exit function
//     if (selectedPrinter == null) {
//       log(
//         'No printer selected.',
//       );
//       return;
//     }

//     String macAddress = selectedPrinter['macAddress']!.trim();
//     log('Selected Printer: $macAddress');

//     // Check connection status
//     bool isConnected = await PrintBluetoothThermal.connectionStatus;
//     log("Printer connection status: $isConnected");

//     // Connect if not already connected
//     if (!isConnected) {
//       bool connected =
//           await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
//       log('Connection attempt: $connected');

//       isConnected = await PrintBluetoothThermal.connectionStatus;
//     }

//     // Proceed with printing if connected
//     if (isConnected) {
//       List<int> bytes = await generateEscPosInvoice();
//       bool success = await PrintBluetoothThermal.writeBytes(bytes);
//       log(success ? 'Print successful' : 'Print failed');
//     } else {
//       log('Printer not connected. Cannot print.');
//     }
//   }
