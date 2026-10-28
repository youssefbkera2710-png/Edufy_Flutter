import 'package:edufy/core/shared/controller/no_connection_controller.dart';
import 'package:edufy/core/shared/controller/support_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NoConnectionController(), permanent: true);

    Get.lazyPut<SupportController>(() => SupportController(), fenix: true);
  }
}
