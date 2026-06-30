import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

Widget photoUploadSection({
  required String title,
  required String subtitle,
  required XFile? photo,
  required VoidCallback onTap,
  required IconData icon,
}) {
  bool hasPhoto = photo != null;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(
            icon,
            color: Get.theme.colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: Get.theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (hasPhoto)
            Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green.shade600,
                    size: 12,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "تم الرفع",
                    style: Get.theme.textTheme.labelSmall?.copyWith(
                      color: Colors.green.shade700,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      SizedBox(height: 4),
      Text(
        subtitle,
        style: Get.theme.textTheme.bodySmall?.copyWith(
          color: Colors.grey.shade600,
        ),
      ),
      SizedBox(height: 12),
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            color: hasPhoto ? Colors.green.shade50 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasPhoto ? Colors.green.shade300 : Get.theme.colorScheme.primary,
              width: hasPhoto ? 2 : 1.5,
              style: hasPhoto ? BorderStyle.solid : BorderStyle.solid,
            ),
          ),
          child: hasPhoto
              ? Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(photo.path),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Get.theme.colorScheme.primary,
                    size: 16,
                  ),
                ),
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 40,
                  color: Get.theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "اضغط لرفع الصورة",
                style: Get.theme.textTheme.bodyMedium?.copyWith(
                  color: Get.theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "JPG, PNG حتى 5MB",
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}