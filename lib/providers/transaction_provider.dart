import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_manager/models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  // This connects directly to the Hive box we are about to open in main.dart
  final Box<TransactionModel> _box = Hive.box<TransactionModel>('transactionsBox');

  // Get all transactions, sorted by newest first
  List<TransactionModel> get transactions {
    final list = _box.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  // Calculate total expense
  double get totalExpense {
    return transactions
        .where((t) => t.type == 'Expense')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // Calculate total income
  double get totalIncome {
    return transactions
        .where((t) => t.type == 'Income')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // Save a new transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
    notifyListeners(); // Tells the UI to update instantly!
  }

  // Delete a transaction
  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
    notifyListeners();
  }
}