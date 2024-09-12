import 'package:digidastavej/app/controllers/add_controller.dart';
import 'package:digidastavej/app/controllers/details_controller.dart';
import 'package:digidastavej/app/controllers/document_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentController>(() => DocumentController());
  }
}

class AddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddController>(() => AddController());
  }
}

class DetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsController>(() => DetailsController());
  }
}
