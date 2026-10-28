import 'package:edufy/components/wave_header.dart';
import 'package:edufy/modules/homework/add&edit%20homework/add_homework_controller.dart';
import 'package:edufy/modules/homework/add&edit%20homework/widgets/homework_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddHomeworkScreen extends StatefulWidget {
  final int? homeworkId;
  final bool isEdit;

  const AddHomeworkScreen({super.key, this.homeworkId, this.isEdit = false});

  @override
  State<AddHomeworkScreen> createState() => _AddHomeworkScreenState();
}

class _AddHomeworkScreenState extends State<AddHomeworkScreen> {
  final AddHomeworkController controller = Get.put(AddHomeworkController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isDataLoaded = false;

  final FocusNode _classFocusNode = FocusNode();
  final FocusNode _subjectFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.homeworkId != null) {
      _loadDataForEdit();
    } else {
      _isDataLoaded = true;
    }
  }

  @override
  void dispose() {
    _classFocusNode.dispose();
    _subjectFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadDataForEdit() async {
    await controller.loadHomeworkForEdit(widget.homeworkId!);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _isDataLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingData.value) {
        return _buildLoadingScreen();
      }

      return _buildMainScreen();
    });
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: WaveHeader(
        context,
        widget.isEdit ? 'تعديل الوظيفة' : 'إضافة وظيفة جديدة',
        showButtonTheme: false,
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildMainScreen() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: WaveHeader(
          context,
          widget.isEdit ? 'تعديل الوظيفة' : 'إضافة وظيفة جديدة',
          showButtonTheme: false,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: HomeworkForm(
            controller: controller,
            formKey: formKey,
            isDataLoaded: _isDataLoaded,
            isEdit: widget.isEdit,
            classFocusNode: _classFocusNode,
            subjectFocusNode: _subjectFocusNode,
          ),
        ),
      ),
    );
  }
}
