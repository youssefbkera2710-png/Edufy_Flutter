import 'package:flutter/material.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';

/// Widget لعرض رسالة "لا توجد بيانات" مع زر إعادة محاولة اختياري
class NoDataWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final String? buttonText;

  const NoDataWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.school_outlined,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: context.grey350),
          const SizedBox(height: 16),
          Text(message, style: context.bodyMedium, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(buttonText ?? 'إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
