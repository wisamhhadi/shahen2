import 'package:almandobUAE/Widgets/colors.dart';
import 'package:almandobUAE/Widgets/heading_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool ishome;
  final double elevation;
  final Widget? leading;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.ishome = false,
    this.elevation = 1.0,
    this.leading,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: ishome == true
          ? Image(image: AssetImage("$title"),width: 50,)
          : HeadingText(
              text: title,
              textColor: Colors.white,
              fontWeight: FontWeight.w500,
            ),
      backgroundColor: CustomColors.primary,
      centerTitle: true,
      leading: leading,
      actions: actions,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }
}
