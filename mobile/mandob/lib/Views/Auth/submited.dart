import 'package:almandobUAE/Views/Auth/login.dart';
import 'package:almandobUAE/Views/Auth/otp.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/frame.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Submited extends StatefulWidget {
  const Submited({super.key});

  @override
  State<Submited> createState() => _SubmitedState();
}

class _SubmitedState extends State<Submited> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            bodytext(text: "هل تواجه مشكلة ؟ "),
            bodytext(
              text: "تواصل معنا",
              textColor: CustomColors.primary,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: [
          InkWell(
              onTap: () {
                print("${GetStorage().read("id")}");
                print("${GetStorage().read("token")}");
                print("${GetStorage().read("status")}");
              },
              child: frameWidget("images/frame1.png")),
          Container(
            height: 200,
            decoration: BoxDecoration(color: Colors.white, image: DecorationImage(image: AssetImage("icons/noconnect.png"), fit: BoxFit.scaleDown)),
          ),
          Center(child: bodytext(text: "حسابك قيد المراجعة")),
          InkWell(
            onTap: () {
              net.logout();
              Get.offAll(Login());
            },
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CustomColors.primary,
              ),
              height: Get.height * 0.06,
              child: Center(
                child: bodytext(
                  fontWeight: FontWeight.w400,
                  text: "تسجيل الخروج",
                  textColor: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
