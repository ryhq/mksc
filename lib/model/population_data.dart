class PopulationData {
  final String month;
  final String item;
  final String total;

  PopulationData({
    required this.month, 
    required this.item, 
    required this.total
  });

  factory PopulationData.fromJson(Map<String, dynamic> json) {
    return PopulationData(
      month: json['month'] ?? "", 
      item: json['item'] ?? "", 
      total: json['total'] ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': month,
      'userId': item,
      'categoryId': total,
    };
  }

  PopulationData copyWith({
    String? month,
    String? item,
    String? total,
  }) {
    return PopulationData(
      month: month ?? this.month, 
      item: item ?? this.item, 
      total: total ?? this.total
    );
  }
}