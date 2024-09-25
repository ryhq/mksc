class Dish {
  final int id;
  final int menuId;
  final String tableware;
  final String recipe;
  final String utensils;
  final int isCopied;

  Dish({
    required this.id,
    required this.menuId,
    required this.tableware,
    required this.recipe,
    required this.utensils,
    required this.isCopied,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'] ?? 0,
      menuId: json['menuId'] ?? 0,
      tableware: json['tableware'] ?? "",
      recipe: json['recipe'] ?? "",
      utensils: json['utensils'] ?? "",
      isCopied: json['isCopied'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menuId': menuId,
      'tableware': tableware,
      'recipe': recipe,
      'utensils': utensils,
      'isCopied': isCopied,
    };
  }

  static Dish empty() {
    return Dish(
      id: 0,
      menuId: 0,
      tableware: "",
      recipe: "",
      utensils: "",
      isCopied: 0,
    );
  }
}