import 'package:expense_manager/screens/core/add_transaction.dart';
import 'package:expense_manager/widgets/month_summary_card.dart';
import 'package:expense_manager/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:expense_manager/providers/transaction_provider.dart';
import 'package:expense_manager/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final int currentMonthIndex = DateTime.now().month - 1;

    return DefaultTabController(
      length: 12,
      initialIndex: currentMonthIndex,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 13, 17, 26),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 13, 17, 26),
          elevation: 0,
          title: Text(
            'Transactions',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            dividerColor: Colors.white10,
            indicatorColor: Colors.white,
            tabs: _months.map((month) => Tab(text: month)).toList(),
          ),
        ),
        body: Consumer<TransactionProvider>(
          builder: (context, provider, child) {
            return TabBarView(
              children: List.generate(12, (index) {
                final targetMonth = index + 1;
                final monthData =
                    provider.transactions
                        .where((t) => t.date.month == targetMonth)
                        .toList();

                if (monthData.isEmpty) return _buildEmptyState(_months[index]);
                return _buildPopulatedMonth(monthData, provider);
              }),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPopulatedMonth(
    List<TransactionModel> monthData,
    TransactionProvider provider,
  ) {
    final expense = monthData
        .where((t) => t.type == 'Expense')
        .fold(0.0, (s, t) => s + t.amount);
    final income = monthData
        .where((t) => t.type == 'Income')
        .fold(0.0, (s, t) => s + t.amount);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          MonthSummaryCard(
            expense: expense,
            income: income,
            total: income - expense,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children:
                  monthData.map((tx) {
                    return Dismissible(
                      key: Key(tx.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      onDismissed:
                          (direction) => provider.deleteTransaction(tx.id),
                      child: GestureDetector(
                        onTap: () => _showEditDialog(context, tx, provider),
                        child: TransactionCard(
                          title: tx.title,
                          subtitle: DateFormat('MMM dd, yyyy').format(tx.date),
                          amount: tx.amount,
                          isIncome: tx.type == 'Income',
                          icon:
                              tx.type == 'Income'
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    TransactionModel tx,
    TransactionProvider provider,
  ) {
    final amountController = TextEditingController(text: tx.amount.toString());
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: const Text(
              'Edit Amount',
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Creating a replacement transaction to update it!
                  final updatedTx = TransactionModel(
                    id: tx.id,
                    title: tx.title,
                    amount: double.parse(amountController.text),
                    date: tx.date,
                    type: tx.type,
                    category: tx.category,
                    accountName: tx.accountName,
                    note: tx.note,
                  );
                  provider.addTransaction(
                    updatedTx,
                  ); // put() overrides the old one because ID matches!
                  Navigator.pop(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildEmptyState(String month) => Center(
    child: Text(
      'No transactions for $month.',
      style: GoogleFonts.inter(color: Colors.white38, fontSize: 16),
    ),
  );
}
