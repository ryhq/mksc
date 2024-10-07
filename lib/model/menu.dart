class Menu {
  final int id;
  final String menuName;
  final String type;
  final String camp;
  final int copied;
  final int copieFrom;
  final String day;
  final int isActive;
  final int isDeleted;
  final String updatedAt;
  final String created_at;
  final String? createdBy;

  Menu({
    required this.id,
    required this.menuName,
    required this.type,
    required this.camp,
    required this.copied,
    required this.copieFrom,
    required this.day,
    required this.isActive,
    required this.isDeleted,
    required this.updatedAt,
    required this.created_at,
    this.createdBy,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] ?? 0,
      menuName: json['menuName'] ?? "",
      type: json['type'] ?? "",
      camp: json['camp'] ?? "",
      copied: json['copied'] ?? 0,
      copieFrom: json['copieFrom'] ?? 0,
      day: json['day'] ?? "",
      isActive: json['is_active'] ?? 0,
      isDeleted: json['is_deleted'] ?? 0,
      updatedAt: json['updated_at'] ?? "",
      created_at: json['created_at'] ?? "",
      createdBy: json['created_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menuName': menuName,
      'type': type,
      'camp': camp,
      'copied': copied,
      'copieFrom': copieFrom,
      'day': day,
      'is_active': isActive,
      'is_deleted': isDeleted,
      'updated_at': updatedAt,
      'created_at': created_at,
      'created_by': createdBy,
    };
  }

  Menu copyWith({
    int? id,
    String? menuName,
    String? type,
    String? camp,
    int? copied,
    int? copieFrom,
    String? day,
    int? isActive,
    int? isDeleted,
    String? updatedAt,
    String? created_at,
    String? createdBy,
  }) {
    return Menu(
      id: id ?? this.id,
      menuName: menuName ?? this.menuName,
      type: type ?? this.type,
      camp: camp ?? this.camp,
      copied: copied ?? this.copied,
      copieFrom: copieFrom ?? this.copieFrom,
      day: day ?? this.day,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      updatedAt: updatedAt ?? this.updatedAt,
      created_at: created_at ?? this.created_at,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  static Menu empty() {
    return Menu(
      id: 0,
      menuName: "",
      type: "",
      camp: "",
      copied: 0,
      copieFrom: 0,
      day: "",
      isActive: 0,
      isDeleted: 0,
      updatedAt: "",
      created_at: "",
      createdBy: null,
    );
  }
}
