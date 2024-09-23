class Portion {
  final String? extraDetails;
  final String unitNeeded;
  final int multiply;
  final String productName;
  final String unit;

  Portion({
    this.extraDetails,
    required this.unitNeeded,
    required this.multiply,
    required this.productName,
    required this.unit,
  });

  factory Portion.fromJson(Map<String, dynamic> json) {
    return Portion(
      extraDetails: json['extraDetails'],
      unitNeeded: json['unitNeeded'] ?? "",
      multiply: json['multiply'] ?? 1,
      productName: json['productName'] ?? "",
      unit: json['unit'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'extraDetails': extraDetails,
      'unitNeeded': unitNeeded,
      'multiply': multiply,
      'productName': productName,
      'unit': unit,
    };
  }
}
