class ChickenHouseProduct {
  final String svgicon;
  final String name;
  ChickenHouseProduct({required this.svgicon, required this.name});
  static ChickenHouseProduct empty(){
    return ChickenHouseProduct(svgicon: '', name: '');
  }
}
