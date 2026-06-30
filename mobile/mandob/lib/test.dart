// import 'dart:io';
// import 'package:almandob/Widgets/biometric_card.dart';
// import 'package:flutter/material.dart';

// class BiometricScanPage extends StatefulWidget {
//   const BiometricScanPage({super.key});

//   @override
//   State<BiometricScanPage> createState() => _BiometricScanPageState();
// }

// class _BiometricScanPageState extends State<BiometricScanPage> {
//   BiometricCardData? scannedData;
//   String error = '';
//   Future<void> scan() async {
//     scannedData = await scanBiometricCardWithApiKey('YOUR_GOOGLE_API_KEY');
//     setState(() {}); // تحدث الواجهة عشان تظهر البيانات الجديدة
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("مسح البطاقة")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             ElevatedButton(
//               onPressed: scan,
//               child: const Text("📷 امسح البطاقة"),
//             ),
//             if (error.isNotEmpty) ...[
//               const SizedBox(height: 10),
//               Text(error, style: const TextStyle(color: Colors.red)),
//             ],
//             if (scannedData != null) ...[
//               if (scannedData!.frontImagePath.isNotEmpty) Image.file(File(scannedData!.frontImagePath)),
//               if (scannedData!.backImagePath.isNotEmpty) Image.file(File(scannedData!.backImagePath)),
//               Text("${scannedData!.fullName}")
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }
