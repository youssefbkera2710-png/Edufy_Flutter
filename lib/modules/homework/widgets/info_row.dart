// import 'package:edufy/core/shared/extensions/context_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:responsive_s/responsive_s.dart';

// class InfoRow extends StatelessWidget {
//   const InfoRow({
//     super.key,
//     required this.icon,
//     required this.iconColor,
//     required this.label,
//     required this.value,
//     this.valueColor,
//   });

//   final IconData icon;
//   final Color iconColor;
//   final String label;
//   final String value;
//   final Color? valueColor;

//   @override
//   Widget build(BuildContext context) {
//     return ResponsiveWidget(
//       builder: (sizer) => Row(
//         children: [
//           Icon(icon, color: iconColor, size: sizer.w(20)),
//           SizedBox(width: sizer.w(10)),
//           Text(
//             '$label: ',
//             style: context.bodyMedium!.copyWith(
//               color: Theme.of(
//                 context,
//               ).colorScheme.onBackground.withOpacity(0.5),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: context.bodyMedium!.copyWith(
//                 color: valueColor,
//                 fontWeight: FontWeight.w600,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// modules/homework/widgets/info_row.dart

import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  const InfoRow({
    super.key,
    required this.icon,
    this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Row(
        children: [
          Icon(icon, size: sizer.w(20), color: iconColor ?? context.primary),
          SizedBox(width: sizer.w(12)),
          Text(
            label,
            style: TextStyle(
              fontSize: sizer.w(14),
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: sizer.w(14),
                fontWeight: FontWeight.w600,
                color: valueColor ?? null,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
