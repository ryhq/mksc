class Vegetable {
  final int id;
  final int? tempId; // This id changes daily based on the data collected per day
  final String name;
  final String image;
  final String? number;
  final String? camp;
  final String? unit;

  Vegetable({
    required this.id, 
    required this.tempId, 
    required this.name, 
    required this.image, 
    required this.number, 
    required this.camp, 
    required this.unit
  });


  factory Vegetable.fromJson(Map<String, dynamic> json) {
    return Vegetable(
      id: json['id'] ?? 0,
      tempId: json['id'] ?? 0,
      name: json['name'] ?? "",
      image: json['image'] ?? "",
      number: json['number'] ?? "",
      camp: json['camp'] ?? "",
      unit: json['unit'] ?? "",
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tempId': tempId,
      'name': name,
      'image': image,
      'number': number,
      'camp': camp,
      'unit': unit,
    };
  }

  Vegetable copyWith({
    int? id,
    int? tempId,
    String? name,
    String? image,
    String? number,
    String? camp,
    String? unit,
  }) {
    return Vegetable(
      id: id ?? this.id,
      tempId: tempId ?? this.tempId,
      name: name ?? this.name,
      image: image ?? this.image,
      number: number ?? this.number,
      camp: camp ?? this.camp,
      unit: unit ?? this.unit,
    );
  }

  static Vegetable empty() {
    return Vegetable(
      id: 0,
      tempId: 0,
      name: "",
      image: "",
      number: "",
      camp: "",
      unit: "",
    );
  }
}
