import 'package:almandobUAE/Widgets/heading_text.dart';

import 'package:flutter/material.dart';

class CustomSnackBar {
  final String message;
  final Color backgroundColor;
  final Duration duration;
  final SnackBarAction? action;

  CustomSnackBar({
    required this.message,
    this.backgroundColor = Colors.orange,
    this.duration = const Duration(seconds: 3),
    this.action,
  });

  /// يُعيد الـ SnackBar المُخصص
  SnackBar build() {
    return SnackBar(
      content: bodytext(text: message),
      backgroundColor: backgroundColor,
      duration: duration,
      action: action,
    );
  }

  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.orange,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final snackBar = SnackBar(
      content: bodytext(text: message),
      backgroundColor: backgroundColor,
      duration: duration,
      action: action,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
