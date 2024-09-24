class Vegetable {
  final int id;
  final String name;
  final String image;

  Vegetable({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Vegetable.fromJson(Map<String, dynamic> json) {
    return Vegetable(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      image: json['image'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  Vegetable copyWith({
    int? id,
    String? name,
    String? image,
  }) {
    return Vegetable(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  static Vegetable empty() {
    return Vegetable(
      id: 0,
      name: "",
      image: "",
    );
  }
}
