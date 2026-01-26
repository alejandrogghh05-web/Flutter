import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/api/api.dart';
import 'package:movies/api/api_service.dart';
import 'package:movies/models/actors.dart';
import 'package:movies/screens/actor_details_screen.dart';

class TopRatedActor extends StatelessWidget {
  const TopRatedActor({
    super.key,
    required this.actor,
    required this.index,
  });

  final Actor actor;
  final int index;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          // Imagen del actor
          GestureDetector(
            onTap: () async {
              // Mostrar indicador de carga
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );
              
              final actorId = actor.id;
              
              // Obtener detalles completos del actor desde la API
              final actorDetails = await ApiService.getActorDetails(actorId);
              
              // Cerrar el icono de carga
              Get.back();
              
              if (actorDetails != null) {
                // Navegar con los datos completos del actor
                Get.to(ActorDetailsScreen(actor: actorDetails));
              }
            },
            child: Stack(
              children: [
                Container(
                  width: 150,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: actor.profilePath != null 
                        ? Colors.transparent 
                        : const Color(0xff20252d),
                  ),
                  child: actor.profilePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            Api.imageBaseUrl + actor.profilePath!,
                            fit: BoxFit.cover,
                            width: 150,
                            height: 180,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white54,
                              ),
                            ),
                            loadingBuilder: (_, __, ___) {
                              if (___ == null) return __;
                              return const FadeShimmer(
                                width: 150,
                                height: 180,
                                highlightColor: Color(0xff22272f),
                                baseColor: Color(0xff20252d),
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white54,
                          ),
                        ),
                ),
                // Número de ranking
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Nombre del actor
          const SizedBox(height: 8),
          SizedBox(
            width: 150,
            child: Text(
              actor.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Popularidad
          Text(
            '⭐ ${actor.popularity.toStringAsFixed(1)}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}