class ExpenseCategory {
  final String id;
  final String name;
  final bool isDefault;

  ExpenseCategory({
    required this.id,
    required this.name,
    this.isDefault = false,
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isDefault': isDefault,
    };
  }
}