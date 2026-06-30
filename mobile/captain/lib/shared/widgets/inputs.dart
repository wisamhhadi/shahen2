import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextBox extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool required;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? borderColor;
  final Color? backgroundColor;

  const CustomTextBox({
    Key? key,
    required this.title,
    this.subtitle,
    this.hintText,
    this.initialValue,
    this.controller,
    this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.required = false,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.borderColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: Get.theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 8),
            ],
            Text(
              title,
              style: Get.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
            if (required)
              Text(
                " *",
                style: Get.theme.textTheme.titleMedium?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),

        // Subtitle
        if (subtitle != null) ...[
          SizedBox(height: 4),
          Text(
            subtitle!,
            style: Get.theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],

        SizedBox(height: 12),

        // Text Field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            initialValue: controller == null ? initialValue : null,
            keyboardType: keyboardType,
            obscureText: obscureText,
            readOnly: readOnly,
            maxLines: maxLines,
            maxLength: maxLength,
            validator: validator,
            onChanged: onChanged,
            onTap: onTap,
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hintText ?? "أدخل $title",
              hintStyle: Get.theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
                fontSize: 16,
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: backgroundColor ?? Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: borderColor ?? Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: borderColor ?? Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Get.theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: maxLines! > 1 ? 16 : 14,
              ),
              counterText: "",
            ),
          ),
        ),
      ],
    );
  }
}

// ===================================================================
// CUSTOM COMBO BOX WIDGET
// ===================================================================

