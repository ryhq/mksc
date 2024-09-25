class LaundryData {
  final int id;
  final String circle;
  final String machineType;
  final String day;
  final double kg;
  final String? camp;

  LaundryData({
    required this.id, 
    required this.circle, 
    required this.machineType, 
    required this.day, 
    required this.kg, 
    required this.camp
  });


  factory LaundryData.fromJson(Map<String, dynamic> json) {
    return LaundryData(
      id: json['id'] ?? 0, 
      circle: json['circle'] ?? "", 
      machineType: json['machineType'] ?? "", 
      day: json['day'] ?? "", 
      kg: (json['kg']  is double) ? json['kg'] : double.tryParse(json['kg'].toString()) ?? 0, 
      camp: json['camp'] ?? ""
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'circle': circle,
      'machineType': machineType,
      'day': day,
      'kg': kg,
      'camp': camp,
    };
  }

  LaundryData copyWith({
    int? id,
    String? circle,
    String? machineType,
    String? day,
    double? kg,
    String? camp,
  }) {
    return LaundryData(
      id: id ?? this.id, 
      circle: circle ?? this.circle, 
      machineType: machineType ?? this.machineType, 
      day: day ?? this.day, 
      kg: kg ?? this.kg, 
      camp: camp ?? this.camp, 
    );
  }
  
  static LaundryData empty() {
    return LaundryData(
      id: 0,     
      circle: "",     
      machineType: "",     
      day: "",     
      kg: 0.0,     
      camp: "",     
    );
  }
} 