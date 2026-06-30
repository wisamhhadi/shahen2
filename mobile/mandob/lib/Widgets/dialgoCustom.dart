import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

void showCustomAwesomeDialog({
  required BuildContext context,
  required String title,
  required String message,
  required IconData iconHeader,
  required Color iconColor,
  DialogType type = DialogType.success,
  String okText = "حسنًا",
  String cancelText = "إلغاء",
  VoidCallback? onOkPressed,
  VoidCallback? onCancelPressed,
}) {
  AwesomeDialog(
    context: context,
    dialogType: type,
    animType: AnimType.leftSlide,
    headerAnimationLoop: false,
    showCloseIcon: true,
    title: title,
    desc: message,

    customHeader: Icon(
      iconHeader,
      color: iconColor,
      size: 60,
    ),
    titleTextStyle: const TextStyle(
      fontFamily: 'font',
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Color(0xFF4CAF50), // أخضر أنيق
    ),
    descTextStyle: const TextStyle(
      fontFamily: 'font',
      fontSize: 18,
      color: Colors.black87,
    ),
    btnOkText: okText,
    btnOkColor: const Color(0xFF4CAF50), // أخضر
    btnOkOnPress: onOkPressed ?? () {},
    btnCancelText: cancelText,
    btnCancelColor: Colors.redAccent,
    btnCancelOnPress: onCancelPressed,
    buttonsTextStyle: const TextStyle(
      fontFamily: 'font',
      fontSize: 16,
      color: Colors.white,
    ),
    dialogBorderRadius: BorderRadius.circular(20),
    padding: const EdgeInsets.all(16),
  ).show();
}
