class ThemeColor {
  final String primaryColor; 
  final String secondaryColor;

  ThemeColor({
    required this.primaryColor, 
    required this.secondaryColor
  }); 

  factory ThemeColor.fromJson(Map<String, dynamic> json){
    return ThemeColor(
      primaryColor: json['primaryColor'] ?? "569CEA", 
      secondaryColor: json['secondaryColor'] ?? "9BC2EE"
    );
  }

  ThemeColor copyWith({
    String? primaryColor,
    String? secondaryColor,
  }) {
    return ThemeColor(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
    };
  }

  static ThemeColor empty() {
    return ThemeColor(
      primaryColor: "",
      secondaryColor: ""
    );
  }
}