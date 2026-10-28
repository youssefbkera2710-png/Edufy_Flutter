import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class SubmitGradesButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final int count;
  final int total;

  const SubmitGradesButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: sizer.w(16),
          vertical: sizer.h(8),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            // معلومات عدد الدرجات المدخلة
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: sizer.w(12),
                vertical: sizer.h(6),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(sizer.radius(8)),
              ),
              child: Text(
                '$count / $total',
                style: TextStyle(
                  fontSize: sizer.w(14),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(width: sizer.w(12)),

            // زر الحفظ
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: sizer.h(12),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(sizer.radius(12)),
                  ),
                  elevation: 2,
                ),
                child: isLoading
                    ? SizedBox(
                        height: sizer.h(20),
                        width: sizer.h(20),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.save_rounded),
                          SizedBox(width: sizer.w(8)),
                          Text(
                            count > 0 
                                ? 'حفظ الدرجات ($count)' 
                                : 'حفظ الدرجات',
                            style: TextStyle(
                              fontSize: sizer.w(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}