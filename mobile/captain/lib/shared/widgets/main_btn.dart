import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget mainButton(VoidCallback func,String title){
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed:func,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        title,
        style: Get.theme.textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}