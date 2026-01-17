import 'package:flutter/material.dart'; 
import 'package:get/get.dart'; 
import 'package:movies/api/api.dart'; 
import 'package:movies/api/api_service.dart'; 
import 'package:movies/models/actors.dart'; 
import 'package:movies/models/movie.dart'; 
import 'package:movies/screens/details_screen.dart'; 

// Pantalla que muestra información detallada de un actor al que se le ha hecho tap

class ActorDetailsScreen extends StatelessWidget {
  final Actor actor; // Recibe un objeto Actor como parámetro obligatorio
  
  const ActorDetailsScreen({
    super.key, 
    required this.actor, 
  });
  
  @override
  Widget build(BuildContext context) {
    // Scaffold es el contenedor principal de la pantalla
    return Scaffold(
      backgroundColor: const Color(0xFF242A32),// Color de fondo
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF242A32), // Mismo color que el fondo
            leading: IconButton( // Botón de retroceso 
              onPressed: () => Get.back(), 
              icon: Container(
                padding: const EdgeInsets.all(6), 
                decoration: BoxDecoration(
                  color: Colors.black, 
                  borderRadius: BorderRadius.circular(20), // Bordes redondeados
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            title: const Text(
              'Actor Details', // Título de la pantalla
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            centerTitle: true, // Centra el título
            pinned: true, 
            floating: false, 
            elevation: 0, 
          ),
          SliverList(
            delegate: SliverChildListDelegate([ 
              // Sección de imagen del actor
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),// Padding alrededor de la imagen del actor
                child: Column(
                  children: [
                    // Contenedor de la imagen
                    Container(
                      width: Get.width * 0.2, // Ocupa el 20% del ancho de la pantalla
                      height: Get.width * 0.2 * 1.5, // Altura basada en proporción 1:1.5 (poster)
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12), 
                      ),
                      child: ClipRRect( 
                        borderRadius: BorderRadius.circular(12),
                        child: actor.profilePath != null 
                            ? Image.network( 
                                Api.imageBaseUrl + actor.profilePath!, 
                                fit: BoxFit.cover, // La imagen cubre todo el espacio
                                width: Get.width * 0.2,//mismas proporciones
                                height: Get.width * 0.2 * 1.5,
                              )
                            : Container( // Si el actor no tiene imagen, muestra ícono
                                color: const Color(0xff20252d),
                                child: const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 80,
                                    color: Colors.white54,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20), // Espacio vertical entre la imagen y el nombre
                  ],
                ),
              ),
              // Tarjeta de información principal del actor
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Margen externo
                padding: const EdgeInsets.all(20), // Padding interno
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3F47), 
                  borderRadius: BorderRadius.circular(16), 
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsRow(),
                    
                    const SizedBox(height: 24),
                    
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600, // Negrita
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 16), // Espacio entre título y contenido
                    
                    Column(
                      children: [
                        // Muestra cumpleaños solo si existe
                        if (actor.birthday != null)
                          _buildInfoCard('Birthday', actor.birthday!), // Tarjeta de información
                        
                        // Muestra lugar de nacimiento solo si existe
                        if (actor.placeOfBirth != null)
                          _buildInfoCard('Place of Birth', actor.placeOfBirth!),
                        
                        // Siempre muestra estado (vivo/fallecido)
                        _buildInfoCard('Status', actor.isAlive ? 'Alive' : 'Deceased'),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Sección de biografía del actor
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20), // Padding horizontal
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título de la sección
                    const Text(
                      'Biography',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 12), // Espacio entre título y contenido
                    
                    // Contenedor del texto de biografía
                    Container(
                      padding: const EdgeInsets.all(20), // Padding interno
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A3F47), 
                        borderRadius: BorderRadius.circular(16), 
                      ),
                      child: Text(
                        // Muestra biografía o mensaje por defecto
                        actor.biography.isNotEmpty 
                            ? actor.biography
                            : 'No biography available.',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300, // Texto más delgado
                          color: Colors.white70, 
                          height: 1.6, // Interlineado para mejor legibilidad
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Sección de películas en las que ha participado el actor
              _buildActorMoviesSection(), // Método que construye esta sección de forma asíncrona
            ]),
          ),
        ],
      ),
    );
  }
  
  // Retorna un Widget que muestra las películas obtenidas de la API
  Widget _buildActorMoviesSection() {
    return FutureBuilder<List<Movie>?>( 
      future: ApiService.getActorMovies(actor.id), 
      builder: (context, snapshot) {
        final movies = snapshot.data!; // Extrae la lista de películas
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título de la sección de películas
              const Text(
                'Movies',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 12), // Espacio entre título y grid
              
              // GridView para mostrar las películas en formato de cuadrícula
              GridView.builder(
                shrinkWrap: true, 
                physics: const NeverScrollableScrollPhysics(), 
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // 5 columnas en el grid
                  crossAxisSpacing: 8, // Espacio horizontal entre items
                  mainAxisSpacing: 12, // Espacio vertical entre items
                  childAspectRatio: 0.5, // Relación ancho/alto (0.5 significa más alto que ancho)
                ),
                itemCount: movies.length, // Número total de películas
                itemBuilder: (context, index) {
                  final movie = movies[index]; // Película actual
                  return Column( // Cada ítem del grid es una columna (poster + info)
                    children: [
                      // Contenedor del poster de la película
                      Container(
                        width: 250, // Ancho fijo 
                        height: 500, // Alto fijo 
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8), 
                        ),
                        child: GestureDetector(
                          onTap: () => Get.to( // Navega a pantalla de detalles de la película
                            () => DetailsScreen.movie(movie: movie), // Constructor de pantalla
                          ),
                          child: ClipRRect( 
                            borderRadius: BorderRadius.circular(8),
                            child: movie.posterPath.isNotEmpty // Verifica si tiene poster
                                ? Image.network( // Carga imagen desde la red
                                    'https://image.tmdb.org/t/p/w185${movie.posterPath}', // URL del poster
                                    fit: BoxFit.cover, // La imagen cubre todo el espacio
                                    width: double.infinity,
                                    height: 120,
                                  )
                                : Container( // Si no hay poster, muestra ícono
                                    color: const Color(0xff20252d),
                                    child: const Center(
                                      child: Icon(
                                        Icons.movie,
                                        size: 40,
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 6), // Espacio entre poster y título
                      
                      // Título de la película
                      Text(
                        movie.title,
                        textAlign: TextAlign.center, // Centra el texto
                        style: const TextStyle(
                          fontSize: 11, 
                          fontWeight: FontWeight.w500, // Semi-negrita
                          color: Colors.white,
                          height: 1.2, // Interlineado 
                        ),
                        maxLines: 2, // Máximo 2 líneas
                        overflow: TextOverflow.ellipsis, // Puntos suspensivos si es muy largo
                      ),
                      
                      const SizedBox(height: 4), // Espacio entre título y año
                      
                      // Año de lanzamiento (si está disponible)
                      if (movie.releaseDate.isNotEmpty && movie.releaseDate.length >= 4)
                        Text(
                          movie.releaseDate.substring(0, 4), // Extrae solo el año
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w300, 
                            color: Colors.white70, 
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Método privado que construye la fila de informacion del actor
  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.all(16), 
      decoration: BoxDecoration(
        color: Colors.black, 
        borderRadius: BorderRadius.circular(12), 
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Espacia los items uniformemente
        children: [
          // Item 1: Popularidad
          _buildStatItem(
            icon: Icons.star,
            value: actor.popularity.toStringAsFixed(1), // Formatea a 1 decimal
            label: 'Popularity',
          ),
          
          Container(
            height: 40,
            width: 1, // Línea delgada
            color: Colors.white, // Color blanco
          ),
          
          // Item 2: Género
          _buildStatItem(
            icon: Icons.movie,
            value: actor.gender == 1 ? 'Female' : 'Male', // Convierte código numérico a texto
            label: 'Gender',
          ),
          
          // Separador vertical
          Container(
            height: 40,
            width: 1,
            color: Colors.white,
          ),
          
          // Item 3: Contenido para adultos
          _buildStatItem(
            icon: Icons.check_circle,
            value: actor.adult ? 'Adult' : 'Not Adult',
            label: 'Content',
          ),

          // Separador vertical
          Container(
            height: 40,
            width: 1,
            color: Colors.white,
          ),
          
          // Item 4: Edad
          _buildStatItem(
            icon: Icons.check_circle,
            value: actor.age != null ? '${actor.age}' : 'Unknown', // Maneja caso nulo
            label: 'Age',
          ),
        ],
      ),
    );
  }
  
  // Método privado que construye un item individual de estadística
  Widget _buildStatItem({
    required IconData icon, 
    required String value, 
    required String label,
  }) {
    return Column( // Organiza ícono, valor y etiqueta verticalmente
      children: [
        Icon(
          icon,
          color: const Color(0xFF0296E5),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600, // Negrita para el valor
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2), 
        Text(
          label,
          style: TextStyle(
            fontSize: 12, // Más pequeño que el valor
            fontWeight: FontWeight.w400, // Peso normal
            color: Colors.white, // Mismo color pero más pequeño
          ),
        ),
      ],
    );
  }
  
  // Método privado que construye una tarjeta de información (etiqueta + valor)
  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity, // Ocupa todo el ancho disponible
      margin: const EdgeInsets.only(bottom: 12), // Margen inferior para separar tarjetas
      padding: const EdgeInsets.all(16), // Padding interno
      decoration: BoxDecoration(
        color: Colors.black, // Fondo negro
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        border: Border.all( // Borde blanco
          color: Colors.white,
          width: 1, // Grosor del borde
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70, 
              ),
            ),
          ),
          Expanded( 
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400, 
                color: Colors.white, 
              ),
              textAlign: TextAlign.right, 
            ),
          ),
        ],
      ),
    );
  }
}