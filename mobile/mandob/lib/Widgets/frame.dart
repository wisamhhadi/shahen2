import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget frameWidget(String imageframe) {
  return Image.asset(
    imageframe,
    width: double.infinity,
    height: Get.height * 0.5,
    fit: BoxFit.cover,
  );
}
