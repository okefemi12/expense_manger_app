import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:expense_manager/models/account_model.dart';
import 'package:expense_manager/providers/account_provider.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final nameController = TextEditingController();
  final balanceController = TextEditingController();
  
  int _selectedColorIndex = 0;
  String _selectedCurrency = 'USD'; // Default to USD
  String _searchQuery = ''; // For the search bar
  bool _useDecimals = true; // For the decimal toggle

  final List<Color> _accountColors = [
    const Color(0xFF93A8D0), // Soft blue
    const Color(0xFF68C368), // Green
    const Color(0xFF2CB59E), // Teal
    const Color(0xFF26BBD0), // Cyan
    const Color(0xFF42A5F5), // Blue
  ];

  // Expanded currency data
  final List<Map<String, String>> _currencies = [
    {'code': 'USD', 'symbol': '\$', 'name': 'United States'},
    {'code': 'NGN', 'symbol': '₦', 'name': 'Nigeria'}, // Added NGN!
    {'code': 'EUR', 'symbol': '€', 'name': 'Euro Member'},
    {'code': 'GBP', 'symbol': '£', 'name': 'United Kingdom'},
    {'code': 'JPY', 'symbol': '¥', 'name': 'Japan'},
    {'code': 'AUD', 'symbol': '\$', 'name': 'Australia'},
    {'code': 'CAD', 'symbol': '\$', 'name': 'Canada'},
  ];

  @override
  void dispose() {
    nameController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter currencies based on search bar
    final filteredCurrencies = _currencies.where((c) {
      final query = _searchQuery.toLowerCase();
      return c['code']!.toLowerCase().contains(query) || c['name']!.toLowerCase().contains(query);
    }).toList();

    // Get the dynamic symbol based on selection
    final currentSymbol = _currencies.firstWhere(
      (c) => c['code'] == _selectedCurrency, 
      orElse: () => {'symbol': '\$'}
    )['symbol']!;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white54),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Account',
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
            // 1. Name Input (Make sure to scroll up and fill this!)
            TextField(
              controller: nameController, 
              style: GoogleFonts.inter(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: 'Account Name (e.g. Chase Bank)',
                hintStyle: GoogleFonts.inter(
                  color: Colors.white24,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24, width: 2),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 2. Color Picker
            _buildColorPicker(),
            const SizedBox(height: 32),

            // 3. Starting Balance (Dynamic Symbol!)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Starting at',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  currentSymbol, // <--- DYNAMIC SYMBOL!
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IntrinsicWidth(
                  child: TextField(
                    controller: balanceController,
                    keyboardType: TextInputType.numberWithOptions(decimal: _useDecimals),
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: '0',
                      hintStyle: TextStyle(color: Colors.white24),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24, width: 2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.only(bottom: 4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Decimal Precision Toggle (Now functional)
            GestureDetector(
              onTap: () => setState(() => _useDecimals = !_useDecimals),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _useDecimals ? const Color(0xFF93A8D0) : Colors.white12, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.money,
                      color: _useDecimals ? const Color(0xFF93A8D0) : Colors.white54,
                    ), 
                    const SizedBox(width: 16),
                    Text(
                      'Decimal Precision: ${_useDecimals ? "ON" : "OFF"}',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 5. Currency Search Bar (Now functional)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF282B3A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Search currencies...',
                        hintStyle: GoogleFonts.inter(color: Colors.white38, fontSize: 16),
                        border: InputBorder.none,
                        suffixIcon: const Icon(Icons.search, color: Colors.white54),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF282B3A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.info_outline, color: Colors.white54),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 6. Currency Grid (Filtered by search)
            if (filteredCurrencies.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("No currencies found.", style: GoogleFonts.inter(color: Colors.white54)),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: filteredCurrencies.length,
                itemBuilder: (context, index) {
                  final currency = filteredCurrencies[index];
                  final isSelected = _selectedCurrency == currency['code'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCurrency = currency['code']!),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF93A8D0) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currency['code']!,
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currency['symbol']!,
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currency['name']!,
                            style: GoogleFonts.inter(color: Colors.white54, fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
                // Input validation with a better error message
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Please scroll to the top and enter an Account Name!')));
                  return;
                }
                if (balanceController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Please enter a Starting Balance!')));
                  return;
                }

                final newAccount = AccountModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text.trim(),
                  startingBalance: double.parse(balanceController.text),
                  currencySymbol: currentSymbol, // Save the correct symbol!
                  colorValue: _accountColors[_selectedColorIndex].value,
                );

                // Save to Hive
                Provider.of<AccountProvider>(context, listen: false).addAccount(newAccount);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF93A8D0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save Account',
                style: GoogleFonts.inter(
                  color: const Color(0xFF121212),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _accountColors.length,
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
                backgroundColor: _accountColors[index],
                child: index == 0 ? const Icon(Icons.palette, color: Colors.white70) : null,
              ),
            ),
          );
        },
      ),
    );
  }
}