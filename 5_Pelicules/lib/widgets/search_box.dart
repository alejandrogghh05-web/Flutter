import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movies/controllers/search_controller.dart';


class SearchBox extends StatelessWidget {
  const SearchBox({
    required this.onSumbit,// Función que se ejecuta al buscar
    super.key,
  });
  final VoidCallback onSumbit;
  @override
  Widget build(BuildContext context) {
    return TextField(
      // Usa el controlador de búsqueda
      controller: Get.find<SearchController1>().searchController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        // Icono de búsqueda girado 
        suffixIcon: IconButton(
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(3.14),// Gira 180 grados
            child: SvgPicture.asset(
              'assets/Search.svg',
              width: 22,
              height: 22,
            ),
          ),
          onPressed: () => onSumbit(),// Ejecuta la búsqueda al tocar
        ),
        // Borde redondeado sin línea
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        // Estilo del texto de ayuda
        hintStyle: const TextStyle(
          color: Color(
            0xFF67686D,
          ),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        // Padding interno
        contentPadding: const EdgeInsets.only(
          left: 16,
          right: 0,
          top: 0,
          bottom: 0,
        ),
        filled: true,
        fillColor: const Color(0xFF3A3F47),  // Fondo gris oscuro
        hintText: 'Search',  // Texto de ayuda
      ),
      // Ejecuta la búsqueda al presionar Enter
      onSubmitted: (a) => onSumbit(),
    );
  }
}
