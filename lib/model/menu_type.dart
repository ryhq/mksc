class MenuType {
  final String type;

  MenuType({required this.type});

  factory MenuType.fromJson(Map<String, dynamic> json) {
    return MenuType(
      type: json['type'] ?? "", 
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'type': type,
    };
  }

  MenuType copyWith({
    String? type,
  }) {
    return MenuType(
      type: type ?? this.type, 
    );
  }
  
  static MenuType empty() {
    return MenuType(
      type: "",     
    );
  }
}