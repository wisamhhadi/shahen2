import 'dart:math';

import 'package:almandobUAE/Services/links.dart';
import 'package:almandobUAE/Services/network.dart';
import 'package:almandobUAE/Views/Auth/submited.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/dialgoCustom.dart';
import 'package:almandobUAE/Widgets/frame.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/loading.dart';
import 'package:almandobUAE/Widgets/otp_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

var net = Network(auth: false);
TextEditingController pinText = TextEditingController();

class _OtpState extends State<Otp> {
  late String phoneNumber;

  final TextEditingController pin1 = TextEditingController();
  final TextEditingController pin2 = TextEditingController();
  final TextEditingController pin3 = TextEditingController();
  final TextEditingController pin4 = TextEditingController();
  final TextEditingController pin5 = TextEditingController();
  final TextEditingController pin6 = TextEditingController();

  @override
  void dispose() {
    pin1.dispose();
    pin2.dispose();
    pin3.dispose();
    pin4.dispose();
    pin5.dispose();
    pin6.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    phoneNumber = (Get.arguments as String?) ?? 'لم يُرسل رقم';
    sendPin();
  }

  bool isLoading = false;
  bool isSented = false;

  Future<void> sendPin() async {
    setState(() {
      isSented = true;
    });
    try {
      var status = await net.postHttp(Links.mandobLogin, {
        'phone': phoneNumber,
      });
      if (status.statusCode == 200 || status.statusCode == 201 || status.statusCode == 204) {
        print("نجح");
        print(status.statusCode);
      } else {
        print("فشل الارسال");
      }
    } catch (e) {
      Get.snackbar("هنالك خطا بالاتصال", "$e");
    } finally {
      setState(() {
        isSented = false;
      });
      dispose() {
        isSented;
      }
    }
  }

  String get enteredPin => pin6.text + pin5.text + pin4.text + pin3.text + pin2.text + pin1.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: isSented
          ? Center(child: ProfessionalLoadingWidget())
          : ListView(
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(height: Get.height *0.08,) ,
                InkWell(
                  onTap: () {
                    print("PHONE SENT TO API: $phoneNumber");
                  },
               child: CircleAvatar(maxRadius: 150,backgroundImage: AssetImage("icons/UAElogo.png"),)
                ),
                Center(child: bodytext(text: "ادخل الكود الذي تم ارساله الى الرقم")),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: bodytext(text: "$phoneNumber"),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      otpWidget(pin1),
                      otpWidget(pin2),
                      otpWidget(pin3),
                      otpWidget(pin4),
                      otpWidget(pin5),
                      otpWidget(pin6),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      if (enteredPin.length < 6) {
                        Get.snackbar("خطأ", "يرجى إدخال كامل رمز التحقق");
                        return;
                      }

                      var status = await net.login(Links.mandobLogin, {
                        "phone": phoneNumber,
                        "pin": enteredPin,
                      });
                      if (status == 200 || status == 201 || status == 204) {
                        Get.offAll(Submited(), transition: Transition.rightToLeft);
                      } else {
                        print("خطا بتسجيل الدخول");
                        showCustomAwesomeDialog(context: context, title: "ادارة التطبيق", message: "الكود غير صحيح , يرجى ادخال الكود بشكل صحيح", iconHeader: Icons.close_outlined, iconColor: Colors.red);
                        print(status);
                        print(enteredPin);
                      }
                    } catch (e) {
                      Get.snackbar("هنالك خطا بالاتصال", "$e");
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                      dispose() {
                        isLoading;
                      }
                    }
                  },
                  child: isLoading
                      ? Center(child: ProfessionalLoadingWidget())
                      : Container(
                          margin: EdgeInsets.only(left: 15, right: 15, top: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: CustomColors.primary,
                          ),
                          height: Get.height * 0.06,
                          child: Center(
                            child: bodytext(
                              fontWeight: FontWeight.w400,
                              text: "التالي",
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                ),
                SizedBox(height: 10),
              ],
            ),
    );
  }
}
