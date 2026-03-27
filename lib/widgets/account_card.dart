import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountCard extends StatelessWidget {
  final String title;
  final String balance;
  final bool isSelected;
  final VoidCallback onTap;
  final String subtitle;

  const AccountCard({
    super.key,
    required this.balance,
    required this.isSelected,
    required this.onTap,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.0,
        height: MediaQuery.of(context).size.height / 0.5,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0XFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          border:
              isSelected
                  ? Border.all(color: const Color(0xFF3B82F6), width: 2)
                  : Border.all(color: Colors.transparent, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Color(0xFF60A5FA),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              balance,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
