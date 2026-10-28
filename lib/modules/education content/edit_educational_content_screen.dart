import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:edufy/modules/education%20content/widgets/content_input_fields.dart';
import 'package:edufy/modules/education%20content/widgets/file_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/content%20education/education.dart';
import '../../models/content education/teacher_classes.dart';
import '../../models/content education/teacher_subject.dart';
import 'edit_education_controller.dart';

class EditContentScreen extends StatelessWidget {
  final Education education;

  const EditContentScreen({super.key, required this.education});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditEducationController(education: education));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark ? context.white : context.grey900;
    final hintColor = isDark
        ? context.grey350.withOpacity(0.6)
        : context.grey350;
    final labelColor = isDark ? context.grey150 : context.grey750;
    final containerBg = isDark ? context.grey900 : context.white;
    final borderColor = isDark ? context.grey750 : context.grey150;

    final kInputDecorationTheme = InputDecorationTheme(
      filled: true,
      fillColor: containerBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(color: labelColor, fontSize: 14),
      hintStyle: TextStyle(color: hintColor, fontSize: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: context.primary, width: 1.5),
      ),
    );

    final dropdownDecoration = CustomDropdownDecoration(
      closedFillColor: containerBg,
      expandedFillColor: containerBg,
      closedBorder: Border.all(color: borderColor, width: 1),
      expandedBorder: Border.all(color: context.primary, width: 1.5),
      closedBorderRadius: BorderRadius.circular(16),
      expandedBorderRadius: BorderRadius.circular(16),
      hintStyle: TextStyle(color: hintColor, fontSize: 13),
      headerStyle: TextStyle(color: textColor, fontSize: 14),
      listItemStyle: TextStyle(color: textColor, fontSize: 14),
    );

    return Theme(
      data: Theme.of(
        context,
      ).copyWith(inputDecorationTheme: kInputDecorationTheme),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "تعديل المحتوى التعليمي",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: context.white,
            ),
          ),
          backgroundColor: context.primary,
          iconTheme: IconThemeData(color: context.white),
          centerTitle: true,
          elevation: 0,
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: context.primary),
                );
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: containerBg,
                        borderRadius: BorderRadius.circular(20),
                        border: isDark
                            ? Border.all(color: borderColor, width: 1)
                            : null,
                        boxShadow: isDark
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                      ),
                      child: ContentInputFields(
                        titleCtrl: controller.titleController,
                        bodyCtrl: controller.bodyController,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: containerBg,
                        borderRadius: BorderRadius.circular(20),
                        border: isDark
                            ? Border.all(color: borderColor, width: 1)
                            : null,
                        boxShadow: isDark
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                      ),
                      child: TextField(
                        controller: controller.topicController,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: "الموضوع (الهاشتاغ أو الوحدة)",
                          labelStyle: TextStyle(color: labelColor),
                          prefixIcon: Icon(
                            Icons.tag_rounded,
                            color: context.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      "المادة التعليمية",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: const InputDecorationTheme(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      child: Obx(() {
                        final selectedSubject = controller.subjectsList
                            .firstWhereOrNull(
                              (sub) =>
                                  sub.id == controller.selectedSubjectId.value,
                            );
                        return CustomDropdown<SubjectModel>(
                          hintText: "اضغط لاختيار المادة من القائمة",
                          items: controller.subjectsList,
                          initialItem: selectedSubject,
                          closedHeaderPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: dropdownDecoration,
                          listItemBuilder:
                              (context, item, isSelected, onItemSelect) => Text(
                                item.name ?? '',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                ),
                              ),
                          headerBuilder: (context, selectedItem, enabled) =>
                              Row(
                                children: [
                                  Icon(
                                    Icons.book_outlined,
                                    color: context.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    selectedItem.name ?? '',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                          onChanged: (val) =>
                              controller.selectedSubjectId.value = val?.id,
                        );
                      }),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      "الصفوف المستهدفة",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: const InputDecorationTheme(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      child: Obx(() {
                        final initialClasses = controller.classesList
                            .where(
                              (cls) => controller.selectedClassesIds.contains(
                                cls.id,
                              ),
                            )
                            .toList();
                        return CustomDropdown<ClassModel>.multiSelect(
                          hintText: "اضغط لاختيار الصفوف المستهدفة",
                          items: controller.classesList,
                          initialItems: initialClasses,
                          closedHeaderPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: dropdownDecoration,
                          listItemBuilder:
                              (context, item, isSelected, onItemSelect) => Text(
                                "${item.gradeLevel} - شعبة ${item.divisionNumber}",
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                ),
                              ),
                          headerListBuilder:
                              (context, selectedItems, enabled) => Row(
                                children: [
                                  Icon(
                                    Icons.gite_outlined,
                                    color: context.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      selectedItems.isEmpty
                                          ? "اضغط لاختيار الصفوف المستهدفة"
                                          : selectedItems
                                                .map(
                                                  (e) =>
                                                      "${e.gradeLevel}-${e.divisionNumber}",
                                                )
                                                .join(', '),
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                          onListChanged: (val) {
                            controller.selectedClassesIds.assignAll(
                              val.map((e) => e.id!).toList(),
                            );
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: containerBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: Obx(
                        () => SwitchListTile(
                          title: Text(
                            "السماح بأقسام التعليقات والردود",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          value: controller.allowComments.value,
                          onChanged: (val) =>
                              controller.allowComments.value = val,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          activeColor: context.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    FilePickerWidget(controller: controller),
                    const SizedBox(height: 40),

                    Obx(
                      () => controller.isSubmitting.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: context.primary,
                              ),
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => controller.updateContent(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: context.primary,
                                  foregroundColor: context.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  elevation: isDark ? 0 : 2,
                                  shadowColor: context.primary.withOpacity(0.3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  "حفظ التعديلات",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: context.white,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
