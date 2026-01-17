import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/screens/details_screen.dart';
import 'package:movies/widgets/index_number.dart';

class TopRatedItem extends StatelessWidget {
  const TopRatedItem({
    super.key,
    required this.movie,//pelicula
    required this.index,//rank
  });

  final Movie movie;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Stack(// Superpone widgets
      children: [
        // Imagen de la película
        GestureDetector(
          onTap: () => Get.to(
            DetailsScreen.movie(movie: movie),// va a detalles
          ),
          child: Container(
            margin: const EdgeInsets.only(left: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                Api.imageBaseUrl + movie.posterPath,// URL del póster
                fit: BoxFit.cover,
                height: 250,
                width: 180,
                errorBuilder: (_, __, ___) => const Icon(// Icono si error
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
        ),
        // Número de ranking superpuesto
        Align(
          alignment: Alignment.bottomLeft,
          child: IndexNumber(number: (index+1)),// Muestra el número grande con efecto
        )
      ],
    );
  }
}
