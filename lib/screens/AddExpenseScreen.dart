import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class Addexpensescreen extends StatefulWidget {
  const Addexpensescreen({super.key});

  @override
  State<Addexpensescreen> createState() => _AddexpensescreenState();
}

class _AddexpensescreenState extends State<Addexpensescreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _payeeController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Expense')),
      body: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _payeeController,
              decoration: InputDecoration(labelText: 'Payee'),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: ' Date'),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: ' Note'),
            ),
            TextField(
              controller: _tagController,
              decoration: InputDecoration(labelText: 'Tag'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _saveExpense(context),
              child: Text('saveExpense'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveExpense(BuildContext context) {
    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      categoryId: _categoryController.text,
      payee: _payeeController.text,
      tag: _tagController.text,
      amount: double.parse(_amountController.text),
      note: _noteController.text,
      date: DateTime.parse(_dateController.text),
    );
    Provider.of<ExpenseProvider>(context, listen: false).addExpense(expense);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _tagController.dispose();
    _payeeController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
