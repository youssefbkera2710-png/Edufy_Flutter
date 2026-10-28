import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/core/shared/widgets/no_data_widget.dart';
import 'package:edufy/models/behaviors.dart';
import 'package:edufy/modules/home/guardian/behavior_detail_screen.dart';
import 'package:edufy/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BehaviorsScreen extends StatefulWidget {
  const BehaviorsScreen({super.key, required this.studentName});
  final String studentName;

  @override
  State<BehaviorsScreen> createState() => _BehaviorsScreenState();
}

class _BehaviorsScreenState extends State<BehaviorsScreen> {
  final HomeController controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchBehaviors(studentName: widget.studentName);
    });
  }

  Color _typeColor(Behaviors b) {
    if (b.type == 'warning' || (b.typeLabel?.contains('إنذار') ?? false)) {
      return Colors.red;
    }
    if (b.type == 'note' || (b.typeLabel?.contains('ملاحظة') ?? false)) {
      return Colors.green;
    }
    return Colors.grey;
  }

  IconData _typeIcon(Color color) {
    if (color == Colors.red) return Icons.warning_amber_rounded;
    if (color == Colors.green) return Icons.thumb_up_alt_outlined;
    return Icons.info_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColortheme,
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: context.primary.withOpacity(0.8),
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text(
                    'الملاحظات السلوكية',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              if (controller.isLoadingBehaviors)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (controller.behaviors.isEmpty)
                const SliverFillRemaining(
                  child: NoDataWidget(
                    message: 'لا توجد ملاحظات سلوكية للطالب ',
                    icon: Icons.boy_outlined,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final b = controller.behaviors[index];
                      final color = _typeColor(b);
                      return _BehaviorCard(
                        behavior: b,
                        color: color,
                        icon: _typeIcon(color),
                        onTap: () =>
                            Get.to(() => BehaviorDetailScreen(behavior: b)),
                      );
                    }, childCount: controller.behaviors.length),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _BehaviorCard extends StatelessWidget {
  const _BehaviorCard({
    required this.behavior,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final Behaviors behavior;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateStr = behavior.behaviorDate != null
        ? DateFormat('yyyy-MM-dd').format(behavior.behaviorDate!)
        : '-';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: color, width: 4)),
          color: context.backgroundColortheme,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusChip(label: behavior.isResolvedLabel ?? ''),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(icon, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            behavior.typeLabel ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(dateStr, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              behavior.title ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              behavior.description ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'التفاصيل',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Icon(Icons.chevron_left, color: color, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
