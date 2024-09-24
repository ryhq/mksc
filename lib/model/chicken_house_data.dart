class ChickenHouseData {
  final int id;
  final String item;
  final int number;

  ChickenHouseData({
    required this.id, 
    required this.item, 
    required this.number
  });

  factory ChickenHouseData.fromJson(Map<String, dynamic> json) {
    return ChickenHouseData(
      id: json['id'] ?? 0,
      item: json['item'] ?? "",
      number: (json['number'] is int)
          ? json['number'] // If 'number' is int, use it directly
          : int.tryParse(json['number'].toString()) ?? 0, // If 'number' is String, try to parse, else default to 0
    );
  }                     

  Map<String, dynamic> toJson() {
    return {
      'taskId': id,
      'userId': item,
      'categoryId': number,
    };
  }

  ChickenHouseData copyWith({
    int? id,
    String? item,
    int? number,
  }) {
    return ChickenHouseData(
      id: id ?? this.id, 
      item: item ?? this.item, 
      number: number ?? this.number
    );
  }
  
  static ChickenHouseData empty() {
    return ChickenHouseData(
      id: 0,        
      item: "",     
      number: 0,
    );
  }
}