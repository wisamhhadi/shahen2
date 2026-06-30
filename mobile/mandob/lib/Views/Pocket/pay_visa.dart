import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayVisa extends StatefulWidget {
  const PayVisa({super.key});

  @override
  State<PayVisa> createState() => _PayVisaState();
}

class _PayVisaState extends State<PayVisa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "تعبئة البطاقة",
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 10),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColors.secendory,
                    CustomColors.primary,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(fontFamily: "font"),
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontFamily: "font",
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          hintText: "الاسم بالبطاقة  (CardHolderName)",
                          border: InputBorder.none),
                    ),
                  ))),
          Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 10),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColors.secendory,
                    CustomColors.primary,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(fontFamily: "font"),
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontFamily: "font",
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          hintText: "رقم البطاقة   (CardNumber)",
                          border: InputBorder.none),
                    ),
                  ))),
          Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 10),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColors.secendory,
                    CustomColors.primary,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(fontFamily: "font"),
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontFamily: "font",
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          hintText: "تاريخ الانتهاء ",
                          border: InputBorder.none),
                    ),
                  ))),
          Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 10),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColors.secendory,
                    CustomColors.primary,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(fontFamily: "font"),
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontFamily: "font",
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          hintText: "رمز التحقق  (CVV or CVC)",
                          border: InputBorder.none),
                    ),
                  ))),
          Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 10),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColors.secendory,
                    CustomColors.primary,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(fontFamily: "font"),
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontFamily: "font",
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          hintText: "الرمز البريدي  (ZIP code)",
                          border: InputBorder.none),
                    ),
                  ))),
          Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 10),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColors.secendory,
                    CustomColors.primary,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(fontFamily: "font"),
                      decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontFamily: "font",
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          hintText: "المدينة  (City)",
                          border: InputBorder.none),
                    ),
                  ))),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CustomColors.primary),
            height: Get.height * 0.06,
            child: Center(
              child: bodytext(
                fontWeight: FontWeight.w400,
                text: "تعبئة",
                textColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
