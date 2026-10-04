import 'package:get/get.dart';

import '../controllers/subtes_controller.dart';

class SubtesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubtesController>(
      () => SubtesController(),
    );
  }
}
