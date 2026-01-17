import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/utils/utils.dart';

class Infos extends StatelessWidget {
  const Infos({super.key, required this.movie});
  final Movie movie;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,// Alinea a la izquierda
        mainAxisAlignment: MainAxisAlignment.spaceAround,// Espacia uniformemente
        children: [
          // Título de la película
          SizedBox(
            width: 200,  // Ancho limitado
            child: Text(
              movie.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,// Puntos suspensivos si es muy largo
              ),
            ),
          ),
          // Información adicional en columna
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating con estrella
              Row(
                children: [
                  SvgPicture.asset('assets/Star.svg'),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    movie.voteAverage == 0.0
                        ? 'N/A'
                        : movie.voteAverage.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                      color: Color(0xFFFF8700),// Color naranja para el rating
                    ),
                  ),
                ],
              ),
              // Géneros con icono de ticket
              Row(
                children: [
                  SvgPicture.asset('assets/Ticket.svg'),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    Utils.getGenres(movie),// Obtiene géneros formateados
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
              // Año de estreno con icono de calendario
              Row(
                children: [
                  SvgPicture.asset('assets/calender.svg'),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    movie.releaseDate.split('-')[0],// Extrae el año de la fecha
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
