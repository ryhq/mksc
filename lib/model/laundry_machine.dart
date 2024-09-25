class LaundryMachine {
  final String machineType;

  LaundryMachine({required this.machineType});

  factory LaundryMachine.fromJson(Map<String, dynamic> json) {
    return LaundryMachine(
      machineType: json['machineType'] ?? "", 
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'machineType': machineType,
    };
  }

  LaundryMachine copyWith({
    String? machineType,
  }) {
    return LaundryMachine(
      machineType: machineType ?? this.machineType, 
    );
  }
  
  static LaundryMachine empty() {
    return LaundryMachine(
      machineType: "",     
    );
  }
}