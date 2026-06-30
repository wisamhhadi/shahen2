import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final Color? primaryButtonColor;
  final Color? secondaryButtonColor;
  final bool barrierDismissible;
  final DialogType dialogType;

  const CustomDialog({
    Key? key,
    required this.title,
    this.subtitle,
    required this.message,
    this.icon,
    this.iconColor,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.primaryButtonColor,
    this.secondaryButtonColor,
    this.barrierDismissible = true,
    this.dialogType = DialogType.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Section
            _buildHeader(),

            // Content Section
            _buildContent(),

            // Buttons Section
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final iconData = icon ?? _getDefaultIcon();
    final iconBgColor = iconColor ?? _getDefaultIconColor();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: iconBgColor.withOpacity(0.1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: iconBgColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              size: 30,
              color: iconBgColor,
            ),
          ),

          SizedBox(height: 16),

          // Title
          Text(
            title,
            style: Get.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          // Subtitle
          if (subtitle != null) ...[
            SizedBox(height: 8),
            Text(
              subtitle!,
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Text(
        message,
        style: Get.theme.textTheme.bodyLarge?.copyWith(
          height: 1.5,
          color: Get.theme.colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
        maxLines: 9999,
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Row(
        children: [
          // Secondary Button
          Expanded(
            child: Container(
              height: 48,
              child: OutlinedButton(
                onPressed: onSecondaryPressed ?? () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: secondaryButtonColor ?? Colors.grey.shade400,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  secondaryButtonText,
                  style: Get.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: secondaryButtonColor ?? Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 16),

          // Primary Button
          Expanded(
            child: Container(
              height: 48,
              child: ElevatedButton(
                onPressed: onPrimaryPressed ?? () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryButtonColor ?? _getDefaultIconColor(),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  primaryButtonText,
                  style: Get.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDefaultIcon() {
    switch (dialogType) {
      case DialogType.success:
        return Icons.check_circle_outline;
      case DialogType.error:
        return Icons.error_outline;
      case DialogType.warning:
        return Icons.warning_amber_outlined;
      case DialogType.question:
        return Icons.help_outline;
      case DialogType.info:
      default:
        return Icons.info_outline;
    }
  }

  Color _getDefaultIconColor() {
    switch (dialogType) {
      case DialogType.success:
        return Colors.green;
      case DialogType.error:
        return Colors.red;
      case DialogType.warning:
        return Colors.orange;
      case DialogType.question:
        return Get.theme.colorScheme.primary;
      case DialogType.info:
      default:
        return Colors.blue;
    }
  }

  // Static methods for easy usage
  static void show({
    required String title,
    String? subtitle,
    required String message,
    IconData? icon,
    Color? iconColor,
    required String primaryButtonText,
    required String secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    Color? primaryButtonColor,
    Color? secondaryButtonColor,
    bool barrierDismissible = true,
    DialogType dialogType = DialogType.info,
  }) {
    Get.dialog(
      CustomDialog(
        title: title,
        subtitle: subtitle,
        message: message,
        icon: icon,
        iconColor: iconColor,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
        primaryButtonColor: primaryButtonColor,
        secondaryButtonColor: secondaryButtonColor,
        dialogType: dialogType,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  // Predefined dialog types
  static void showSuccess({
    required String title,
    String? subtitle,
    required String message,
    String primaryButtonText = "موافق",
    String secondaryButtonText = "إلغاء",
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
  }) {
    show(
      title: title,
      subtitle: subtitle,
      message: message,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      onSecondaryPressed: onSecondaryPressed,
      dialogType: DialogType.success,
    );
  }

  static void showError({
    required String title,
    String? subtitle,
    required String message,
    String primaryButtonText = "حسناً",
    String secondaryButtonText = "إلغاء",
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
  }) {
    show(
      title: title,
      subtitle: subtitle,
      message: message,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      onSecondaryPressed: onSecondaryPressed,
      dialogType: DialogType.error,
    );
  }

  static void showWarning({
    required String title,
    String? subtitle,
    required String message,
    String primaryButtonText = "متابعة",
    String secondaryButtonText = "إلغاء",
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
  }) {
    show(
      title: title,
      subtitle: subtitle,
      message: message,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      onSecondaryPressed: onSecondaryPressed,
      dialogType: DialogType.warning,
    );
  }

  static void showQuestion({
    required String title,
    String? subtitle,
    required String message,
    String primaryButtonText = "نعم",
    String secondaryButtonText = "لا",
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
  }) {
    show(
      title: title,
      subtitle: subtitle,
      message: message,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      onSecondaryPressed: onSecondaryPressed,
      dialogType: DialogType.question,
    );
  }

  static void showConfirmation({
    required String title,
    required String message,
    String primaryButtonText = "تأكيد",
    String secondaryButtonText = "إلغاء",
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    show(
      title: title,
      message: message,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryPressed: () {
        Get.back();
        onConfirm();
      },
      onSecondaryPressed: onCancel ?? () => Get.back(),
      dialogType: DialogType.question,
    );
  }
}

// ===================================================================
// DIALOG TYPE ENUM
// ===================================================================

enum DialogType {
  info,
  success,
  error,
  warning,
  question,
}

// ===================================================================
// SPECIALIZED DIALOG WIDGETS
// ===================================================================

// Simple Confirmation Dialog
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = "تأكيد",
    this.cancelText = "إلغاء",
    required this.onConfirm,
    this.onCancel,
    this.confirmColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: title,
      message: message,
      primaryButtonText: confirmText,
      secondaryButtonText: cancelText,
      onPrimaryPressed: () {
        Get.back();
        onConfirm();
      },
      onSecondaryPressed: onCancel ?? () => Get.back(),
      primaryButtonColor: confirmColor,
      dialogType: DialogType.question,
    );
  }

  static void show({
    required String title,
    required String message,
    String confirmText = "تأكيد",
    String cancelText = "إلغاء",
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
  }) {
    Get.dialog(
      ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmColor: confirmColor,
      ),
    );
  }
}

// Delete Confirmation Dialog
class DeleteConfirmationDialog extends StatelessWidget {
  final String itemName;
  final VoidCallback onDelete;
  final VoidCallback? onCancel;

  const DeleteConfirmationDialog({
    Key? key,
    required this.itemName,
    required this.onDelete,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "تأكيد الحذف",
      message: "هل أنت متأكد من حذف \"$itemName\"؟\nلا يمكن التراجع عن هذا الإجراء.",
      primaryButtonText: "حذف",
      secondaryButtonText: "إلغاء",
      onPrimaryPressed: () {
        Get.back();
        onDelete();
      },
      onSecondaryPressed: onCancel ?? () => Get.back(),
      primaryButtonColor: Colors.red,
      dialogType: DialogType.error,
      icon: Icons.delete_outline,
    );
  }

  static void show({
    required String itemName,
    required VoidCallback onDelete,
    VoidCallback? onCancel,
  }) {
    Get.dialog(
      DeleteConfirmationDialog(
        itemName: itemName,
        onDelete: onDelete,
        onCancel: onCancel,
      ),
    );
  }
}

// Logout Dialog
class LogoutDialog extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback? onCancel;

  const LogoutDialog({
    Key? key,
    required this.onLogout,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "تسجيل الخروج",
      message: "هل تريد تسجيل الخروج من التطبيق؟",
      primaryButtonText: "تسجيل الخروج",
      secondaryButtonText: "البقاء",
      onPrimaryPressed: () {
        Get.back();
        onLogout();
      },
      onSecondaryPressed: onCancel ?? () => Get.back(),
      primaryButtonColor: Colors.red,
      dialogType: DialogType.warning,
      icon: Icons.logout,
    );
  }

  static void show({
    required VoidCallback onLogout,
    VoidCallback? onCancel,
  }) {
    Get.dialog(
      LogoutDialog(
        onLogout: onLogout,
        onCancel: onCancel,
      ),
    );
  }
}



// class DialogExample extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("مثال على الحوارات"),
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             children: [
//               // Basic Custom Dialog
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     CustomDialog.show(
//                       title: "عنوان الحوار",
//                       subtitle: "عنوان فرعي",
//                       message: "هذا نص تجريبي للحوار. يمكنك كتابة أي نص تريده هنا.",
//                       primaryButtonText: "موافق",
//                       secondaryButtonText: "إلغاء",
//                       onPrimaryPressed: () {
//                         Get.back();
//                         Get.snackbar("نجح", "تم الضغط على موافق");
//                       },
//                     );
//                   },
//                   child: Text("حوار عادي"),
//                 ),
//               ),
//
//               SizedBox(height: 16),
//
//               // Success Dialog
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     CustomDialog.showSuccess(
//                       title: "تم بنجاح",
//                       message: "تم حفظ البيانات بنجاح!",
//                       primaryButtonText: "رائع",
//                       secondaryButtonText: "إغلاق",
//                     );
//                   },
//                   child: Text("حوار نجاح"),
//                 ),
//               ),
//
//               SizedBox(height: 16),
//
//               // Error Dialog
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     CustomDialog.showError(
//                       title: "حدث خطأ",
//                       message: "فشل في حفظ البيانات. يرجى المحاولة مرة أخرى.",
//                       primaryButtonText: "إعادة المحاولة",
//                       secondaryButtonText: "إلغاء",
//                     );
//                   },
//                   child: Text("حوار خطأ"),
//                 ),
//               ),
//
//               SizedBox(height: 16),
//
//               // Warning Dialog
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     CustomDialog.showWarning(
//                       title: "تحذير",
//                       message: "ستفقد جميع البيانات غير المحفوظة. هل تريد المتابعة؟",
//                       primaryButtonText: "متابعة",
//                       secondaryButtonText: "إلغاء",
//                     );
//                   },
//                   child: Text("حوار تحذير"),
//                 ),
//               ),
//
//               SizedBox(height: 16),
//
//               // Question Dialog
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     CustomDialog.showQuestion(
//                       title: "سؤال",
//                       message: "هل تريد حفظ التغييرات قبل الخروج؟",
//                       primaryButtonText: "نعم",
//                       secondaryButtonText: "لا",
//                     );
//                   },
//                   child: Text("حوار سؤال"),
//                 ),
//               ),
//
//               SizedBox(height: 16),
//
//               // Confirmation Dialog
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     ConfirmationDialog.show(
//                       title: "تأكيد العملية",
//                       message: "هل أنت متأكد من تنفيذ هذا الإجراء؟",
//                       onConfirm: () {
//                         Get.snackbar("تم", "تم تأكيد العملية");
//                       },
//                     );
//                   },
//                   child: Text("حوار تأكيد"),
//                 ),
//               ),
//
//               SizedBox(height: 16),
//
//               // Delete Dialog
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     DeleteConfirmationDialog.show(
//                       itemName: "الطلب #123",
//                       onDelete: () {
//                         Get.snackbar("تم", "تم حذف الطلب");
//                       },
//                     );
//                   },
//                   child: Text("حوار حذف"),
//                 ),
//               ),
//
//               SizedBox(height: 16),
//
//               // Logout Dialog
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     LogoutDialog.show(
//                       onLogout: () {
//                         Get.snackbar("تم", "تم تسجيل الخروج");
//                       },
//                     );
//                   },
//                   child: Text("حوار تسجيل الخروج"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }