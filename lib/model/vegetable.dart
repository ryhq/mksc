class Vegetable {
  final int id;
  final int? tempId; // This id changes daily based on the data collected per day
  final String name;
  final String image;
  final String? number;
  final String? camp;
  final String? unit;
  final bool offline;
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
    this.offline = false,
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
    bool? offline,
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
      offline: offline ?? this.offline,
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
      offline: false,
      created_at: "",
      updatedAt: "",
    );
  }
}
