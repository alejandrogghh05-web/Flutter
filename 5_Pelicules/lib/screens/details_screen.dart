import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/controllers/movies_controller.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actors.dart';
import 'package:movies/models/review.dart';
import 'package:movies/utils/utils.dart';
import 'package:movies/screens/actor_details_screen.dart';

class DetailsScreen extends StatelessWidget {
  final Movie? movie; 
  final Actor? actor;  
  
  // Constructor para pantalla de detalles de película
  const DetailsScreen.movie({
    super.key,
    required this.movie,
  }) : actor = null;
  
  // Constructor para pantalla de detalles de actor (luego adaptar que se hara otra clase)
  const DetailsScreen.actor({
    super.key,
    required this.actor,
  }) : movie = null;
  

  // Propiedad para verificar si es una pantalla de actor o movie
  bool get isMovie => movie != null;
  bool get isActor => actor != null;
  
  @override
  Widget build(BuildContext context) {
    // Decide qué pantalla mostrar basado en los datos proporcionados
    if (isMovie) {
      return _buildMovieDetails(context);
    } else{
      return ActorDetailsScreen(actor: actor!);
    }
  }
  
  // Método para construir la pantalla de detalles de película
  Widget _buildMovieDetails(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Barra superior con botones de navegación
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 34),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Botón para volver atrás
                    IconButton(
                      tooltip: 'Back to home',
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    // Título de la pantalla
                    const Text(
                      'Detail',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                      ),
                    ),
                    // Botón para añadir/remover de watchlist
                    Tooltip(
                      message: 'Save this movie to your watch list',
                      triggerMode: TooltipTriggerMode.tap,
                      child: IconButton(
                        onPressed: () {
                          Get.find<MoviesController>().addToWatchList(movie!);
                        },
                        icon: Obx(
                          // Icono cambia según si está en watchlist o no
                          () => Get.find<MoviesController>().isInWatchList(movie!)
                              ? const Icon(
                                  Icons.bookmark,
                                  color: Colors.white,
                                  size: 33,
                                )
                              : const Icon(
                                  Icons.bookmark_outline,
                                  color: Colors.white,
                                  size: 33,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Contenedor de imágenes de la película
              SizedBox(
                height: 400,
                child: Stack(
                  children: [
                    // Imagen de fondo grande (backdrop)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      child: Image.network(
                        Api.imageBaseUrl + movie!.backdropPath,
                        width: Get.width,
                        height: Get.height,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Imagen pequeña del póster en la esquina inferior izquierda
                    Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500/${movie!.posterPath}',
                            width: 110,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Título de la película superpuesto sobre las imágenes
                    Positioned(
                      top: 255,
                      left: 155,
                      child: SizedBox(
                        width: 230,
                        child: Text(
                          movie!.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // Calificación con estrella en la esquina superior derecha
                    Positioned(
                      top: 200,
                      right: 30,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color.fromRGBO(37, 40, 54, 0.52),
                        ),
                        child: Row(
                          children: [
                            // Icono de estrella SVG
                            SvgPicture.asset('assets/Star.svg'),
                            const SizedBox(width: 5),
                            Text(
                              movie!.voteAverage == 0.0
                                  ? 'N/A'  // Muestra "N/A" si no hay calificación
                                  : movie!.voteAverage.toStringAsFixed(1), // Un decimal
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFFF8700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // Fila con información básica: año y géneros
              Opacity(
                opacity: .6,
                child: SizedBox(
                  width: Get.width / 1.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Año de estreno
                      Row(
                        children: [
                          SvgPicture.asset('assets/calender.svg'),
                          const SizedBox(width: 5),
                          Text(
                            movie!.releaseDate.split('-')[0], // Extrae el año
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      // Géneros de la película
                      Row(
                        children: [
                          SvgPicture.asset('assets/Ticket.svg'),
                          const SizedBox(width: 5),
                          Text(
                            Utils.getGenres(movie!), // Obtiene géneros formateados
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Tabs con información detallada de la película
              Padding(
                padding: const EdgeInsets.all(24),
                child: DefaultTabController(
                  length: 3, // 3 pestañas: About Movie, Reviews, Cast
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Barra de pestañas
                      const TabBar(
                          indicatorWeight: 4,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Color(0xFF3A3F47),
                          tabs: [
                            Tab(text: 'About Movie'), 
                            Tab(text: 'Reviews'),     
                            Tab(text: 'Cast'),        
                          ]),
                      // Contenido de las pestañas
                      SizedBox(
                        height: 400,
                        child: TabBarView(children: [
                          // Pestaña 1: Descripción de la película
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              movie!.overview.isNotEmpty 
                                  ? movie!.overview  // Sinopsis
                                  : 'No description available.', // Mensaje por defecto
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                height: 1.5, // Espaciado entre líneas
                              ),
                            ),
                          ),
                          // Pestaña 2: Reseñas de la película
                          FutureBuilder<List<Review>?>(
                            future: ApiService.getMovieReviews(movie!.id),
                            builder: (_, snapshot) {

                              // Lista de reseñas
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (_, index) => Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Avatar y calificación del revisor
                                      Column(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/avatar.svg',
                                            height: 50,
                                            width: 50,
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                            snapshot.data![index].rating.toString(),
                                            style: const TextStyle(
                                              color: Color(0xff0296E5),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      // Autor y comentario de la reseña
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data![index].author,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              snapshot.data![index].comment,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          // Pestaña 3: Reparto de actores
                          FutureBuilder<List<dynamic>?>(
                            future: ApiService.getMovieCast(movie!.id),
                            builder: (context, snapshot) {
                              final cast = snapshot.data!;
                              
                              // Grid de actores - muestra fotos y nombres
                              return GridView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8), 
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5, // Columnas
                                  crossAxisSpacing: 6, // espacio horizontal 
                                  mainAxisSpacing: 4, // espacio vertical 
                                ),
                                itemCount: cast.length,
                                itemBuilder: (context, index) {
                                  final actorData = cast[index];
                                  final profilePath = actorData['profile_path']; // Ruta de la foto
                                  final name = actorData['name'] ?? 'Unknown'; // Nombre del actor
                                  final character = actorData['character']; // Personaje que interpreta
                                  
                                  return GestureDetector(
                                    onTap: () async {
                                      // Mostrar indicador de carga
                                      Get.dialog(
                                        const Center(child: CircularProgressIndicator()),
                                        barrierDismissible: false,
                                      );
                                        // Asegurarnos de que tenemos un ID válido
                                        final actorId = actorData['id'];
                                        // Obtener detalles completos del actor desde la API
                                        final actorDetails = await ApiService.getActorDetails(actorId);
                                        // Cerrar el diálogo de carga
                                        Get.back();
                                        if (actorDetails != null) {
                                          // Navegar con los datos completos del actor
                                          Get.to(ActorDetailsScreen(actor: actorDetails));
                                        }
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start, 
                                      mainAxisSize: MainAxisSize.min, 
                                      children: [
                                        Container(
                                          width: 150, 
                                          height: 150, 
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white24,
                                              width: 2, 
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: profilePath != null
                                                ? Image.network(
                                                    'https://image.tmdb.org/t/p/w185$profilePath',
                                                    width: 150,
                                                    height: 150,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    // Contenedor para actor sin foto - más pequeño
                                                    color: const Color(0xff20252d),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.person,
                                                        size: 75,
                                                        color: Colors.white54,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        
                                        // Nombre del actor 
                                        Text(
                                          name,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 14, 
                                            fontWeight: FontWeight.w500,
                                            height: 1.5, 
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis, // Puntos suspensivos si es muy largo
                                        ),
                                        
                                        // Personaje que interpreta 
                                        if (character != null && character.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 2),
                                            child: Text(
                                              character,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 14, 
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white70,
                                                fontStyle: FontStyle.italic, // Cursiva para el personaje
                                                height: 1.5, 
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}