import 'dart:math';

import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:almandobUAE/Widgets/colors.dart';

class AdvancedBarcodeScanner extends StatefulWidget {
  @override
  _AdvancedBarcodeScannerState createState() => _AdvancedBarcodeScannerState();
}

class _AdvancedBarcodeScannerState extends State<AdvancedBarcodeScanner> {
  MobileScannerController cameraController = MobileScannerController();
  String? scannedBarcode;
  bool isFlashOn = false;
  bool isCameraFront = false;

  String? selectedAccountType;
  Map<String, String> accountTypes = {
    "سائق": 'captain',
    "مستخدم": 'user',
    "تاجر": 'company',
    "ناقل": 'deliverycompany',
    "سيارة": 'car',
  };

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  var net = Network(auth: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('الماسح الضوئي المتقدم', style: TextStyle(color: Colors.white)),
        backgroundColor: CustomColors.primary,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
            onPressed: () {
              setState(() {
                isFlashOn = !isFlashOn;
              });
              cameraController.toggleTorch();
            },
          ),
          IconButton(
            icon: Icon(Icons.cameraswitch, color: Colors.white),
            onPressed: () {
              setState(() {
                isCameraFront = !isCameraFront;
              });
              cameraController.switchCamera();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                setState(() {
                  scannedBarcode = barcodes.first.rawValue;
                });
                // Get.snackbar(
                //   'تم المسح بنجاح',
                //   scannedBarcode!,
                //   backgroundColor: CustomColors.primary.withOpacity(0.9),
                //   colorText: Colors.white,
                //   duration: Duration(seconds: 2),
                // );
              }
            },
          ),

          // مربع المسح السحري
          CustomPaint(
            painter: ScannerOverlay(
              borderColor: CustomColors.primary,
              scannedBarcode: scannedBarcode,
            ),
          ),

          // نتيجة المسح في الأسفل
          if (scannedBarcode != null)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: CustomColors.primary, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      'تم مسح الباركود:',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      scannedBarcode!,
                      style: TextStyle(
                        color: CustomColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'اختر نوع الحساب',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: accountTypes.keys.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAccountType = accountTypes[value!];
                        });
                        print("النوع المختار: $value = $selectedAccountType");
                      },
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedAccountType != null) {
                          try {
                            var status = await net.postHttp(Links.history, {
                              'type': selectedAccountType,
                              "is_active": true,
                              "barcode": scannedBarcode,
                              "mandob": GetStorage().read('id')
                            });
                            if (status.statusCode == 200 || status.statusCode == 201 || status.statusCode == 204) {
                              print("نجح");
                              Get.back();
                              Get.snackbar(
                                'تهانينا',
                                'تم الارسال بنجاح',
                                backgroundColor: CustomColors.primary,
                                colorText: Colors.white,
                              );

                              print(status.statusCode);
                            } else {
                              Get.snackbar(
                                'فشل الارسال',
                                'يرجى التحقق من الباركود المرسل ليس نفس الباركود السابق',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              print("فشل الارسال");
                              print(status.statusCode);
                            }
                          } catch (e) {
                            Get.snackbar("هنالك خطا بالاتصال", "$e");
                          }
                        } else {
                          Get.snackbar(
                            'تنبيه',
                            'الرجاء اختيار نوع الحساب',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        iconColor: CustomColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      child: Text('ارسال', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  final Color borderColor;
  final String? scannedBarcode;

  ScannerOverlay({required this.borderColor, this.scannedBarcode});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final centerX = width / 2;
    final centerY = height / 2;
    final scanArea = min(width, height) * 0.6;
    final left = centerX - scanArea / 2;
    final top = centerY - scanArea / 2;
    final right = centerX + scanArea / 2;
    final bottom = centerY + scanArea / 2;

    // رسم طبقة شبه شفافة خارج منطقة المسح
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.5);
    canvas.drawRect(Rect.fromLTRB(0, 0, width, top), backgroundPaint);
    canvas.drawRect(Rect.fromLTRB(0, top, left, bottom), backgroundPaint);
    canvas.drawRect(Rect.fromLTRB(right, top, width, bottom), backgroundPaint);
    canvas.drawRect(Rect.fromLTRB(0, bottom, width, height), backgroundPaint);

    // رسم حدود مربع المسح مع تأثير متحرك
    final borderPaint = Paint()
      ..color = scannedBarcode != null ? Colors.green : borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..shader = LinearGradient(
        colors: [
          borderColor.withOpacity(0.1),
          borderColor,
          borderColor.withOpacity(0.1),
        ],
      ).createShader(Rect.fromLTRB(left, top, right, bottom));

    // رسم مربع المسح
    final path = Path()
      ..moveTo(left, top + 30)
      ..lineTo(left, top)
      ..lineTo(left + 30, top)
      ..moveTo(right - 30, top)
      ..lineTo(right, top)
      ..lineTo(right, top + 30)
      ..moveTo(right, bottom - 30)
      ..lineTo(right, bottom)
      ..lineTo(right - 30, bottom)
      ..moveTo(left + 30, bottom)
      ..lineTo(left, bottom)
      ..lineTo(left, bottom - 30);

    canvas.drawPath(path, borderPaint);

    // تأثير مسح متحرك إذا لم يتم مسح أي كود بعد
    if (scannedBarcode == null) {
      final animationPaint = Paint()
        ..color = borderColor.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      final animationHeight = 20.0;
      final animationOffset = (DateTime.now().millisecond / 1000) * (bottom - top - animationHeight);

      canvas.drawRect(
        Rect.fromLTRB(
          left + 10,
          top + 10 + animationOffset,
          right - 10,
          top + 10 + animationHeight + animationOffset,
        ),
        animationPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
