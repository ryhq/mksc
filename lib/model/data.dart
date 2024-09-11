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
      number: (json['number'] != null) ? json['number'].toString() : "",  // Convert number to String
    );
  }

  // After saving the new data the server respond back with this format data of new data
  // {
  //   "item": "Test item",
  //   "number": 30,
  //   "created_at": null,
  //   "camp": "",
  //   "updated_at": "2024-09-11T09:38:53.000000Z",
  //   "id": 268
  // }                       

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
  
  static Data empty() {
    return Data(
      id: 0,        
      item: "",     
      number: "",
    );
  }
}