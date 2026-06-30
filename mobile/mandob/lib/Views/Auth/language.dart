import 'package:almandobUAE/Views/Auth/login.dart';
import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ListView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: [
          Image.asset(
            'images/frame1.png',
            width: double.infinity,
            height: Get.height * 0.5,
            fit: BoxFit.cover,
          ),
          Center(
            child: HeadingText(text: "- اختر اللغة -"),
          ),
          SizedBox(
            height: 10,
          ),

          //arabic lang %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CustomColors.primary,
                  CustomColors.secendory,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // لون داخل الحاوية
                borderRadius: BorderRadius.circular(12), // نفس الشكل لكن أقل قليلاً
              ),
              child: ListTile(
                title: bodytext(text: "العربية"),
                trailing: Image(
                  image: AssetImage("icons/iraq.png"),
                  width: 40,
                  height: 40,
                ),
                leading: Radio.adaptive(
                    activeColor: Colors.green,
                    focusColor: Colors.green,
                    value: true,
                    groupValue: () {},
                    onChanged: (val) {
                      val = true;
                    }),
              ),
            ),
          ),
          //end of arabic lang %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

          // english lang %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CustomColors.primary,
                  CustomColors.secendory,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // لون داخل الحاوية
                borderRadius: BorderRadius.circular(12), // نفس الشكل لكن أقل قليلاً
              ),
              child: ListTile(
                title: bodytext(text: "الانجليزية"),
                trailing: Image(
                  image: AssetImage("icons/uk.png"),
                  width: 40,
                  height: 40,
                ),
                leading: Radio.adaptive(
                    activeColor: Colors.green,
                    focusColor: Colors.green,
                    value: true,
                    groupValue: () {},
                    onChanged: (val) {
                      val = true;
                    }),
              ),
            ),
          ),
          //end of english lang %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

          // turk lang %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CustomColors.primary,
                  CustomColors.secendory,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // لون داخل الحاوية
                borderRadius: BorderRadius.circular(12), // نفس الشكل لكن أقل قليلاً
              ),
              child: ListTile(
                title: bodytext(text: "التركية"),
                trailing: Image(
                  image: AssetImage("icons/turk.png"),
                  width: 40,
                  height: 40,
                ),
                leading: Radio.adaptive(
                    activeColor: Colors.green,
                    focusColor: Colors.green,
                    value: true,
                    groupValue: () {},
                    onChanged: (val) {
                      val = true;
                    }),
              ),
            ),
          ),
          //end of turk lang %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

          InkWell(
            onTap: () {
              Get.to(Login(), transition: Transition.rightToLeft);
            },
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 20),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CustomColors.primary),
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
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 10,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: CircleAvatar(
                backgroundColor: CustomColors.primary,
                child: Icon(
                  Icons.headphones_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
