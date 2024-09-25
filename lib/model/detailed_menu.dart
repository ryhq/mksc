import 'package:mksc/model/dish.dart';
import 'package:mksc/model/other_dish.dart';
import 'package:mksc/model/portion.dart';

class DetailedMenu {
  final Dish dish;
  final List<Portion> portions;
  final String image;
  final String video;
  final List<OtherDish> otherDishesFromSelectedMenu;

  DetailedMenu({
    required this.dish,
    required this.portions,
    required this.image,
    required this.video,
    required this.otherDishesFromSelectedMenu,
  });

  factory DetailedMenu.fromJson(Map<String, dynamic> json) {
    return DetailedMenu(
      dish: Dish.fromJson(json['dish'] ?? {}),
      portions: (json['portions'] as List<dynamic>?)?.map((item) => Portion.fromJson(item)).toList() ?? [],
      image: json['image'] ?? "",
      video: json['video'] ?? "",
      otherDishesFromSelectedMenu: (json['otherDishesFromSelectedMenu'] as List<dynamic>?) ?.map((item) => OtherDish.fromJson(item)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dish': dish.toJson(),
      'portions': portions.map((portion) => portion.toJson()).toList(),
      'image': image,
      'video': video,
      'otherDishesFromSelectedMenu': otherDishesFromSelectedMenu.map((otherDish) => otherDish.toJson()).toList(),
    };
  }

  static DetailedMenu empty(){
    return DetailedMenu(
      dish: Dish.empty(), 
      portions: List<Portion>.empty(), 
      image: "", 
      video: "", 
      otherDishesFromSelectedMenu: List<OtherDish>.empty()
    );
  }
}
