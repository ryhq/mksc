class Vegetable {
  final int id;
  // This id changes daily based on the data collected per day
  final int? tempId; 
  final String name;
  final String image;
  final String? number;
  final String? camp;
  final String? unit;
  final bool isLocal;
  final bool isConflict;
  final String? created_at;
  final String? updatedAt;

  Vegetable({
    required this.id, 
    required this.tempId, 
    required this.name, 
    required this.image, 
    required this.number, 
    required this.camp, 
    required this.unit,
    this.isLocal = false,
    this.isConflict = false,
    required this.created_at,
    required this.updatedAt,
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
      created_at: json['created_at'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
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
      'isLocal': isLocal,
      'isConflict': isConflict,
      'unit': unit,
      'created_at': created_at,
      'updatedAt': updatedAt
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
    bool? isLocal,
    bool? isConflict,
    String? created_at,
    String? updatedAt
  }) {
    return Vegetable(
      id: id ?? this.id,
      tempId: tempId ?? this.tempId,
      name: name ?? this.name,
      image: image ?? this.image,
      number: number ?? this.number,
      camp: camp ?? this.camp,
      unit: unit ?? this.unit,
      isLocal: isLocal ?? this.isLocal,
      isConflict: isConflict ?? this.isConflict,
      created_at: created_at ?? this.created_at,
      updatedAt: updatedAt ?? this.updatedAt
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
      isLocal: false,
      isConflict: false,
      created_at: "",
      updatedAt: "",
    );
  }
}
