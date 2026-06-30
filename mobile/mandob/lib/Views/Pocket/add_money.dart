import 'package:almandobUAE/Views/Pocket/pay_visa.dart';
import 'package:almandobUAE/Widgets/appbar.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMoney extends StatefulWidget {
  const AddMoney({super.key});

  @override
  State<AddMoney> createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "تعبئة الرصيد",
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
          Container(
            margin: EdgeInsets.all(10),
            height: Get.height * 0.3,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color.fromARGB(139, 85, 85, 85)),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15, right: 10),
                  child: HeadingText(
                    text: "المحفظة",
                    textColor: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.05),
                  child: Center(
                    child: HeadingText(
                      text: "150.000 IQD",
                      textColor: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  title: bodytext(
                    text: "الاسم :",
                    textColor: Colors.white,
                  ),
                  trailing: bodytext(
                    text: "رقم الحساب :",
                    textColor: Colors.white,
                  ),
                ),
                ListTile(
                  title: bodytext(
                    text: "احمد مهدي صالح",
                    textColor: Colors.white,
                  ),
                  trailing: bodytext(
                    text: "547896145632",
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: Get.height * 0.3,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: CustomColors.primary),
            child: ListView(physics: NeverScrollableScrollPhysics(), shrinkWrap: true, children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: HeadingText(
                    text: "اضف كود الرصيد",
                    textColor: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                height: Get.height * 0.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: CustomColors.secendory,
                ),
                child: Center(
                  child: TextFormField(
                    style: TextStyle(fontFamily: "font"),
                    textAlign: TextAlign.center, // لتوسيط النص أفقيًا
                    textAlignVertical: TextAlignVertical.center, // لتوسيط المؤشر والنص عموديًا
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontFamily: "font"),
                      hintText: "ادخل الكود هنا",
                    ),
                  ),
                ),
              ),
              Container(
                height: Get.height * 0.06,
                margin: EdgeInsets.only(left: Get.width * 0.2, right: Get.width * 0.2, top: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFF37816A)),
                child: Center(
                  child: bodytext(
                    text: "تاكيد",
                    textColor: Colors.white,
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(PayVisa());
                      },
                      child: bodytext(
                        text: "هل لديك بطاقة ؟   ",
                        textColor: Colors.white,
                      ),
                    ),
                    Image(image: AssetImage("icons/visa.png")),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Image(image: AssetImage("icons/master.png")),
                    )
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
