import 'package:edufy/core/shared/managers/themes_manager/themes_manager.dart';
import 'package:flutter/material.dart';

class SubjectHelper {
  static const Color colorPrimary = Color(0xFF25BEB2);
  static const Color colorOrange = Color(0xFFFF9800);
  static const Color colorBlue = Color(0xFF2196F3);
  static const Color colorGreen = Color(0xFF4CAF50);
  static const Color colorPurple = Color(0xFF9C27B0);
  static const Color colorTeal = Color(0xFF009688);
  static const Color colorIndigo = Color(0xFF3F51B5);
  static const Color colorRed = Color(0xFFE91E63);
  static const Color colorBlueGrey = Color(0xFF607D8B);
  static const Color colorPink = Color(0xFFE91E63);
  static const Color colorLightGreen = Color(0xFF8BC34A);
  static const Color colorBrown = Color(0xFF795548);
  static const Color colorDeepPurple = Color(0xFF673AB7);
  static const Color colorCyan = Color(0xFF00BCD4);

  static Color getSubjectColor(BuildContext context, String? subjectName) {
    final colors = ColorManager.of(context).dynamicColors;
    final subject = (subjectName ?? '').toLowerCase();

    if (_contains(subject, ['رياض', 'math'])) return colorOrange;
    if (_contains(subject, ['فيزيا', 'physics'])) return const Color(0xFF448AFF); // Blue Accent
    if (_contains(subject, ['أحياء', 'احياء', 'bio'])) return colorGreen;
    if (_contains(subject, ['كيميا', 'chem'])) return const Color(0xFF7C4DFF); // Purple Accent
    if (_contains(subject, ['علوم', 'sci'])) return colorTeal;
    if (_contains(subject, ['انجليز', 'english', 'eng'])) return colorIndigo;
    if (_contains(subject, ['عربي', 'arabic'])) return const Color(0xFFFF5252); // Red Accent
    if (_contains(subject, ['اسلام', 'دين', 'quran', 'islamic'])) return const Color(0xFF00796B);
    if (_contains(subject, ['حاسب', 'حاسوب', 'it', 'computer'])) return colorBlueGrey;
    if (_contains(subject, ['فنية', 'رسم', 'art'])) return colorPink;
    if (_contains(subject, ['بدنية', 'رياضة', 'sport'])) return colorLightGreen;
    if (_contains(subject, ['تاريخ', 'جغرافيا', 'اجتماع', 'social'])) return colorBrown;
    if (_contains(subject, ['فلسفة', 'philosophy'])) return colorDeepPurple;
    if (_contains(subject, ['وطنية', 'national'])) return colorCyan;

    return colors.primary;
  }

  static IconData getSubjectIcon(String? subjectName) {
    final subject = (subjectName ?? '').toLowerCase();

    if (_contains(subject, ['رياض', 'math'])) return Icons.calculate_rounded;
    if (_contains(subject, ['فيزيا', 'physics'])) return Icons.wb_iridescent_rounded;
    if (_contains(subject, ['أحياء', 'احياء', 'bio'])) return Icons.biotech_rounded;
    if (_contains(subject, ['كيميا', 'chem'])) return Icons.science_rounded;
    if (_contains(subject, ['علوم', 'sci'])) return Icons.psychology_rounded;
    if (_contains(subject, ['انجليز', 'english', 'eng'])) return Icons.language_rounded;
    if (_contains(subject, ['عربي', 'arabic'])) return Icons.menu_book_rounded;
    if (_contains(subject, ['اسلام', 'دين', 'quran', 'islamic'])) return Icons.mosque_rounded;
    if (_contains(subject, ['حاسب', 'حاسوب', 'it', 'computer'])) return Icons.computer_rounded;
    if (_contains(subject, ['فنية', 'رسم', 'art'])) return Icons.palette_rounded;
    if (_contains(subject, ['بدنية', 'رياضة', 'sport'])) return Icons.sports_soccer_rounded;
    if (_contains(subject, ['تاريخ', 'جغرافيا', 'اجتماع', 'social'])) return Icons.public_rounded;
    if (_contains(subject, ['فلسفة', 'philosophy'])) return Icons.psychology_alt_rounded;
    if (_contains(subject, ['وطنية', 'national'])) return Icons.account_balance_rounded;

    return Icons.assignment_rounded;
  }

  static bool _contains(String text, List<String> keywords) {
    for (var keyword in keywords) {
      if (text.contains(keyword)) return true;
    }
    return false;
  }
}