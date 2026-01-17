import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:movies/screens/main.dart'; 
import 'package:movies/controllers/movies_controller.dart';
import 'package:movies/controllers/actors_controller.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:movies/controllers/search_controller.dart'; // Asumo que se llama search_controller.dart

void main() {
  // Asegurar inicialización de Flutter antes de usar plugins
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configurar overlay aquí, antes de runApp
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF242A32),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF242A32),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // INICIALIZAR TODOS LOS CONTROLADORES AQUÍ
  Get.put(MoviesController());      // Para películas
  Get.put(ActorsController());      // Para actores  
  Get.put(BottomNavigatorController()); // Para navegación
  Get.put(SearchController1());     // Para búsqueda (asumiendo que así se llama)
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF242A32),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF242A32),
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      home: Main(), 
    );
  }
}