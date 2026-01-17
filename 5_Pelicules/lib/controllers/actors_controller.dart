import 'package:get/get.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/actors.dart';

class ActorsController extends GetxController {
  var isLoading = true.obs;
  var mainTopRatedActors = <Actor>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadPopularActors();
  }
  
  Future<void> loadPopularActors() async {
    try {
      isLoading.value = true;
      final actors = await ApiService.getPopularActors();
      if (actors != null) {
        mainTopRatedActors.value = actors;
      }
    } finally {
      isLoading.value = false;
    }
  }
}