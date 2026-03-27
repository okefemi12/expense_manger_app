import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 2)
class BudgetModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final bool isExpense;

  @HiveField(4)
  final int colorValue;

  @HiveField(5)
  final DateTime startDate; // <-- Added the Date!

  BudgetModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.isExpense,
    required this.colorValue,
    required this.startDate, // <-- Required it here
  });
}
