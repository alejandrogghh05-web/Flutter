class FavoriteCharacters {
  int? id;
  int? userId;
  String? name;
  String? origin;
  String? characterType;
  String? description;
  String? notes;

  FavoriteCharacters({
    this.id,
    this.userId,
    this.name,
    this.origin,
    this.characterType,
    this.description,
    this.notes,
  });

  FavoriteCharacters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    origin = json['origin'];
    characterType = json['character_type'];
    description = json['description'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['origin'] = origin;
    data['character_type'] = characterType;
    data['description'] = description;
    data['notes'] = notes;
    return data;
  }

  static List<FavoriteCharacters> fromJsonList(List? data) {
    if (data == null || data.isEmpty) return [];
    return data.map((e) => FavoriteCharacters.fromJson(e)).toList();
  }
}