import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:expense_manager/providers/account_provider.dart';
import 'package:expense_manager/screens/core/add_account.dart'; // Make sure this path is correct!

class SelectAccountSheet extends StatelessWidget {
  const SelectAccountSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Listen to the real database!
    final accountProvider = context.watch<AccountProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF282B3A), // Matches your premium dark theme
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wraps tightly around the content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle at the top
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Accounts',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.edit, color: Colors.white54),
            ],
          ),
          const SizedBox(height: 24),

          // 2. The Default Main Vault
          _buildAccountTile('Main Vault', context),

          // 3. Your Real Hive Accounts!
          ...accountProvider.accounts.map((account) {
            return _buildAccountTile(account.name, context);
          }).toList(),

          const SizedBox(height: 16),

          // 4. The Big + Button (Now fully functional!)
          InkWell(
            onTap: () {
              // Close the bottom sheet menu first
              Navigator.pop(context);

              // Navigate straight to the Add Account screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddAccountScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add, color: Colors.white54, size: 32),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper widget for the pushpin rows
  Widget _buildAccountTile(String name, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // You can add logic here later if you want tapping an account to switch the active view!
          Navigator.pop(context);
        },
        child: Row(
          children: [
            const Icon(Icons.push_pin, color: Color(0xFF93A8D0)),
            const SizedBox(width: 16),
            Text(
              name,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
