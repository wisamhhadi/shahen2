import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget progressIndicator(int start,int end,int precentage) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Get.theme.colorScheme.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(
          Icons.timeline,
          color: Get.theme.colorScheme.primary,
          size: 24,
        ),
        SizedBox(width: 12),
        Text(
          "الخطوة $start من $end",
          style: Get.theme.textTheme.titleMedium?.copyWith(
            color: Get.theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Text(
          "$precentage%",
          style: Get.theme.textTheme.bodyMedium?.copyWith(
            color: Get.theme.colorScheme.primary,
          ),
        ),
      ],
    ),
  );
}