import 'dart:convert';
import 'package:movies/api/api.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/actors.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/review.dart';

class ApiService {
  static Future<List<Movie>?> getTopRatedMovies() async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/top_rated?api_key=${Api.apiKey}&language=en-US&page=1'));
      
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        res['results'].skip(6).take(5).forEach(
              (m) => movies.add(
                Movie.fromMap(m),
              ),
            );
        return movies;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getCustomMovies(String url) async {
    List<Movie> movies = [];
    try {
      String fullUrl = url.contains('api_key=') 
          ? '${Api.baseUrl}movie/$url'
          : '${Api.baseUrl}movie/$url?api_key=${Api.apiKey}&language=en-US';
      
      http.Response response = await http.get(Uri.parse(fullUrl));
      
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        res['results'].take(6).forEach(
              (m) => movies.add(
                Movie.fromMap(m),
              ),
            );
        return movies;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getSearchedMovies(String query) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}search/movie?api_key=${Api.apiKey}&language=en-US&query=$query&page=1&include_adult=false'));
      
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        res['results'].forEach(
          (m) => movies.add(
            Movie.fromMap(m),
          ),
        );
        return movies;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Review>?> getMovieReviews(int movieId) async {
    List<Review> reviews = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}movie/$movieId/reviews?api_key=${Api.apiKey}&language=en-US&page=1'));
      
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        res['results'].forEach(
          (r) {
            reviews.add(
              Review(
                author: r['author'],
                comment: r['content'],
                rating: r['author_details']['rating'] is int 
                    ? r['author_details']['rating'].toDouble()
                    : (r['author_details']['rating']?.toDouble() ?? 0.0),
              ),
            );
          },
        );
        return reviews;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  
//Codigo Nuevo

  static Future<List<Actor>?> getPopularActors() async {
    try {
      final url = '${Api.baseUrl}person/popular?api_key=${Api.apiKey}&language=en-US&page=1';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List<dynamic>?;
        
        if (results == null || results.isEmpty) {
          return [];
        }
        
        final actors = results.take(10).map((actorData) {
          try {
            return Actor(
              id: actorData['id'] as int? ?? 0,
              name: actorData['name']?.toString() ?? 'Unknown',
              biography: actorData['biography']?.toString() ?? '',
              birthday: actorData['birthday']?.toString(),
              deathday: actorData['deathday']?.toString(),
              placeOfBirth: actorData['place_of_birth']?.toString(),
              popularity: (actorData['popularity'] as num?)?.toDouble() ?? 0.0,
              gender: actorData['gender'] as int? ?? 0,
              adult: actorData['adult'] as bool? ?? false,
              profilePath: actorData['profile_path']?.toString(),
              alsoKnownAs: (actorData['also_known_as'] as List<dynamic>?)
                      ?.map((e) => e.toString())
                      .toList() ??
                  [],
            );
          } catch (e) {
            return Actor(
              id: actorData['id'] as int? ?? 0,
              name: actorData['name']?.toString() ?? 'Unknown Actor',
              biography: '',
              birthday: null,
              deathday: null,
              placeOfBirth: null,
              popularity: 0.0,
              gender: 0,
              adult: false,
              profilePath: actorData['profile_path']?.toString(),
              alsoKnownAs: [],
            );
          }
        }).toList();
        
        return actors;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  
  static Future<List<dynamic>?> getMovieCast(int movieId) async {
    try {
      final url = '${Api.baseUrl}movie/$movieId/credits?api_key=${Api.apiKey}&language=en-US';
      http.Response response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        return res['cast'].take(12).toList();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Actor?> getActorDetails(int actorId) async {
    try {
      final url = '${Api.baseUrl}person/$actorId?api_key=${Api.apiKey}&language=en-US';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final actorData = jsonDecode(response.body);
        
        return Actor(
          id: actorData['id'] as int? ?? 0,
          name: actorData['name']?.toString() ?? 'Unknown',
          biography: actorData['biography']?.toString() ?? '',
          birthday: actorData['birthday']?.toString(),
          deathday: actorData['deathday']?.toString(),
          placeOfBirth: actorData['place_of_birth']?.toString(),
          popularity: (actorData['popularity'] as num?)?.toDouble() ?? 0.0,
          gender: actorData['gender'] as int? ?? 0,
          adult: actorData['adult'] as bool? ?? false,
          profilePath: actorData['profile_path']?.toString(),
          alsoKnownAs: (actorData['also_known_as'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> getActorMovies(int actorId) async {
    List<Movie> movies = [];
    
      final url = '${Api.baseUrl}person/$actorId/movie_credits?api_key=${Api.apiKey}&language=en-US';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final castResults = data['cast'] as List<dynamic>?;
        
        if (castResults == null || castResults.isEmpty) {
          return [];
        }
        
        // Ordenar por fecha de lanzamiento 
        castResults.sort((a, b) {
          final dateA = a['release_date']?.toString() ?? '';
          final dateB = b['release_date']?.toString() ?? '';
          return dateB.compareTo(dateA); 
        });
        
        // Tomar TODAS las películas 
        for (final movieData in castResults) {
          try {
            movies.add(Movie(
              id: movieData['id'] as int? ?? 0,
              title: movieData['title']?.toString() ?? 'Unknown',
              posterPath: movieData['poster_path']?.toString() ?? '',
              backdropPath: movieData['backdrop_path']?.toString() ?? '',
              overview: movieData['overview']?.toString() ?? '',
              releaseDate: movieData['release_date']?.toString() ?? '',
              voteAverage: (movieData['vote_average'] as num?)?.toDouble() ?? 0.0,
              genreIds: (movieData['genre_ids'] as List<dynamic>?)
                      ?.map((id) => id as int)
                      .toList() ??
                  [],
            ));
          } catch (e) {
            // Si hay error con una película, continuar con la siguiente
            continue;
          }
        }
        
        return movies;
      } else {
        return null;
      }
  }
}