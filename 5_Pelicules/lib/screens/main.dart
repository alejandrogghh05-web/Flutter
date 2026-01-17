import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';

class Main extends StatelessWidget {
  Main({super.key});
  // Inicializa el controlador de navegación inferior
  final BottomNavigatorController controller = Get.put(BottomNavigatorController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        // Oculta el teclado al tocar en cualquier lugar
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SafeArea(
            child: IndexedStack(
              // Muestra la pantalla actual según el índice
              index: controller.index.value,
              children: Get.find<BottomNavigatorController>().screens,
            ),
          ),
          // Barra de navegación inferior personalizada
          bottomNavigationBar: Container(
            height: 78,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFF0296E5),// Color azul para el borde superior
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: controller.index.value,
              onTap: (index) =>
                  Get.find<BottomNavigatorController>().setIndex(index),// Cambia de pantalla
              backgroundColor: const Color(0xFF242A32),  // Fondo oscuro
              selectedItemColor: const Color(0xFF0296E5),  // Color azul para item seleccionado
              unselectedItemColor: const Color(0xFF67686D),  // Color gris para items no seleccionados
              selectedFontSize: 12,
              unselectedFontSize: 12,
              items: [
                // Item 1: Home
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: SvgPicture.asset(
                      'assets/Home.svg',
                      height: 21,
                      width: 21,
                      // Cambia color según si está seleccionado o no
                      // ignore: deprecated_member_use
                      color: controller.index.value == 0
                          ? const Color(0xFF0296E5)  // Azul si seleccionado
                          : const Color(0xFF67686D), // Gris si no seleccionado
                    ),
                  ),
                  label: 'Home',
                ),
                // Item 2: Search
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: SvgPicture.asset(
                      'assets/Search.svg',
                      height: 21,
                      width: 21,
                      // ignore: deprecated_member_use
                      color: controller.index.value == 1
                          ? const Color(0xFF0296E5)
                          : const Color(0xFF67686D),
                    ),
                  ),
                  label: 'Search',
                  tooltip: 'Search Movies',// Texto que aparece al mantener presionado
                ),
                // Item 3: Watch list
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: SvgPicture.asset(
                      'assets/Save.svg',
                      height: 21,
                      width: 21,
                      // ignore: deprecated_member_use
                      color: controller.index.value == 2
                          ? const Color(0xFF0296E5)
                          : const Color(0xFF67686D),
                    ),
                  ),
                  label: 'Watch list',
                  tooltip: 'Your WatchList',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
