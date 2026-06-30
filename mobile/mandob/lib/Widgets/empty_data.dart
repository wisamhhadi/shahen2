import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? icon;
  final Color? iconColor;
  final double? iconSize;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final Color? textColor;

  const NoDataWidget({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.iconSize = 80,
    this.buttonText,
    this.onButtonPressed,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = textColor ?? theme.hintColor;
    final iconWidget = icon ??
        Icon(
          Icons.find_in_page_outlined,
          size: iconSize,
          color: iconColor ?? color.withOpacity(0.5),
        );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with subtle shadow
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: iconWidget,
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              title ?? 'لا توجد بيانات',
              style: theme.textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                subtitle ?? 'لم يتم العثور على أي بيانات لعرضها',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: color.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Button (if provided)
            if (buttonText != null && onButtonPressed != null)
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  buttonText!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
