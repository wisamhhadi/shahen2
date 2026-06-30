import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:almandobUAE/Widgets/textbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

Widget ReportQuestion(String question, String time, TextEditingController controler) {
  return Container(
    margin: EdgeInsets.only(top: 15, right: 20, left: 20),
    height: Get.height * 0.2,
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadows: [
        BoxShadow(
          color: Color(0x3F000000),
          blurRadius: 4,
          offset: Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
    ),
    child: ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        ListTile(
          title: bodytext(text: "$question"),
          trailing: bodytext(
            text: "$time",
            textColor: Colors.grey,
          ),
        ),
        TextBoxCustom(
          hintText: "اكتب الجواب هنا",
          controller: controler,
        )
      ],
    ),
  );
}
