import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/teacher_exam.dart';
import 'package:edufy/components/wave_header.dart';
import 'package:edufy/modules/exams/add%20exam/add_exam_screen.dart';
import 'package:edufy/modules/exams/management%20grade/exam_grades_screen.dart';
import 'package:edufy/modules/exams/widgets/action_button.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

class ExamDetailScreen extends StatefulWidget {
  const ExamDetailScreen({super.key});

  @override
  State<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends State<ExamDetailScreen> {
  late Datums exam;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    exam = Get.arguments['exam'];
  }

  void _refreshExamFromHome() {
    if (!Get.isRegistered<HomeController>()) return;
    final home = Get.find<HomeController>();

    Datums? updated;
    for (final e in home.teacherExams) {
      if (e.id == exam.id) {
        updated = e;
        break;
      }
    }
    updated ??= () {
      for (final e in home.homeTeacherExams) {
        if (e.id == exam.id) return e;
      }
      return null;
    }();

    if (updated != null && mounted) {
      setState(() => exam = updated!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WaveHeader(context, 'تفاصيل الامتحان', showButtonTheme: false),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ResponsiveWidget(
          builder: (sizer) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: sizer.w(16),
              vertical: sizer.h(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── بطاقة المعلومات الرئيسية ──
                _buildMainInfoCard(sizer, context),
                SizedBox(height: sizer.h(16)),

                // ── قسم الشعب مع إدخال الدرجات ──
                if (exam.assignments != null &&
                    exam.assignments!.isNotEmpty) ...[
                  _buildAssignmentsSection(
                    exam.assignments!,
                    sizer,
                    int.tryParse(exam.maxScore ?? '0'),
                  ),
                  SizedBox(height: sizer.h(16)),
                ],
                // ── أزرار الإجراءات ──
                ActionButtons(
                  id: exam.id ?? 0,
                  title: 'امتحان',
                  onEditPressed: () async {
                    final result = await Get.to(
                      () => AddExamScreen(examId: exam.id ?? 0, isEdit: true),
                    );
                    if (result == true) {
                      _refreshExamFromHome();
                    }
                  },
                ),
                SizedBox(height: sizer.h(16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── بطاقة المعلومات الرئيسية ────────────────────────────
  Widget _buildMainInfoCard(Sizer sizer, BuildContext context) {
    final hasDescription =
        exam.description != null && exam.description!.isNotEmpty;

    final subjectName = exam.assignments?.isNotEmpty == true
        ? exam.assignments!.first.subjectName
        : null;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sizer.radius(20)),
      ),
      child: Container(
        padding: EdgeInsets.all(sizer.w(16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sizer.radius(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: sizer.w(10),
                    vertical: sizer.h(4),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sizer.radius(8)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: context.primary,
                        size: sizer.w(14),
                      ),
                      SizedBox(width: sizer.w(6)),
                      Text(
                        _formatDate(exam.examDate),
                        style: TextStyle(
                          fontSize: sizer.w(13),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: sizer.w(10),
                    vertical: sizer.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: (exam.isPast == true)
                        ? Colors.red.withOpacity(0.5)
                        : Colors.green.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(sizer.radius(8)),
                  ),
                  child: Text(
                    (exam.isPast == true) ? 'منتهي' : 'قادم',
                    style: TextStyle(
                      fontSize: sizer.w(13),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: sizer.h(12)),

            Text(
              exam.title ?? 'اختبار',
              style: TextStyle(
                fontSize: sizer.w(22),
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: sizer.h(10)),

            // ── المادة ──
            if (subjectName != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    color: context.primary,
                    size: sizer.w(18),
                  ),
                  SizedBox(width: sizer.w(8)),
                  Text(
                    subjectName,
                    style: TextStyle(
                      fontSize: sizer.w(15),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: sizer.h(8)),
            ],
            if (exam.selectionType != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.bookmark_outlined,
                    color: context.primary,
                    size: sizer.w(18),
                  ),
                  SizedBox(width: sizer.w(8)),
                  Text(
                    _getSelectionTypeText(exam.selectionType!),
                    style: TextStyle(
                      fontSize: sizer.w(15),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: sizer.h(8)),
            ],
            // ── المصدر ──
            Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  color: context.primary,
                  size: sizer.w(16),
                ),
                SizedBox(width: sizer.w(6)),
                Text(_getSourceText(), style: TextStyle(fontSize: sizer.w(13))),
              ],
            ),

            // ── الوصف ──
            if (hasDescription) ...[
              SizedBox(height: sizer.h(14)),
              Divider(thickness: 1),
              SizedBox(height: sizer.h(10)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.description_rounded,
                    color: context.primary,
                    size: sizer.w(18),
                  ),
                  SizedBox(width: sizer.w(10)),
                  Expanded(
                    child: Text(
                      exam.description!,
                      style: TextStyle(fontSize: sizer.w(14), height: 1.5),
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: sizer.h(14)),
            Divider(thickness: 1),
            SizedBox(height: sizer.h(10)),
            Wrap(
              spacing: sizer.w(10),
              runSpacing: sizer.h(6),
              children: [
                _buildInfoChip(
                  sizer: sizer,
                  icon: Icons.grade_rounded,
                  label: 'الدرجة القصوى: ${exam.maxScore ?? '100'}',
                ),
                if (exam.assignmentsCount != null)
                  _buildInfoChip(
                    sizer: sizer,
                    icon: Icons.class_rounded,
                    label: '${exam.assignmentsCount} شعب',
                  ),
                if (exam.topic != null && exam.topic.toString().isNotEmpty)
                  _buildInfoChip(
                    sizer: sizer,
                    icon: Icons.topic_rounded,
                    label: 'الموضوع: ${exam.topic}',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Chip معلومات مساعد ──────────────────────────────────
  Widget _buildInfoChip({
    required Sizer sizer,
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizer.w(10),
        vertical: sizer.h(4),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sizer.radius(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Theme.of(Get.context!).primaryColor,
            size: sizer.w(14),
          ),
          SizedBox(width: sizer.w(6)),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: sizer.w(12),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ─── تنسيق التاريخ ───────────────────────────────────────
  String _formatDate(DateTime? date) {
    if (date == null) return 'غير محدد';
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ─── قسم الشعب مع إدخال الدرجات ──────────────────────────
  Widget _buildAssignmentsSection(
    List<Assignment> assignments,
    Sizer sizer,
    int? maxScore,
  ) {
    final uniqueAssignments = _getUniqueAssignments(assignments);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sizer.radius(20)),
      ),
      child: Padding(
        padding: EdgeInsets.all(sizer.w(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── العنوان ──
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(sizer.w(10)),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(sizer.radius(12)),
                  ),
                  child: Icon(
                    Icons.class_rounded,
                    color: context.primary,
                    size: sizer.w(24),
                  ),
                ),
                SizedBox(width: sizer.w(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الشعب المشمولة بالاختبار',
                        style: TextStyle(
                          fontSize: sizer.w(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${uniqueAssignments.length} شعب',
                        style: TextStyle(
                          fontSize: sizer.w(14),
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: sizer.h(16)),

            // ── حقل البحث ──
            if (uniqueAssignments.length > 1) ...[
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'بحث عن شعبة...',
                  prefixIcon: Icon(Icons.search_rounded, size: sizer.w(20)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sizer.radius(12)),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sizer.radius(12)),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sizer.radius(12)),
                    borderSide: BorderSide(color: context.primary),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: sizer.w(16),
                    vertical: sizer.h(8),
                  ),
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value.trim().toLowerCase());
                },
              ),
              SizedBox(height: sizer.h(16)),
            ],

            // ── قائمة الشعب ──
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _getFilteredAssignments(uniqueAssignments).length,
              itemBuilder: (context, index) {
                final assignment = _getFilteredAssignments(
                  uniqueAssignments,
                )[index];
                return _buildClassCard(assignment, sizer);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── بطاقة الشعبة الواحدة ──────────────────────────────
  Widget _buildClassCard(Assignment assignment, Sizer sizer) {
    final isPast = exam.isPast ?? false;

    // ✅ المنطق الجديد (معكوس):
    // - إذا كان الاختبار قادم (isPast = false) → مغلق (لسا ما اتعمل)
    // - إذا كان الاختبار منتهي (isPast = true) → نتحقق من can_enter_grades
    final bool isActive;
    final String statusText;
    final Color statusColor;

    if (!isPast) {
      // ❌ الاختبار لسا ما صار → مغلق نهائياً
      isActive = false;
      statusText = 'غير متاح';
      statusColor = Colors.grey;
    } else {
      // ✅ الاختبار صار ومنتهي → نتحقق من صلاحية إدخال الدرجات
      isActive = assignment.canEnterGrades == true;
      statusText = isActive ? 'متاح' : 'مغلق';
      statusColor = isActive ? Colors.green : Colors.orange;
    }

    return Container(
      margin: EdgeInsets.only(bottom: sizer.h(12)),
      padding: EdgeInsets.all(sizer.w(14)),
      decoration: BoxDecoration(
        color: context.backgroundColortheme,
        borderRadius: BorderRadius.circular(sizer.radius(14)),
        border: Border.all(
          color: isActive ? Colors.green.shade200 : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // ── صف المعلومات الرئيسي ──
          Row(
            children: [
              // ── أيقونة الشعبة ──
              Container(
                width: sizer.w(44),
                height: sizer.w(44),
                decoration: BoxDecoration(
                  color: isActive ? Colors.blue.shade100 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(sizer.radius(12)),
                ),
                child: Center(
                  child: Text(
                    assignment.classDivision?.toString() ?? '?',
                    style: TextStyle(
                      fontSize: sizer.w(18),
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? Colors.blue.shade800
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: sizer.w(12)),

              // ── معلومات الشعبة ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${assignment.className ?? 'غير محدد'}',
                      style: TextStyle(
                        fontSize: sizer.w(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: sizer.h(4)),
                    Wrap(
                      spacing: sizer.w(6),
                      runSpacing: sizer.h(4),
                      children: [
                        if (assignment.classSpecialization != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: sizer.w(8),
                              vertical: sizer.h(2),
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.purple.shade100
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(
                                sizer.radius(6),
                              ),
                            ),
                            child: Text(
                              _getSpecializationLabel(
                                assignment.classSpecialization!,
                              ),
                              style: TextStyle(
                                fontSize: sizer.w(12),
                                color: isActive
                                    ? Colors.purple.shade800
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── حالة إدخال الدرجات ──
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: sizer.w(10),
                  vertical: sizer.h(6),
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(sizer.radius(8)),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isActive
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      color: statusColor,
                      size: sizer.w(16),
                    ),
                    SizedBox(width: sizer.w(4)),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: sizer.w(12),
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: sizer.h(12)),

          // ── زر إدخال الدرجات ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isActive
                  ? () => _navigateToGradeEntry(assignment)
                  : null,
              icon: Icon(
                isActive ? Icons.edit_note_rounded : Icons.lock_outline_rounded,
                size: sizer.w(18),
              ),
              label: Text(
                isActive
                    ? 'إدخال درجات الطلاب'
                    : (!isPast ? 'الاختبار لم يبدأ بعد' : 'غير متاح حالياً'),
                style: TextStyle(
                  fontSize: sizer.w(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive
                    ? context.primary.withOpacity(0.9)
                    : Colors.grey.shade400,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: sizer.h(12)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sizer.radius(12)),
                ),
                elevation: isActive ? 2 : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── التنقل إلى صفحة إدخال الدرجات ──────────────────────
  void _navigateToGradeEntry(Assignment assignment) {
    Get.to(
      () => const ExamGradesScreen(),
      arguments: {
        'examId': exam.id ?? 0,
        'classId': assignment.classId ?? 0,
        'examTitle': exam.title ?? 'الاختبار',
        'className': assignment.className ?? 'الصف',
        'maxScore': int.tryParse(exam.maxScore ?? '100') ?? 100,
      },
    );
  }

  // ─── إزالة التكرار من الشعب ─────────────────────────────
  List<Assignment> _getUniqueAssignments(List<Assignment> assignments) {
    final seenIds = <int>{};
    return assignments.where((a) {
      final id = a.classId;
      if (id == null) return true;
      if (seenIds.contains(id)) return false;
      seenIds.add(id);
      return true;
    }).toList();
  }

  // ─── فلترة الشعب حسب البحث ──────────────────────────────
  List<Assignment> _getFilteredAssignments(List<Assignment> assignments) {
    if (_searchQuery.isEmpty) return assignments;
    return assignments.where((a) {
      final name = a.className?.toLowerCase() ?? '';
      final specialization = a.classSpecialization?.toLowerCase() ?? '';
      final subject = a.subjectName?.toLowerCase() ?? '';
      final division = a.classDivision?.toString() ?? '';
      return name.contains(_searchQuery) ||
          specialization.contains(_searchQuery) ||
          subject.contains(_searchQuery) ||
          division.contains(_searchQuery);
    }).toList();
  }

  // ─── ترجمة التخصص ────────────────────────────────────────
  String _getSpecializationLabel(String spec) {
    switch (spec.toLowerCase()) {
      case 'scientific':
        return 'علمي';
      case 'literary':
        return 'أدبي';
      case 'professional':
        return 'مهني';
      default:
        return spec;
    }
  }

  // ─── الحصول على نص المصدر ─────────────────────────────────
  String _getSourceText() {
    final createdBy = exam.createdBy ?? '';
    final source = exam.source ?? '';

    // تحديد نوع المصدر
    String sourceLabel;
    switch (source.toLowerCase()) {
      case 'teacher':
        sourceLabel = 'معلم';
        break;
      case 'admin':
      case 'administration':
        sourceLabel = 'إدارة';
        break;
      default:
        sourceLabel = source;
    }

    return 'منشور بواسطة: $createdBy ($sourceLabel)';
  }

  String _getSelectionTypeText(String type) {
    switch (type) {
      case 'assignments':
        return 'تكليفات';
      case 'classes':
        return 'صفوف';
      case 'all':
        return 'الكل';
      default:
        return type;
    }
  }
}
