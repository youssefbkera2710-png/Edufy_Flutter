import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';
import '../../../core/res/ctm_inputDecoration.dart';

class DropdownFormFieldDef<T> extends StatelessWidget {
  const DropdownFormFieldDef({
    super.key,
    required this.label,
    required this.paddingTop,
    this.icon,
    required this.items,
    required this.value,
    required this.itemLabel,
    required this.onChanged,
    this.validator,
    this.filled = true,
    this.fillColor,
    this.borderRadius = 16,
    this.elevation = 2,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.focusNode,
  });

  final String label;
  final double paddingTop;
  final IconData? icon;
  final List<T> items;
  final T? value;
  final String Function(T)? itemLabel;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final bool filled;
  final Color? fillColor;
  final double borderRadius;
  final double elevation;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Padding(
        padding: EdgeInsets.only(top: paddingTop),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: DropdownButtonFormField<T>(
            focusNode: focusNode,
            value: value,
            validator: validator,
            isExpanded: true,
            icon:
                suffixIcon ??
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 22,
                  color: context.primary,
                ),
            decoration:
                inputDecorationDef(
                  icon,
                  label,
                  context.primary,
                  context,
                ).copyWith(
                  filled: filled,
                  fillColor: fillColor ?? context.primary.withOpacity(0.07),
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  hintText: hintText,
                  hintStyle: context.bodyMedium?.copyWith(
                    color: context.grey625,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: sizer.w(16),
                    vertical: sizer.h(14),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: context.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(color: context.primary, width: 1),
                  ),
                ),
            dropdownColor: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(borderRadius),
            elevation: 22,
            menuMaxHeight: sizer.h(300),
            style: context.bodyMedium?.copyWith(
              fontSize: sizer.h(14),
              fontWeight: FontWeight.w500,
            ),
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemLabel?.call(item) ?? '',
                  style: context.bodyMedium?.copyWith(
                    fontSize: sizer.h(14),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
