import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:expense_manager/providers/transaction_provider.dart';

class AccountDetailsScreen extends StatefulWidget {
  final String accountName;
  const AccountDetailsScreen({super.key, this.accountName = 'John'});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  bool _isOutgoing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text(widget.accountName, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          // Filter transactions to only show ones for this specific account
          final accountTransactions = provider.transactions.where((t) {
            // If they clicked "Main Vault" on dashboard, show everything. Otherwise, filter.
            return widget.accountName == 'Main Vault' || t.accountName == widget.accountName;
          }).toList();

          // Calculate real totals for this account
          final expense = accountTransactions.where((t) => t.type == 'Expense').fold(0.0, (s, t) => s + t.amount);
          final income = accountTransactions.where((t) => t.type == 'Income').fold(0.0, (s, t) => s + t.amount);
          final balance = income - expense;

          // Prevent chart from crashing if there is 0 data
          final double chartExpense = expense == 0 ? 1 : expense;
          final double chartIncome = income == 0 ? 1 : income;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // 1. Account Total Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Text('Account Total', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('\$${balance.toStringAsFixed(2)}', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28)),
                      const SizedBox(height: 4),
                      Text('${accountTransactions.length} transactions', style: GoogleFonts.inter(color: Colors.white54, fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Breakdown Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      _buildStatRow('Expense', '\$${expense.toStringAsFixed(2)}', const Color(0xFFEF4444)),
                      const SizedBox(height: 16),
                      _buildStatRow('Income', '\$${income.toStringAsFixed(2)}', const Color(0xFF10B981)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Outgoing / Incoming Toggle
                _buildTopToggle(),
                const SizedBox(height: 40),

                // 4. The FL Chart Donut Ring (Now reading real percentages!)
                SizedBox(
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 4,
                          centerSpaceRadius: 70,
                          startDegreeOffset: -90,
                          sections: [
                            if (_isOutgoing || expense > 0)
                              PieChartSectionData(color: const Color(0xFFEF4444), value: chartExpense, radius: _isOutgoing ? 45 : 35, showTitle: false),
                            if (!_isOutgoing || income > 0)
                              PieChartSectionData(color: const Color(0xFF10B981), value: chartIncome, radius: !_isOutgoing ? 45 : 35, showTitle: false),
                          ],
                        ),
                      ),
                      Positioned(
                        child: Icon(
                          _isOutgoing ? Icons.arrow_downward : Icons.arrow_upward, 
                          color: _isOutgoing ? const Color(0xFFEF4444) : const Color(0xFF10B981), 
                          size: 40
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80), 
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatRow(String label, String amount, Color amountColor) {
    return Row(
      children: [
        Text(label, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(width: 12),
        Expanded(child: Container(height: 1, color: Colors.white12)),
        const SizedBox(width: 12),
        Text(amount, style: GoogleFonts.inter(color: amountColor, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildTopToggle() {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isOutgoing = true),
              child: Container(
                decoration: BoxDecoration(color: _isOutgoing ? const Color(0xFF3F4A5E) : Colors.transparent, borderRadius: BorderRadius.circular(16)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_drop_down, color: Color(0xFFEF4444)),
                    Text('Outgoing', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isOutgoing = false),
              child: Container(
                decoration: BoxDecoration(color: !_isOutgoing ? const Color(0xFF3F4A5E) : Colors.transparent, borderRadius: BorderRadius.circular(16)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_drop_up, color: Color(0xFF10B981)),
                    Text('Incoming', style: GoogleFonts.inter(color: Colors.white54, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}