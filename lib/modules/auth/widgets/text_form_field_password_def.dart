
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';




class TextFormFielPassword extends StatefulWidget {
   TextFormFielPassword({
    super.key,
    required this.label,
    required this.validator,
    required this.paddingTop,required this.controller
  });
  final String label;
  final String?Function(String?) validator;
  final double paddingTop;

  final TextEditingController controller;
  @override
  State<TextFormFielPassword> createState() => _TextFormFieldDeFState();
}

bool _show = false;

class _TextFormFieldDeFState extends State<TextFormFielPassword> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(builder: (sizer)=>Padding(
      padding: EdgeInsets.only(top: widget.paddingTop),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.visiblePassword,
        obscureText: !_show,
        validator: widget.validator,
        decoration: InputDecoration(
          contentPadding:
          EdgeInsets.only(top: sizer.h(8), bottom:sizer.h(8), left: sizer.w(15), right: sizer.w(15)),
          border:  OutlineInputBorder(
            borderSide: BorderSide(color: context.primary, width: 1),
            borderRadius: const BorderRadius.all(
              Radius.circular(35),
            ),
          ),
          focusedBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: context.primary, width: 1),
            borderRadius:  BorderRadius.all(
              Radius.circular(sizer.radius(35)),
            ),
          ),
          enabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: context.primary, width: 1),
            borderRadius:  BorderRadius.all(
              Radius.circular(sizer.radius(35)),
            ),
          ),
          suffixIcon: InkWell(
            onTap: () => setState(() {
              _show = !_show;
            }),
            child: Icon(_show ? Icons.visibility_off : Icons.visibility,
                color: context.grey900),
          ),
          label: Text(
            widget.label,
            style: context.bodySmall,
          ),
        ),
      ),
    ));
  }
}
