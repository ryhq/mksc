class ChickenHouseData {
  final int id;
  final String item;
  final int number;
  final String? createdAt;
  final String? updatedAt;

  ChickenHouseData({
    required this.id, 
    required this.item, 
    required this.number,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChickenHouseData.fromJson(Map<String, dynamic> json) {
    return ChickenHouseData(
      id: json['id'] ?? 0,
      item: json['item'] ?? "",
      number: (json['number'] is int)
          ? json['number'] // If 'number' is int, use it directly
          : int.tryParse(json['number'].toString()) ?? 0, // If 'number' is String, try to parse, else default to 0
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
    );
  }                     

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item': item,
      'number': number,
      'createdAt': number,
      'updatedAt': number,
    };
  }

  ChickenHouseData copyWith({
    int? id,
    String? item,
    int? number,
    String? createdAt,
    String? updatedAt
  }) {
    return ChickenHouseData(
      id: id ?? this.id, 
      item: item ?? this.item, 
      number: number ?? this.number,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt
    );
  }
  
  static ChickenHouseData empty() {
    return ChickenHouseData(
      id: 0,        
      item: "",     
      number: 0,    
      createdAt: "",     
      updatedAt: "", 
    );
  }
}