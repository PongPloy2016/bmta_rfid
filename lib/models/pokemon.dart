import 'dart:convert';

class Pokemon {
  final String id;
  final String name;
  final String imageUrl;
  final String imageUrlHiRes;
  final List<String> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.imageUrlHiRes,
    required this.types,
  });

  String toJson() {
    Map<String, dynamic> json = _fromMapJson();
    return jsonEncode(json);
  }

  Map<String, dynamic> _fromMapJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'imageUrlHiRes': imageUrlHiRes,
      'types': types,
    };
  }

  static Pokemon fromJson(String json) {
    if (json.isEmpty) {
      throw ArgumentError("Empty JSON string provided.");
    }

    // Decode the JSON safely, handling potential errors
    Map<String, dynamic> map;
    try {
      map = jsonDecode(json);
    } catch (e) {
      throw FormatException("Error decoding JSON: $e");
    }

    return fromMapJson(map);
  }

  static Pokemon fromMapJson(Map<String, dynamic> map) {
    return Pokemon(
      id: map['id'] ?? '', // Default to empty string if not found
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      imageUrlHiRes: map['imageUrlHiRes'] ?? '',
      types: map['types'] is List ? List<String>.from(map['types']) : [],
    );
  }
}