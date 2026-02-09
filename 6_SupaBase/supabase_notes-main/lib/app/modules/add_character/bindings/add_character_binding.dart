import 'package:get/get.dart';
import '../controllers/add_character_controller.dart';

class AddFavoriteCharacterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddFavoriteCharacterController>(
      () => AddFavoriteCharacterController(),
    );
  }
}