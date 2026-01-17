import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/controllers/bottom_navigator_controller.dart';
import 'package:movies/controllers/movies_controller.dart';
import 'package:movies/controllers/actors_controller.dart';
import 'package:movies/controllers/search_controller.dart';
import 'package:movies/widgets/search_box.dart';
import 'package:movies/widgets/tab_builder.dart';
import 'package:movies/widgets/top_rated_item.dart';
import 'package:movies/widgets/top_rated_actor.dart';
import 'package:movies/screens/actor_details_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener controladores de GetX usando Get.find()
    final MoviesController moviesController = Get.find<MoviesController>();
    final ActorsController actorsController = Get.find<ActorsController>();
    final SearchController1 searchController = Get.find<SearchController1>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 42,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal de la pantalla
            const Text(
              'What do you want to see?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 24),

            // Barra de búsqueda para buscar películas
            SearchBox(
              onSumbit: () {
                String search = searchController.searchController.text;
                if (search.trim().isNotEmpty) {
                  // Limpiar campo de búsqueda después de enviar
                  searchController.searchController.text = '';
                  // Ejecutar búsqueda
                  searchController.search(search);
                  // Navegar a pantalla de búsqueda 
                  Get.find<BottomNavigatorController>().setIndex(1);
                  // Ocultar teclado virtual
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
            ),
            const SizedBox(height: 34),

            _buildMainTabs(moviesController, actorsController),
          ],
        ),
      ),
    );
  }

  // Método que construye las pestañas principales: Movies y Actors
  Widget _buildMainTabs(MoviesController moviesController, ActorsController actorsController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Controlador de tabs con 2 pestañas principales
        DefaultTabController(
          length: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TabBar(
                indicatorWeight: 3,
                indicatorColor: Color(0xFF0296E5),
                unselectedLabelColor: Colors.white70,
                labelColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
                isScrollable: false,
                padding: EdgeInsets.symmetric(horizontal: 20),
                // Texto de cada pestaña
                tabs: [
                  Tab(text: 'Movies'),  
                  Tab(text: 'Actors'),  
                ],
              ),
              
              const SizedBox(height: 24),
              
              SizedBox(
                height: 800, 
                child: TabBarView(
                  children: [
                    // Pestaña 1: Movies - Contenido completo
                    _buildMoviesTabContent(moviesController),
                    
                    // Pestaña 2: Actors
                    _buildActorsTab(actorsController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoviesTabContent(MoviesController controller) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMoviesSection(controller),
          
          const SizedBox(height: 34),
          
          // Sección de Discover Movies (categorías)
          _buildMovieCategories(),
          
          const SizedBox(height: 20), // Espacio extra al final
        ],
      ),
    );
  }

  // Método que construye la sección de películas mejor valoradas
  Widget _buildMoviesSection(MoviesController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección de películas
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Top Rated Movies',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Widget observable que reacciona a cambios en el controlador
        Obx(() {
          // Mostrar indicador de carga mientras se obtienen los datos
          if (controller.isLoading.value) {
            return SizedBox(
              height: 250,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    const Text(
                      'Loading movies...',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Lista horizontal de películas
          return SizedBox(
            height: 280,
            child: Column(
              children: [
                // Lista desplazable horizontalmente de películas
                Expanded(
                  child: ListView.separated(
                    // Número total de películas
                    itemCount: controller.mainTopRatedMovies.length,
                    // Optimización: la lista solo ocupa el espacio necesario
                    shrinkWrap: true,
                    // Dirección horizontal para desplazamiento lateral
                    scrollDirection: Axis.horizontal,
                    // Efecto de rebote al final del desplazamiento
                    physics: const BouncingScrollPhysics(),
                    // Separador entre elementos de la lista
                    separatorBuilder: (_, __) => const SizedBox(width: 20),
                    // Constructor de cada item de película
                    itemBuilder: (_, index) {
                      final movie = controller.mainTopRatedMovies[index];
                      // Widget personalizado para mostrar cada película
                      return TopRatedItem(
                        movie: movie,
                        index: index,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Método que construye el contenido de la pestaña de actores
  Widget _buildActorsTab(ActorsController controller) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de 5 actores principales (Top Actors)
          _buildTopActorsSection(controller),
          
          const SizedBox(height: 34),
          
          // Sección de lista completa de actores
          _buildAllActorsSection(controller),
          
          const SizedBox(height: 20), // Espacio extra al final
        ],
      ),
    );
  }

  // Método que construye la sección de 5 actores principales
  Widget _buildTopActorsSection(ActorsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección de actores principales
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Top Popular Actors',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Widget observable que reacciona a cambios en el controlador
        Obx(() {
          // Mostrar indicador de carga mientras se obtienen los datos
          if (controller.isLoading.value) {
            return SizedBox(
              height: 250,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    const Text(
                      'Loading actors...',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Mostrar mensaje si no hay actores disponibles
          if (controller.mainTopRatedActors.isEmpty) {
            return SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person,
                      size: 70,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No actors available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Calcular cuántos actores mostrar (máximo 5 para la sección principal)
          final topActorsToShow = controller.mainTopRatedActors.length > 5
              ? 5
              : controller.mainTopRatedActors.length;

          // Lista horizontal de actores principales
          return SizedBox(
            height: 280,
            child: Column(
              children: [
                // Lista desplazable horizontalmente de actores
                Expanded(
                  child: ListView.separated(
                    // Número de actores a mostrar (máximo 5)
                    itemCount: topActorsToShow,
                    // Optimización: la lista solo ocupa el espacio necesario
                    shrinkWrap: true,
                    // Dirección horizontal para desplazamiento lateral
                    scrollDirection: Axis.horizontal,
                    // Efecto de rebote al final del desplazamiento
                    physics: const BouncingScrollPhysics(),
                    // Separador entre elementos de la lista
                    separatorBuilder: (_, __) => const SizedBox(width: 20),
                    // Constructor de cada item de actor
                    itemBuilder: (_, index) {
                      final actor = controller.mainTopRatedActors[index];
                      // Widget personalizado para mostrar cada actor
                      return TopRatedActor(
                        actor: actor,
                        index: index,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Método que construye la sección de todos los actores
  Widget _buildAllActorsSection(ActorsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección de todos los actores
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'All Popular Actors',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Widget observable que reacciona a cambios en el controlador
        Obx(() {
          // Mostrar indicador de carga mientras se obtienen los datos
          if (controller.isLoading.value) {
            return SizedBox(
              height: 400,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    const Text(
                      'Loading all actors...',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Mostrar mensaje si no hay actores disponibles
          if (controller.mainTopRatedActors.isEmpty) {
            return SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.people,
                      size: 70,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No actors available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Usar todos los actores disponibles
          final allActors = controller.mainTopRatedActors;

          // Lista vertical de todos los actores
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Evitar conflicto de scroll
            itemCount: allActors.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, index) {
              final actor = allActors[index];
              
              return GestureDetector(
                onTap: () async {
                  // Mostrar indicador de carga
                  Get.dialog(
                    const Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );
                  
                  try {
                    // Obtener detalles completos del actor desde la API
                    final actorDetails = await ApiService.getActorDetails(actor.id);
                    
                    // Cerrar el diálogo de carga
                    Get.back();
                    
                    if (actorDetails != null) {
                      // Navegar con los datos completos del actor
                      Get.to(() => ActorDetailsScreen(actor: actorDetails));
                    } else {
                      // Si la API falla, navegar con datos básicos
                      Get.to(() => ActorDetailsScreen(actor: actor));
                    }
                  } catch (e) {
                    Get.back();
                    // En caso de error, navegar con datos básicos
                    Get.to(() => ActorDetailsScreen(actor: actor));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3F47),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Foto del actor
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white24,
                            width: 1.5,
                          ),
                        ),
                        child: ClipOval(
                          child: actor.profilePath != null
                              ? Image.network(
                                  Api.imageBaseUrl + actor.profilePath!,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: const Color(0xff20252d),
                                      child: const Center(
                                        child: CircularProgressIndicator(strokeWidth: 1),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xff20252d),
                                      child: const Center(
                                        child: Icon(
                                          Icons.person,
                                          size: 30,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: const Color(0xff20252d),
                                  child: const Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Información del actor
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nombre del actor
                            Text(
                              actor.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            const SizedBox(height: 4),
                            
                            // Popularidad
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  actor.popularity.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            
                            // Género (si está disponible)
                            if (actor.gender == 1)
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Text(
                                  'Female',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white60,
                                  ),
                                ),
                              )
                            else if (actor.gender == 2)
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Text(
                                  'Male',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white60,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // Ícono de flecha
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white54,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }

  // Método que construye las categorías de películas con tabs
  Widget _buildMovieCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección de categorías
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Discover Movies',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Controlador de tabs con 4 pestañas
        DefaultTabController(
          length: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Barra de pestañas
              const TabBar(
                // Grosor del indicador de pestaña activa
                indicatorWeight: 3,
                // Color del indicador de pestaña activa
                indicatorColor: Color(0xFF3A3F47),
                // Estilo del texto de las pestañas
                labelStyle: TextStyle(fontSize: 11.0),
                // Permite desplazamiento horizontal si hay muchas pestañas
                isScrollable: true,
                // Texto de cada pestaña
                tabs: [
                  Tab(text: 'Now playing'),  // Películas en cines ahora
                  Tab(text: 'Upcoming'),     // Próximos estrenos
                  Tab(text: 'Top rated'),    // Mejor valoradas
                  Tab(text: 'Popular'),      // Más populares
                ],
              ),
              // Contenido de las pestañas
              SizedBox(
                height: 400,
                child: TabBarView(
                  children: [
                    // Pestaña 1: Películas en cines ahora
                    TabBuilder(
                      future: ApiService.getCustomMovies(
                        'now_playing?api_key=${Api.apiKey}&language=en-US&page=1',
                      ),
                    ),
                    // Pestaña 2: Próximos estrenos
                    TabBuilder(
                      future: ApiService.getCustomMovies(
                        'upcoming?api_key=${Api.apiKey}&language=en-US&page=1',
                      ),
                    ),
                    // Pestaña 3: Películas mejor valoradas
                    TabBuilder(
                      future: ApiService.getCustomMovies(
                        'top_rated?api_key=${Api.apiKey}&language=en-US&page=1',
                      ),
                    ),
                    // Pestaña 4: Películas populares
                    TabBuilder(
                      future: ApiService.getCustomMovies(
                        'popular?api_key=${Api.apiKey}&language=en-US&page=1',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}