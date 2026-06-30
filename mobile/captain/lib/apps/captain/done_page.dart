import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shahenco_captain/apps/captain/home_page.dart';

class DonePage extends StatelessWidget {
  final String? title;
  final String? message;

  DonePage({
    Key? key,
    this.title,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
      
                  SizedBox(height: 32),
      
                  // Title
                  Text(
                    title ?? 'Success!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
      
                  SizedBox(height: 16),
      
                  // Message
                  Text(
                    message ?? 'تم الانتهاء من هذه الخطوة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[700],
                    ),
                  ),
      
                  SizedBox(height: 40),
      
                  // Back Button
                  ElevatedButton(
                    onPressed: () => Get.offAll(()=>CaptainHome()),
                    child: Text('الرئيسية'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}