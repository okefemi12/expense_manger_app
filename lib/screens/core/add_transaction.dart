import 'package:expense_manager/components/button.dart';
import 'package:expense_manager/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_manager/models/transaction_model.dart';
import 'package:expense_manager/providers/transaction_provider.dart';
import 'package:expense_manager/providers/category_tag_provider.dart';
import 'package:expense_manager/screens/core/tag_management_screen.dart'; // We will build this next!

class AddTransaction extends StatelessWidget {
  const AddTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 13, 17, 26),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 13, 17, 26),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white54),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Add Transaction', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              color: const Color(0xFF282B3A),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: const BoxDecoration(color: Color(0xFF3A3D4E)),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                labelPadding: EdgeInsets.zero,
                tabs: [
                  _buildCustomTab(Icons.arrow_drop_down, const Color(0xFFEF4444), 'Expense'),
                  _buildCustomTab(Icons.arrow_drop_up, const Color(0xFF10B981), 'Income'),
                  _buildCustomTab(Icons.compare_arrows, Colors.white54, 'Transfer'),
                ],
              ),
            ),
          ),
        ),
        // By calling _TransactionFormTab three times, they each get their own isolated memory!
        body: const TabBarView(
          children: [
            _TransactionFormTab(type: 'Expense'),
            _TransactionFormTab(type: 'Income'),
            _TransactionFormTab(type: 'Transfer'),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTab(IconData icon, Color iconColor, String text) {
    return Tab(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 4),
          Text(text, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// --- THIS ISOLATES THE STATE SO TABS DON'T SHARE TEXT ---
class _TransactionFormTab extends StatefulWidget {
  final String type;
  const _TransactionFormTab({required this.type});

  @override
  State<_TransactionFormTab> createState() => _TransactionFormTabState();
}

class _TransactionFormTabState extends State<_TransactionFormTab> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategoryId;
  String? _selectedTagId;

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catTagProvider = context.watch<CategoryTagProvider>();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 19),
          Mytext(
            maxlines: 1,
            controller: titleController,
            hintText: widget.type == 'Transfer' ? 'Transfer To' : 'Title / Payee',
            obscureText: false,
            type: TextInputType.text,
          ),
          const SizedBox(height: 19),
          Mytext(
            maxlines: 1,
            controller: amountController,
            hintText: 'Amount',
            obscureText: false,
            type: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 19),
          _buildDatePicker(),
          
          if (widget.type != 'Transfer') ...[
            const SizedBox(height: 19),
            _buildDropdown(
              hint: 'Category',
              value: _selectedCategoryId,
              items: catTagProvider.categories,
              icon: Icons.keyboard_arrow_down,
              onChanged: (val) {
                if (val == 'Manage...') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TagManagementScreen(isCategory: true)));
                  _selectedCategoryId = null; // Reset selection
                } else {
                  setState(() => _selectedCategoryId = val);
                }
              },
            ),
            const SizedBox(height: 19),
            _buildDropdown(
              hint: 'Tag',
              value: _selectedTagId,
              items: catTagProvider.tags,
              icon: Icons.local_offer_outlined,
              onChanged: (val) {
                if (val == 'Manage...') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TagManagementScreen(isCategory: false)));
                  _selectedTagId = null;
                } else {
                  setState(() => _selectedTagId = val);
                }
              },
            ),
          ],

          const SizedBox(height: 19),
          Mytext(maxlines: 4, controller: noteController, hintText: 'Note', obscureText: false, type: TextInputType.text),
          const SizedBox(height: 24),
          Button(
            text: 'Save ${widget.type}',
            onTap: () {
              if (titleController.text.isEmpty || amountController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a title and amount')));
                return;
              }

              final newTransaction = TransactionModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleController.text,
                amount: double.parse(amountController.text),
                date: _selectedDate,
                type: widget.type,
                category: _selectedCategoryId ?? 'General',
                accountName: 'Main Vault', 
                note: noteController.text,
              );

              Provider.of<TransactionProvider>(context, listen: false).addTransaction(newTransaction);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () async {
          final picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2000), lastDate: DateTime(2100));
          if (picked != null) setState(() => _selectedDate = picked);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(color: const Color.fromARGB(255, 11, 12, 17), borderRadius: BorderRadius.circular(25)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('MMM dd, yyyy').format(_selectedDate), style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              const Icon(Icons.calendar_month, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({required String hint, required String? value, required List<String> items, required IconData icon, required Function(String?) onChanged}) {
    // Ensure the value exists in the list, otherwise set to null
    final validValue = items.contains(value) ? value : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonFormField<String>(
        value: validValue,
        dropdownColor: const Color(0xFF1E1E1E),
        icon: Icon(icon, color: Colors.white54),
        style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 11, 12, 17),
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w500),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
        ),
        // Add the items, plus a special button at the bottom to Manage them
        items: [
          ...items.map((item) => DropdownMenuItem(value: item, child: Text(item))),
          const DropdownMenuItem(value: 'Manage...', child: Text('⚙️ Manage...', style: TextStyle(color: Colors.blueAccent))),
        ],
        onChanged: onChanged,
      ),
    );
  }
}