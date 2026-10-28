import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/behaviors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BehaviorDetailScreen extends StatelessWidget {
  const BehaviorDetailScreen({super.key, required this.behavior});
  final Behaviors behavior;

  @override
  Widget build(BuildContext context) {
    final dateStr = behavior.behaviorDate != null
        ? DateFormat('yyyy-MM-dd').format(behavior.behaviorDate!)
        : '-';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'تفاصيل الملاحظة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoCard(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(behavior.studentCode ?? '-'),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('الطالب', style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      behavior.studentName ?? '-',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFE6F0EE),
                  child: const Icon(Icons.person, color: Color(0xFF1F6F5C)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('العنوان', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 6),
                Text(
                  behavior.title ?? '-',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('التاريخ', style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            dateStr,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Color(0xFF25BEB2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('النوع', style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          behavior.typeLabel ?? '-',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('الوصف', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE3E5E3)),
                  ),
                  child: Text(
                    behavior.description ?? '-',
                    textAlign: TextAlign.right,
                    style: const TextStyle(height: 1.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _InfoCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.badge_outlined,
                  label: 'بواسطة',
                  value: behavior.creatorName ?? '-',
                ),
                const Divider(height: 1),
                _DetailRow(
                  icon: Icons.school_outlined,
                  label: 'العام الدراسي',
                  value: behavior.academicYearName ?? '-',
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Color(0xFF25BEB2),
                          ),
                          SizedBox(width: 8),
                          Text('الحالة'),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F6F5C),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          behavior.isResolvedLabel ?? '-',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: context.primary),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
