import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget mainHeaderSection(String title,String note) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: Get.theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Get.theme.colorScheme.primary,
        ),
      ),
      SizedBox(height: 8),
      if(note.isNotEmpty)
        Text(
          note,
          style: Get.theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
    ],
  );
}