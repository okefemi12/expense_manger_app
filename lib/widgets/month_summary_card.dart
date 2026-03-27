import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MonthSummaryCard extends StatelessWidget {
  final double expense;
  final double income;
  final double total;

  const MonthSummaryCard({
    super.key,
    required this.expense,
    required this.income,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Premium dark bento box
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Expense Column
          _buildSummaryItem(
            Icons.arrow_drop_down,
            const Color(0xFFEF4444),
            '-\$${expense.toStringAsFixed(0)}',
          ),

          // Income Column
          _buildSummaryItem(
            Icons.arrow_drop_up,
            const Color(0xFF10B981),
            '+\$${income.toStringAsFixed(0)}',
          ),

          // Total Flow Column
          Row(
            children: [
              Text(
                '=',
                style: GoogleFonts.inter(
                  color: Colors.white54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${total < 0 ? '-' : ''}\$${total.abs().toStringAsFixed(0)}',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget to keep the Row clean
  Widget _buildSummaryItem(IconData icon, Color color, String amount) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 4),
        Text(
          amount,
          style: GoogleFonts.inter(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
