import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:expense_manager/models/budget_model.dart';
import 'package:expense_manager/providers/budget_provider.dart';
import 'package:intl/intl.dart'; // <-- Needed for the beautiful date formatting

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  // --- NEW: Dynamic Date State ---
  DateTime _startDate = DateTime.now();

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  bool _isExpenseBudget = true;
  int _selectedColorIndex = 0;
  int _budgetTypeIndex = 1; 
  int _transactionIncludeIndex = 0; 

  final List<Color> _budgetColors = [
    const Color(0xFF93A8D0), 
    const Color(0xFF68C368), 
    const Color(0xFF2CB59E), 
    const Color(0xFF26BBD0), 
    const Color(0xFF42A5F5), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 13, 17, 26),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white54),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Budget',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            _buildTopToggle(),
            const SizedBox(height: 40),
            _buildCenterInputs(),
            const SizedBox(height: 32),
            _buildColorPicker(),
            const SizedBox(height: 32),
            _buildOptionSection(
              title: 'Budget Type',
              options: ['Added only', 'All transactions'],
              selectedIndex: _budgetTypeIndex,
              onSelect: (index) => setState(() => _budgetTypeIndex = index),
            ),
            const SizedBox(height: 24),
            _buildOptionSection(
              title: 'Transactions to Include',
              options: ['Default', 'Income', 'Lent and b...'],
              selectedIndex: _transactionIncludeIndex,
              onSelect: (index) => setState(() => _transactionIncludeIndex = index),
              showCheckOnSelected: true,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty || amountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a name and amount')),
                  );
                  return;
                }

                // Saves the object including our newly picked _startDate!
                final newBudget = BudgetModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  amount: double.parse(amountController.text),
                  isExpense: _isExpenseBudget,
                  colorValue: _budgetColors[_selectedColorIndex].value,
                  startDate: _startDate, // <-- Saved here!
                );

                Provider.of<BudgetProvider>(context, listen: false).addBudget(newBudget);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF93A8D0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                'Set Name',
                style: GoogleFonts.inter(
                  color: const Color(0xFF121212),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildTopToggle() {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isExpenseBudget = true),
              child: Container(
                decoration: BoxDecoration(color: _isExpenseBudget ? const Color(0xFF3F4A5E) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_drop_down, color: Color(0xFFEF4444)),
                    const SizedBox(width: 4),
                    Text('Expense budget', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isExpenseBudget = false),
              child: Container(
                decoration: BoxDecoration(color: !_isExpenseBudget ? const Color(0xFF3F4A5E) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_drop_up, color: Color(0xFF10B981)),
                    const SizedBox(width: 4),
                    Text('Savings budget', style: GoogleFonts.inter(color: Colors.white54, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterInputs() {
    // Calculates the last day of the currently picked month
    final lastDayOfMonth = DateTime(_startDate.year, _startDate.month + 1, 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IntrinsicWidth(
          child: TextField(
            controller: nameController,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: 'Name',
              hintStyle: GoogleFonts.inter(color: Colors.white24, fontWeight: FontWeight.bold),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24, width: 2)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
              isDense: true,
              contentPadding: const EdgeInsets.only(bottom: 8),
            ),
          ),
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\$', style: GoogleFonts.inter(fontSize: 28, color: Colors.white54, fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            IntrinsicWidth(
              child: TextField(
                controller: amountController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: GoogleFonts.inter(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(color: Colors.white24),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24, width: 2)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 4),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text('/', style: GoogleFonts.inter(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            IntrinsicWidth(
              child: TextField(
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: '1',
                  hintStyle: TextStyle(color: Colors.white24),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24, width: 2)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
                  isDense: true,
                  contentPadding: EdgeInsets.only(bottom: 4),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white24, width: 2))),
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('month', style: GoogleFonts.inter(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // NEW: Fully tappable date picker!
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('beginning', style: GoogleFonts.inter(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => _startDate = picked);
                }
              },
              child: Container(
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white24, width: 2))),
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  DateFormat('MMMM d').format(_startDate), // Automatically writes out "March 15"
                  style: GoogleFonts.inter(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // This makes the subtitle automatically show "March 15 - March 31" based on your choice!
        Text(
          'Current Period\n${DateFormat('MMMM d').format(_startDate)} - ${DateFormat('MMMM d').format(lastDayOfMonth)}',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(color: Colors.white24, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildColorPicker() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _budgetColors.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedColorIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedColorIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: EdgeInsets.all(isSelected ? 3 : 0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
              ),
              child: CircleAvatar(
                radius: 26,
                backgroundColor: _budgetColors[index],
                child: index == 0 ? const Icon(Icons.palette, color: Colors.white70) : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOptionSection({required String title, required List<String> options, required int selectedIndex, required Function(int) onSelect, bool showCheckOnSelected = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.inter(color: Colors.white54, fontSize: 14)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white54, size: 24),
              const SizedBox(width: 16),
              ...List.generate(options.length, (index) {
                final isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () => onSelect(index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF3F4A5E) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? Colors.transparent : Colors.white24),
                    ),
                    child: Row(
                      children: [
                        if (showCheckOnSelected && isSelected) ...[const Icon(Icons.check, color: Colors.white, size: 18), const SizedBox(width: 6)],
                        Text(options[index], style: GoogleFonts.inter(color: isSelected ? Colors.white : Colors.white70, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}