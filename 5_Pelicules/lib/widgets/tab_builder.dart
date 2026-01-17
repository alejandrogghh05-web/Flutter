import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/screens/details_screen.dart';

class TabBuilder extends StatelessWidget {
  const TabBuilder({
    required this.future,// devuelve la lista de películas
    super.key,
  });
  final Future<List<Movie>?> future;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 12.0),
      child: FutureBuilder<List<Movie>?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Grid de películas cuando hay datos
            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),// No  scroll
              // shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,      // 3 columnas
                crossAxisSpacing: 15.0,  // Espacio horizontal entre items
                mainAxisSpacing: 15.0,   // Espacio vertical entre items
                childAspectRatio: 0.6,   // Relación ancho/alto
              ),
              itemCount: 6,  // Muestra máximo 6 películas
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Get.to(DetailsScreen.movie(movie: snapshot.data![index]));// Navega a pantalla de detalles al tocar
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500/${snapshot.data![index].posterPath}',// URL de la img
                    height: 300,
                    width: 180,
                    fit: BoxFit.cover,
                    // Icono si hay error
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      size: 180,
                    ),
                    loadingBuilder: (_, __, ___) {
                      // ignore: no_wildcard_variable_uses
                      if (___ == null) return __;
                      return const FadeShimmer(// Animación de carga
                        width: 180,
                        height: 250,
                        highlightColor: Color(0xff22272f),
                        baseColor: Color(0xff20252d),
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            // Spinner mientras carga
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
