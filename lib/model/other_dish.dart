class OtherDish {
  final int id;
  final String dishName;

  OtherDish({
    required this.id,
    required this.dishName,
  });

  factory OtherDish.fromJson(Map<String, dynamic> json) {
    return OtherDish(
      id: json['id'] ?? 0,
      dishName: json['dishName'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dishName': dishName,
    };
  }

  static OtherDish empty() {
    return OtherDish(
      id: 0,
      dishName: "",
    );
  }
}