class CustomComboBox<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? hintText;
  final T? value;
  final List<ComboBoxItem<T>> items;
  final Function(T?)? onChanged;
  final IconData? icon;
  final bool required;
  final String? Function(T?)? validator;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool enabled;

  const CustomComboBox({
    Key? key,
    required this.title,
    this.subtitle,
    this.hintText,
    this.value,
    required this.items,
    this.onChanged,
    this.icon,
    this.required = false,
    this.validator,
    this.borderColor,
    this.backgroundColor,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: enabled
                    ? Get.theme.colorScheme.primary
                    : Colors.grey.shade400,
                size: 20,
              ),
              SizedBox(width: 8),
            ],
            Text(
              title,
              style: Get.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: enabled
                    ? Get.theme.colorScheme.onSurface
                    : Colors.grey.shade500,
              ),
            ),
            if (required)
              Text(
                " *",
                style: Get.theme.textTheme.titleMedium?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),

        // Subtitle
        if (subtitle != null) ...[
          SizedBox(height: 4),
          Text(
            subtitle!,
            style: Get.theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],

        SizedBox(height: 12),

        // Dropdown Field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item.value,
                child: Row(
                  children: [
                    if (item.icon != null) ...[
                      Icon(
                        item.icon,
                        size: 20,
                        color: item.iconColor ?? Get.theme.colorScheme.primary,
                      ),
                      SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        item.text,
                        style: Get.theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          color: enabled ? null : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: enabled ? onChanged : null,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText ?? "اختر $title",
              hintStyle: Get.theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
                fontSize: 16,
              ),
              filled: true,
              fillColor: enabled
                  ? (backgroundColor ?? Colors.grey.shade50)
                  : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: borderColor ?? Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: borderColor ?? Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Get.theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            dropdownColor: Colors.white,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: enabled
                  ? Get.theme.colorScheme.primary
                  : Colors.grey.shade400,
            ),
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}

// ===================================================================
// COMBO BOX ITEM MODEL
// ===================================================================

class ComboBoxItem<T> {
  final T value;
  final String text;
  final IconData? icon;
  final Color? iconColor;

  const ComboBoxItem({
    required this.value,
    required this.text,
    this.icon,
    this.iconColor,
  });
}

// ===================================================================
// SPECIALIZED WIDGETS
// ===================================================================

// Phone Number TextBox
class PhoneTextBox extends StatelessWidget {
  final String? initialValue;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool required;

  const PhoneTextBox({
    Key? key,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.validator,
    this.required = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextBox(
      title: "رقم الهاتف",
      subtitle: "أدخل رقم الهاتف المحمول",
      hintText: "07xxxxxxxx",
      initialValue: initialValue,
      controller: controller,
      icon: Icons.phone,
      keyboardType: TextInputType.phone,
      required: required,
      maxLength: 11,
      onChanged: onChanged,
      validator: validator ?? (value) {
        if (required && (value == null || value.isEmpty)) {
          return "رقم الهاتف مطلوب";
        }
        if (value != null && value.isNotEmpty && !value.startsWith('07')) {
          return "رقم الهاتف يجب أن يبدأ بـ 07";
        }
        if (value != null && value.length != 11) {
          return "رقم الهاتف يجب أن يكون 11 رقم";
        }
        return null;
      },
    );
  }
}

// Email TextBox
class EmailTextBox extends StatelessWidget {
  final String? initialValue;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool required;

  const EmailTextBox({
    Key? key,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.validator,
    this.required = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextBox(
      title: "البريد الإلكتروني",
      subtitle: "أدخل عنوان بريدك الإلكتروني",
      hintText: "example@email.com",
      initialValue: initialValue,
      controller: controller,
      icon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      required: required,
      onChanged: onChanged,
      validator: validator ?? (value) {
        if (required && (value == null || value.isEmpty)) {
          return "البريد الإلكتروني مطلوب";
        }
        if (value != null && value.isNotEmpty && !value.contains('@')) {
          return "البريد الإلكتروني غير صحيح";
        }
        return null;
      },
    );
  }
}

// Password TextBox
class PasswordTextBox extends StatefulWidget {
  final String? initialValue;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool required;
  final String title;

  const PasswordTextBox({
    Key? key,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.validator,
    this.required = false,
    this.title = "كلمة المرور",
  }) : super(key: key);

  @override
  State<PasswordTextBox> createState() => _PasswordTextBoxState();
}

class _PasswordTextBoxState extends State<PasswordTextBox> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextBox(
      title: widget.title,
      subtitle: "أدخل كلمة مرور قوية",
      hintText: "••••••••",
      initialValue: widget.initialValue,
      controller: widget.controller,
      icon: Icons.lock,
      obscureText: _obscureText,
      required: widget.required,
      onChanged: widget.onChanged,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey.shade600,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
      validator: widget.validator ?? (value) {
        if (widget.required && (value == null || value.isEmpty)) {
          return "كلمة المرور مطلوبة";
        }
        if (value != null && value.isNotEmpty && value.length < 6) {
          return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
        }
        return null;
      },
    );
  }
}

// City ComboBox
class CityComboBox extends StatelessWidget {
  final String? value;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool required;

  const CityComboBox({
    Key? key,
    this.value,
    this.onChanged,
    this.validator,
    this.required = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cities = [
      ComboBoxItem(value: "baghdad", text: "بغداد", icon: Icons.location_city),
      ComboBoxItem(value: "basra", text: "البصرة", icon: Icons.location_city),
      ComboBoxItem(value: "erbil", text: "أربيل", icon: Icons.location_city),
      ComboBoxItem(value: "najaf", text: "النجف", icon: Icons.location_city),
      ComboBoxItem(value: "karbala", text: "كربلاء", icon: Icons.location_city),
      ComboBoxItem(value: "mosul", text: "الموصل", icon: Icons.location_city),
      ComboBoxItem(value: "sulaymaniyah", text: "السليمانية", icon: Icons.location_city),
    ];

    return CustomComboBox<String>(
      title: "المحافظة",
      subtitle: "اختر محافظتك",
      hintText: "اختر المحافظة",
      value: value,
      items: cities,
      icon: Icons.location_on,
      required: required,
      onChanged: onChanged,
      validator: validator ?? (value) {
        if (required && value == null) {
          return "المحافظة مطلوبة";
        }
        return null;
      },
    );
  }
}
