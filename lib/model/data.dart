class Data {
  final int id;
  final String item;
  final String number;

  Data({
    required this.id, 
    required this.item, 
    required this.number
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] ?? 0, 
      item: json['item'] ?? "", 
      number: json['number'] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': id,
      'userId': item,
      'categoryId': number,
    };
  }

  Data copyWith({
    int? id,
    String? item,
    String? number,
  }) {
    return Data(
      id: id ?? this.id, 
      item: item ?? this.item, 
      number: number ?? this.number
    );
  }
}