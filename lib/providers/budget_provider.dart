import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/budget_model.dart';

class BudgetProvider extends ChangeNotifier {
  final Box<BudgetModel> _box = Hive.box<BudgetModel>('budgetsBox');

  List<BudgetModel> get budgets => _box.values.toList();

  Future<void> addBudget(BudgetModel budget) async {
    await _box.put(budget.id, budget);
    notifyListeners();
  }

  Future<void> deleteBudget(String id) async {
    await _box.delete(id);
    notifyListeners();
  }
}