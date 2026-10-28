import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: context.red500, size: sizer.w(60)),
            SizedBox(height: sizer.h(12)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.red500),
            ),
            SizedBox(height: sizer.h(16)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primary,
              ),
              onPressed: onRetry,
              icon: Icon(Icons.refresh, color: context.white),
              label: Text(
                'إعادة المحاولة',
                style: TextStyle(color: context.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
