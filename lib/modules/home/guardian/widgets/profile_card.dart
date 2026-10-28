import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/models/children.dart';
import 'package:edufy/models/user.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.user,  this.currentClass});
  final User user;
  final CurrentClass ?  currentClass;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Container(
        width: double.infinity,
        padding:  EdgeInsets.symmetric(vertical: sizer.h(24), horizontal:sizer.w(20) ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [context.primary, context.primary.withOpacity(0.8)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(sizer.radius(20)),
          boxShadow: [
            BoxShadow(
              color: context.primary.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user.name!,
                  style:context.bodyMedium!.copyWith(fontSize: 22,fontWeight: FontWeight.bold),  
                ),
                SizedBox(height: sizer.h(4)),
                Row(
                  children: [
                    Text(
                      'الصف ${currentClass?.gradeLevel} - الشعبة ${currentClass?.divisionNumber}',
                      style: context.bodyMedium,
                    ),
                    SizedBox(width: sizer.w(6)),
                    Icon(
                      Icons.school_outlined,
                      size: sizer.w(18),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: sizer.w(80),
              height: sizer.h(80),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: sizer.w(2.5), color: context.white ),
              ),
              child: ClipOval(
                child: user.avatar == null
                    ? Image.asset('assets/images/logo.png', fit: BoxFit.cover)
                    : Image.network(user.avatar!, fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
