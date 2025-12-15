import 'dart:io';
import 'dart:convert';

class ElementosAPI {
  final int id;
  final String name;
  final String mythology;
  final String description;
  final String shortDescription;
  final String image;
  final String imageLogo; 
  final double rating;

  ElementosAPI({
    required this.id,
    required this.name,
    required this.mythology,
    required this.description,
    required this.shortDescription,
    required this.image,
    required this.imageLogo, 
    this.rating = 10.0,
  });

  // conección con la api.
  static Future<ElementosAPI?> fetchFromApi(int id) async {
    final http = HttpClient();
    
    final uri = Uri.https(
      '692c7f5fc829d464006fbe33.mockapi.io',
      '/apiProva/v1/$id'
    );

    final request = await http.getUrl(uri);
    final response = await request.close();

    if (response.statusCode != 200) {
      return null;
    }

    final responseBody = await response.transform(utf8.decoder).join();
    final decodedJson = json.decode(responseBody) as Map<String, dynamic>;

    return ElementosAPI.fromJson(decodedJson);
  }

  // Factory constructor from JSON - UPDATED to include imageLogo
  factory ElementosAPI.fromJson(Map<String, dynamic> json) {
    // Parse ID safely
    int parsedId;
    final idValue = json['id'];
    
    if (idValue is String) {
      parsedId = int.tryParse(idValue) ?? 0;
    } else if (idValue is int) {
      parsedId = idValue;
    } else {
      parsedId = 0;
    }
    
    // Parse rating safely
    double parsedRating;
    final ratingValue = json['rating'];
    
    if (ratingValue is num) {
      parsedRating = ratingValue.toDouble();
    } else if (ratingValue is String) {
      parsedRating = double.tryParse(ratingValue) ?? 10.0;
    } else {
      parsedRating = 10.0;
    }
    
    return ElementosAPI(
      id: parsedId,
      name: json['name'] as String? ?? '',
      mythology: json['mythology'] as String? ?? '',
      description: json['description'] as String? ?? '',
      shortDescription: json['short_description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      imageLogo: json['imageLogo'] as String? ?? '',
      rating: parsedRating,
    );
  }

  // en teoria pasa los datos actuales al json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mythology': mythology,
      'description': description,
      'short_description': shortDescription,
      'image': image,
      'imageLogo': imageLogo,
      'rating': rating,
    };
  }
}