// lib/models/pet.dart

class Pet {
  final String id;
  final String name;
  final String? imagePath; // Path to image (from image picker or assets)
  final String? breed;
  final DateTime? birthDate;
  final String? species; // dog, cat, etc.

  Pet({
    required this.id,
    required this.name,
    this.imagePath,
    this.breed,
    this.birthDate,
    this.species,
  });

  // Create a copy of pet with modified fields
  Pet copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? breed,
    DateTime? birthDate,
    String? species,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      breed: breed ?? this.breed,
      birthDate: birthDate ?? this.birthDate,
      species: species ?? this.species,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'breed': breed,
      'birthDate': birthDate?.toIso8601String(),
      'species': species,
    };
  }

  // Create from JSON
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      imagePath: json['imagePath'],
      breed: json['breed'],
      birthDate: json['birthDate'] != null 
          ? DateTime.parse(json['birthDate']) 
          : null,
      species: json['species'],
    );
  }
}