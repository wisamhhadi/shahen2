import 'package:almandobUAE/Widgets/colors.dart';
import 'package:flutter/material.dart';

class TextBoxCustom extends StatelessWidget {
  final String hintText;
  final String? startVal;
  final int? lines;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final void Function(String)? onChanged;

  const TextBoxCustom({
    Key? key,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.startVal,
    this.lines,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CustomColors.secendory,
            CustomColors.primary,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            readOnly: readOnly,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            initialValue: startVal,
            onChanged: onChanged,
            style: TextStyle(fontFamily: "font"),
            decoration: InputDecoration(
              hintStyle: TextStyle(
                fontFamily: "font",
                fontSize: 18,
                color: Colors.black,
              ),
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
