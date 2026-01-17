import 'package:get/get.dart';
import 'package:movies/screens/home_screen.dart';
import 'package:movies/screens/search_screen.dart';
import 'package:movies/screens/watch_list_screen.dart';

class BottomNavigatorController extends GetxController {
  var screens = [//Variable que almacena las pantallas/navegación
    HomeScreen(),
    const SearchScreen(),
  const WatchList(),//Define el orden de las pestañas en el Bottom Navigation
                    //Cuando index cambia, GetX notifica a todos los widgets que lo observan
  ];
  var index = 0.obs;
  void setIndex(indx) => index.value = indx;//
}
