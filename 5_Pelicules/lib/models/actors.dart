import 'dart:convert';

class Actor {
  int id;
  String name;
  String biography;
  String? birthday;
  String? deathday;
  String? placeOfBirth;
  double popularity;
  String? profilePath;
  int gender;
  bool adult;
  List<String> alsoKnownAs;

  Actor({
    required this.id,
    required this.name,
    required this.biography,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    required this.popularity,
    required this.gender,
    required this.adult,
    required this.alsoKnownAs,
    this.profilePath,
  });

  factory Actor.fromMap(Map<String, dynamic> map) {
    return Actor(
      id: map['id'] as int? ?? 0,
      name: map['name']?.toString() ?? '', // Asegurar string
      biography: map['biography']?.toString() ?? '', // Asegurar string
      birthday: map['birthday']?.toString(), // Puede ser null
      deathday: map['deathday']?.toString(), // Puede ser null
      placeOfBirth: map['place_of_birth']?.toString(), // Puede ser null
      popularity: (map['popularity'] as num?)?.toDouble() ?? 0.0,
      gender: map['gender'] as int? ?? 0,
      adult: map['adult'] as bool? ?? false,
      profilePath: map['profile_path']?.toString(), // Puede ser null
      alsoKnownAs: (map['also_known_as'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
    );
  }

  factory Actor.fromJson(String source) => Actor.fromMap(json.decode(source));

  int? get age {
    if (birthday == null || birthday!.isEmpty) return null;
    final birthDate = DateTime.tryParse(birthday!);
    if (birthDate == null) return null;
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  bool get isAlive => deathday == null || deathday!.isEmpty;
}