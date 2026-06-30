import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget drawerItem(
  IconData icon,
  String title,
) {
  return ListTile(
    leading: CircleAvatar(
      radius: 15,
      backgroundColor: CustomColors.primary,
      child: Icon(icon, color: Colors.white, size: 18),
    ),
    title: bodytext(
      text: title,
    ),
  );
}

// عنصر قابل للتوسعة مع قائمة فرعية مخصصة
Widget expansionDrawerItem(IconData icon, String title, List<Widget> children) {
  return ExpansionTile(
    leading: CircleAvatar(
      radius: 15,
      backgroundColor: CustomColors.primary,
      child: Icon(icon, color: Colors.white, size: 18),
    ),
    title: bodytext(
      text: title,
    ),
    children: children,
  );
}

// عنصر فرعي مخصص داخل الـ submenu
Widget subMenuItem(String label, VoidCallback onclick) {
  return Padding(
    padding: const EdgeInsets.only(right: 40, bottom: 4),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "font"),
      ),
      onTap: onclick,
      dense: true,
    ),
  );
}
