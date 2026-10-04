import 'package:get/get.dart';

import '../controllers/packs_controller.dart';

class PacksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PacksController>(
      () => PacksController(),
    );
  }
}
