import 'package:get/get.dart';

import '../controllers/edit_character_controller.dart';

class EditFavoriteCharacterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditFavoriteCharacterController>(
      () => EditFavoriteCharacterController(),
    );
  }
}