import 'package:hive/hive.dart';

// This line is red right now. That is 100% normal! We will generate it in a second.
part 'transaction_model.g.dart'; 

@HiveType(typeId: 0) // typeId must be unique for every model
class TransactionModel extends HiveObject {
  
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title; // Payee (Expense) / Source (Income) / Transfer To

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String type; // We will use "Expense", "Income", or "Transfer"

  @HiveField(5)
  final String category;

  @HiveField(6)
  final String accountName; // Which account it belongs to (e.g., "John", "Bank")

  @HiveField(7)
  final String note;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    required this.accountName,
    this.note = '',
  });
}