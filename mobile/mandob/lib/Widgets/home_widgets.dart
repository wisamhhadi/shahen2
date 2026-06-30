import 'package:flutter/material.dart';

Widget buildcartHome(String iconImage, Color color, String count, String numbers) {
  return Stack(
    children: [
      // الحاوية الرئيسية
      Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '$iconImage',
              width: 40,
              height: 40,
            ),
            SizedBox(height: 8),
            Text(
              '$numbers',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),

      // الشارة (Badge)
      Positioned(
        top: 6,
        right: 6,
        child: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey[700],
            shape: BoxShape.circle,
          ),
          child: Text(
            '$count',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    ],
  );
}

Widget cartWithouBadge(String iconImage, Color color, String numbers, bool hasNumber) {
  return Stack(
    children: [
      // الحاوية الرئيسية
      Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '$iconImage',
              width: 40,
              height: 40,
            ),
            SizedBox(height: 8),
            hasNumber == true
                ? Text(
                    '$numbers',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),

      // الشارة (Badge)
    ],
  );
}
