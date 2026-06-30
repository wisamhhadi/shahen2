import 'dart:math';

import 'package:almandobUAE/Widgets/colors.dart';
import 'package:flutter/material.dart';

Widget otpWidget(TextEditingController controler) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
    child: Transform.rotate(
      angle: 45 * pi / 180,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: CustomColors.secendory,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(1, 1),
            )
          ],
        ),
        child: Transform.rotate(
          angle: -45 * pi / 180,
          child: Center(
            child: TextField(
              controller: controler,
              textAlign: TextAlign.center,
              maxLength: 1,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: '',
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
