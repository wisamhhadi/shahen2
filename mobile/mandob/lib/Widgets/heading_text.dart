import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final String fontFamily;
  const HeadingText({super.key, required this.text, this.fontSize = 20.0, this.textColor = Colors.black, this.fontWeight = FontWeight.bold, this.textAlign = TextAlign.start, this.fontFamily = "font"});

  @override
  Widget build(BuildContext context) {
    return Text(
      textDirection: TextDirection.rtl,
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: textColor,
        fontWeight: fontWeight,
      ),
    );
  }
}

class bodytext extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final String fontFamily;
  final TextOverflow textOverflow;
  const bodytext({
    super.key,
    required this.text,
    this.fontSize = 16.0,
    this.textColor = Colors.black,
    this.fontWeight = FontWeight.bold,
    this.textAlign = TextAlign.start,
    this.fontFamily = "font",
    this.textOverflow = TextOverflow.visible,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textDirection: TextDirection.rtl,
      text,
      textAlign: textAlign,
      overflow: textOverflow,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: textColor,
        fontWeight: fontWeight,
      ),
    );
  }
}
