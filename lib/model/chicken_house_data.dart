class ChickenHouseData {
  final int id;
  final String item;
  final int number;
  final String? created_at;
  final String? updatedAt;

  ChickenHouseData({
    required this.id,
    required this.item,
    required this.number,
    required this.created_at,
    required this.updatedAt,
  });

  factory ChickenHouseData.fromJson(Map<String, dynamic> json) {
    return ChickenHouseData(
      id: json['id'] ?? 0,
      item: json['item'] ?? "",
      number: (json['number'] is int)
          ? json['number'] // If 'number' is int, use it directly
          : int.tryParse(json['number'].toString()) ??
              0, // If 'number' is String, try to parse, else default to 0
      created_at: json['created_at'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item': item,
      'number': number,
      'created_at': number,
      'updatedAt': number,
    };
  }

  ChickenHouseData copyWith(
      {int? id,
      String? item,
      int? number,
      String? created_at,
      String? updatedAt}) {
    return ChickenHouseData(
        id: id ?? this.id,
        item: item ?? this.item,
        number: number ?? this.number,
        created_at: created_at ?? this.created_at,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  static ChickenHouseData empty() {
    return ChickenHouseData(
      id: 0,
      item: "",
      number: 0,
      created_at: "",
      updatedAt: "",
    );
  }
}
