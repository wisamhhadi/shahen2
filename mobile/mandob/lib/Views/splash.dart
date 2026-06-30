import 'dart:async';

import 'package:almandobUAE/Views/Auth/language.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:almandobUAE/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  @override
  void initState() {
    super.initState();
    Timer t = new Timer(Duration(seconds: 3), () {
      Get.offAll(CheckPage());
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:Container(
        height: 150, 
        width: Get.width,
        color: CustomColors.primary,
        child: Center(
          child: bodytext(text: "جميع الحقوق محفوظة لشركة التطبيق الذكي 2025",textColor: Colors.white,),
        ),
      ) ,
      backgroundColor: Colors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image(image: AssetImage("icons/UAElogo.png")  , width: 250,fit: BoxFit.cover,)),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ProfessionalLoadingWidget(),
            ),
          )
        ],
      ),
    );
  }
}
