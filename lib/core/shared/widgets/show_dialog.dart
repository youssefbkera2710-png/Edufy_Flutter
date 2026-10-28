import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
    IconData? icon,
    Color? iconColor,
    Color? confirmButtonColor,
    bool showCancelButton = true,
    bool barrierDismissible = false,
  }) async {
    return Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: (iconColor ?? Colors.red).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.warning_rounded,
                  color: iconColor ?? Colors.red,
                  size: 34,
                ),
              ),

              const SizedBox(height: 16),

              /// Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              /// Description
              Text(
                message,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              /// Actions
              Row(
                children: [
                  if (showCancelButton) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                          onCancel?.call();
                        },
                        child: Text(cancelText ?? 'الغاء'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            confirmButtonColor ??
                            Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        Get.back();
                        onConfirm();
                      },
                      child: Text(
                        confirmText,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}
