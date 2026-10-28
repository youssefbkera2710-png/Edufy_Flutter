// lib/modules/teacher/grades/widgets/student_grade_tile.dart

import 'package:edufy/models/student_grade_model.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class StudentGradeTile extends StatelessWidget {
  final StudentGrade student;
  final TextEditingController? controller;
  final double maxScore;
  final Function(String)? onChanged;
  final bool isModified;

  const StudentGradeTile({
    super.key,
    required this.student,
    this.controller,
    required this.maxScore,
    this.onChanged,
    this.isModified = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasScore = student.score != null;

    return ResponsiveWidget(
      builder: (sizer) => Container(
        margin: EdgeInsets.only(bottom: sizer.h(8)),
        padding: EdgeInsets.symmetric(
          horizontal: sizer.w(12),
          vertical: sizer.h(8),
        ),
        decoration: BoxDecoration(
          color: _getTileColor(),
          borderRadius: BorderRadius.circular(sizer.radius(12)),
          border: Border.all(
            color: _getBorderColor(),
            width: isModified ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // رقم الطالب
            Container(
              width: sizer.w(32),
              height: sizer.w(32),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${student.studentId ?? ''}',
                  style: TextStyle(
                    fontSize: sizer.w(12),
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(width: sizer.w(12)),

            // اسم الطالب + الكود
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.studentName ?? 'طالب',
                    style: TextStyle(
                      fontSize: sizer.w(15),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (student.studentCode != null)
                    Text(
                      'كود: ${student.studentCode}',
                      style: TextStyle(
                        fontSize: sizer.w(11),
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(width: sizer.w(12)),

            // حقل إدخال الدرجة
            SizedBox(
              width: sizer.w(100),
              child: TextFormField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'الدرجة',
                  hintStyle: TextStyle(
                    fontSize: sizer.w(12),
                    color: Colors.grey.shade400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sizer.radius(8)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: isModified
                      ? Colors.amber.shade50
                      : (hasScore ? Colors.green.shade50 : Colors.grey.shade50),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: sizer.w(8),
                    vertical: sizer.h(4),
                  ),
                  suffixText: controller?.text.isNotEmpty == true
                      ? '/${maxScore.toStringAsFixed(0)}'
                      : null,
                  suffixStyle: TextStyle(
                    fontSize: sizer.w(10),
                    color: Colors.grey.shade500,
                  ),
                ),
                style: TextStyle(
                  fontSize: sizer.w(14),
                  fontWeight: FontWeight.w600,
                ),
                onChanged: onChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) return null;
                  final score = double.tryParse(value);
                  if (score == null) return 'رقم غير صحيح';
                  if (score < 0) return 'لا يمكن أن تكون سالبة';
                  if (score > maxScore) return 'تتجاوز $maxScore';
                  return null;
                },
              ),
            ),

            // علامة التعديل
            if (isModified) ...[
              SizedBox(width: sizer.w(8)),
              Icon(
                Icons.edit_rounded,
                color: Colors.amber.shade700,
                size: sizer.w(16),
              ),
            ],

            // علامة وجود درجة سابقة
            if (hasScore && !isModified) ...[
              SizedBox(width: sizer.w(8)),
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green.shade600,
                size: sizer.w(16),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getTileColor() {
    if (isModified) {
      return Colors.amber.shade50;
    }
    if (student.score != null) {
      return Colors.green.shade50;
    }
    return Colors.white;
  }

  Color _getBorderColor() {
    if (isModified) {
      return Colors.amber.shade300;
    }
    if (student.score != null) {
      return Colors.green.shade200;
    }
    return Colors.grey.shade200;
  }
}
