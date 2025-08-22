import 'package:flutter/material.dart';
import 'app_theme.dart';

class ToastHelper {
  static void showSuccess(BuildContext context, String message) {
    _showToast(
      context: context,
      message: message,
      icon: Icons.check_circle,
      backgroundColor: Colors.green,
    );
  }

  static void showError(BuildContext context, String message) {
    _showToast(
      context: context,
      message: message,
      icon: Icons.error,
      backgroundColor: Colors.red,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showToast(
      context: context,
      message: message,
      icon: Icons.info,
      backgroundColor: Colors.blue,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _showToast(
      context: context,
      message: message,
      icon: Icons.warning,
      backgroundColor: Colors.orange,
    );
  }

  static void _showToast({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTheme.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
