import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';

import '../../../core/res/ctm_inputDecoration.dart';

class TextFormFieldDeF extends StatelessWidget {
  TextFormFieldDeF({
    super.key,
    required this.label,
    required this.paddingTop,
    this.icon,
    this.validator,
    this.keyboard,
    required this.controller,
    required this.maxLines,
    this.readOnly = false,
    this.suffixIcon,
  });

  final String label;
  final IconData? icon;
  final String? Function(String?)? validator;
  final double paddingTop;
  final TextInputType? keyboard;
  final TextEditingController controller;
  final int maxLines;

  final bool readOnly;
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        keyboardType: keyboard,
        validator: validator,
        readOnly: readOnly,

        decoration: inputDecorationDef(icon, label, context.primary, context)
            .copyWith(
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, color: Colors.grey)
                  : null,

              filled: readOnly,
              fillColor: readOnly
                  ? Colors.grey.withOpacity(0.1)
                  : context.primary.withOpacity(0.07),
            ),
      ),
    );
  }
}
