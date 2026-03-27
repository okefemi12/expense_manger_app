import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionFilterTab extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const TransactionFilterTab({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // The background of the entire tab bar
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Matches your bento cards
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildTabItem(title: 'All', index: 0),
          _buildTabItem(title: 'Expense', index: 1),
          _buildTabItem(title: 'Income', index: 2),
        ],
      ),
    );
  }

  // Helper widget to build each individual tab
  Widget _buildTabItem({required String title, required int index}) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            // The sleek slate-blue color for the selected tab
            color: isSelected ? Color(0xFF3B82F6) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}
