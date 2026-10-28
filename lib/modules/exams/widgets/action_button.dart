import 'package:edufy/core/config/user_info.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class ActionButtons extends StatefulWidget {
  const ActionButtons({
    super.key,
    required this.id,
    required this.title,
    this.isHomework,
    required this.onEditPressed,
  });

  final int id;
  final String title;
  final bool? isHomework;
  final VoidCallback onEditPressed;

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (UserInfo.role == 'student' || UserInfo.role == 'guardian') {
      return const SizedBox.shrink();
    }

    return ResponsiveWidget(
      builder: (sizer) => Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _isDeleting ? null : widget.onEditPressed,
              icon: Icon(
                Icons.edit_outlined,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              label: Text('تعديل  ${widget.title}'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: context.primary),
                padding: EdgeInsets.symmetric(vertical: sizer.h(14)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sizer.radius(16)),
                ),
                textStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(width: sizer.w(10)),

          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isDeleting
                  ? null
                  : () => confirmDelete(context, sizer),
              icon: _isDeleting
                  ? SizedBox(
                      width: sizer.w(18),
                      height: sizer.w(18),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.delete_outline_rounded),
              label: Text('حذف ${widget.title}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? Colors.red.shade900
                    : const Color(0xFFBA1A1A),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: sizer.h(14)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sizer.radius(16)),
                ),
                elevation: 0,
                textStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void confirmDelete(BuildContext context, Sizer sizer) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: !_isDeleting,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sizer.radius(20)),
          ),
          backgroundColor: theme.dialogBackgroundColor,
          title: Text(
            'حذف ${widget.title}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'هل أنت متأكد من حذف هذا ${widget.title}؟ لا يمكن التراجع.',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: _isDeleting
                  ? null
                  : () => Navigator.pop(dialogContext),
              child: Text('إلغاء', style: TextStyle(color: context.grey625)),
            ),
            ElevatedButton(
              onPressed: _isDeleting
                  ? null
                  : () async {
                      setDialogState(() => _isDeleting = true);
                      if (mounted) setState(() => _isDeleting = true);

                      final ctrl = Get.find<HomeController>();
                      final success = widget.isHomework == true
                          ? await ctrl.deleteHomewrokForTeacher(id: widget.id)
                          : await ctrl.deleteExamForTeacher(id: widget.id);

                      // إغلاق الديالوج بعد اكتمال العملية (والبيانات صارت محدّثة فعليًا)
                      if (dialogContext.mounted) Navigator.pop(dialogContext);

                      if (mounted) setState(() => _isDeleting = false);

                      if (success && context.mounted) {
                        Navigator.pop(context);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? Colors.red.shade900
                    : const Color(0xFFBA1A1A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sizer.radius(12)),
                ),
              ),
              child: _isDeleting
                  ? SizedBox(
                      width: sizer.w(20),
                      height: sizer.w(20),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('حذف'),
            ),
          ],
        ),
      ),
    );
  }
}
