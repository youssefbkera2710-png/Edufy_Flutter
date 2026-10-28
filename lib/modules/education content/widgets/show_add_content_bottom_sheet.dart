import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/shared/managers/themes_manager/themes_manager.dart';
import '../education_content_controller.dart';
import 'content_input_fields.dart';

void showAddContentBottomSheet(BuildContext context) {
  final controller = Get.find<EducationalContentController>();
  final colors = ColorManager.of(context).dynamicColors;

  controller.titleController.clear();
  controller.bodyController.clear();
  controller.topicController.clear();
  controller.newPickedFiles.clear();
  controller.selectedSubjectId.value = null;
  controller.selectedClassesIds.clear();
  controller.allowComments.value = true;

  final kInputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: colors.background.withOpacity(0.5),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    labelStyle: TextStyle(color: colors.grey750, fontSize: 14),
    hintStyle: TextStyle(color: colors.grey350, fontSize: 13),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.grey150, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.primary, width: 1.5),
    ),
  );

  Get.bottomSheet(
    Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: kInputDecorationTheme,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: Get.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentInputFields(
                titleCtrl: controller.titleController,
                bodyCtrl: controller.bodyController,
              ),
              const SizedBox(height: 16),

              TextField(
                controller: controller.topicController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: "الموضوع (الهاشتاغ أو الوحدة)",
                  prefixIcon: Icon(Icons.tag_rounded, color: colors.primary, size: 20),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                "اختر المادة التعليمية:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: colors.grey900),
              ),
              const SizedBox(height: 10),
              Obx(() => DropdownButtonFormField<int>(
                isExpanded: true,
                alignment: Alignment.centerRight,
                value: controller.selectedSubjectId.value,
                hint: const Text("اضغط لاختيار المادة من القائمة"),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.book_outlined, color: colors.primary, size: 20),
                ),
                items: controller.subjectsList.map((sub) {
                  return DropdownMenuItem<int>(
                    value: sub.id,
                    child: Text(sub.name ?? ''),
                  );
                }).toList(),
                onChanged: (val) => controller.selectedSubjectId.value = val,
              )),
              const SizedBox(height: 24),

              Text(
                "اختر الصفوف المستهدفة:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: colors.grey900),
              ),
              const SizedBox(height: 10),
              Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.classesList.map((cls) {
                  final isSelected = controller.selectedClassesIds.contains(cls.id);
                  return ChoiceChip(
                    label: Text("${cls.gradeLevel} - شعبة ${cls.divisionNumber}"),
                    selected: isSelected,
                    selectedColor: colors.primary.withOpacity(0.15),
                    checkmarkColor: colors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? colors.primary : colors.grey900,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        controller.selectedClassesIds.add(cls.id!);
                      } else {
                        controller.selectedClassesIds.remove(cls.id);
                      }
                    },
                  );
                }).toList(),
              )),
              const SizedBox(height: 20),

              Obx(() => SwitchListTile(
                title: const Text(
                  "السماح بأقسام التعليقات والردود على هذا المنشور",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                value: controller.allowComments.value,
                onChanged: (val) => controller.allowComments.value = val,
                contentPadding: EdgeInsets.zero,
                activeColor: colors.primary,
              )),
              const SizedBox(height: 15),

              // FilePickerWidget(controller: controller),
              const SizedBox(height: 30),

              Obx(() => controller.isSubmitting.value
                  ? Center(child: CircularProgressIndicator(color: colors.primary))
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.createContent(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("نشر المحتوى", style: TextStyle(fontSize: 16)),
                ),
              )),
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
  );
}