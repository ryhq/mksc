class Camp {
  final String camp;

  Camp({required this.camp});

  factory Camp.fromJson(Map<String, dynamic> json) {
    return Camp(
      camp: json['camp'] ?? "", 
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'camp': camp,
    };
  }

  Camp copyWith({
    String? camp,
  }) {
    return Camp(
      camp: camp ?? this.camp, 
    );
  }
  
  static Camp empty() {
    return Camp(
      camp: "",     
    );
  }
}