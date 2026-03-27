import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// --- MODELS & PROVIDERS ---
import 'package:expense_manager/models/transaction_model.dart';
import 'package:expense_manager/providers/transaction_provider.dart';
import 'package:expense_manager/providers/account_provider.dart';
import 'package:expense_manager/providers/currency_provider.dart';

// --- COMPONENTS & WIDGETS ---
import 'package:expense_manager/widgets/dashboard.dart'; // The chart we just fixed!
import 'package:expense_manager/widgets/account_card.dart';
import 'package:expense_manager/widgets/transaction_card.dart';
import 'package:expense_manager/widgets/trasaction_filter_tab.dart';
import 'package:expense_manager/components/acct_buttn.dart';
import 'package:expense_manager/components/small_buttn.dart';
import 'package:expense_manager/components/model_sheet.dart';
import 'package:hive_flutter/hive_flutter.dart';

// --- SCREENS ---
import 'package:expense_manager/screens/core/add_transaction.dart';
import 'package:expense_manager/screens/core/transaction_screen.dart';
import 'package:expense_manager/screens/core/account_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentTabIndex = 0;

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return "Good Morning";
    if (hour >= 12 && hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final currencyProvider = context.watch<CurrencyProvider>();

    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        double totalConvertedBalance = 0.0;
        for (var account in accountProvider.accounts) {
          totalConvertedBalance += currencyProvider.getConvertedValue(
            account.startingBalance,
            account.currencySymbol,
          );
        }
        totalConvertedBalance += (provider.totalIncome - provider.totalExpense);

        Iterable<TransactionModel> filteredList = provider.transactions;
        if (_currentTabIndex == 1) {
          filteredList = filteredList.where((t) => t.type == 'Expense');
        } else if (_currentTabIndex == 2) {
          filteredList = filteredList.where((t) => t.type == 'Income');
        } else if (_currentTabIndex == 3) {
          filteredList = filteredList.where((t) => t.type == 'Transfer');
        }
        final recentTransactions = filteredList.take(5).toList();

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 13, 17, 26),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 14),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getGreeting(),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Hive.box(
                          'settingsBox',
                        ).get('userName', defaultValue: 'John Doe'),
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 50),

                SizedBox(
                  height: 114,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      AccountCard(
                        balance:
                            currencyProvider.isFetching
                                ? "Syncing..."
                                : "₦${totalConvertedBalance.toStringAsFixed(2)}",
                        isSelected: true,
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const AccountDetailsScreen(
                                      accountName: "Main Vault",
                                    ),
                              ),
                            ),
                        title: "Total Balance",
                        subtitle: "Live API Active",
                      ),
                      const SizedBox(width: 10),
                      ...accountProvider.accounts.map((account) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: AccountCard(
                            balance:
                                "${account.currencySymbol}${account.startingBalance.toStringAsFixed(2)}",
                            isSelected: false,
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => AccountDetailsScreen(
                                          accountName: account.name,
                                        ),
                                  ),
                                ),
                            title: account.name,
                            subtitle: "Local Vault",
                          ),
                        );
                      }).toList(),
                      acct_btn(
                        icon: Icons.add,
                        label: 'Account',
                        onPressed:
                            () => showMaterialModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const SelectAccountSheet(),
                            ),
                        isHighlighted: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 50),

                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: DashboardSyncfusionChart(
                      data: _generateChartData(provider),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),

                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: TransactionFilterTab(
                      selectedIndex: _currentTabIndex,
                      onTabChanged:
                          (index) => setState(() => _currentTabIndex = index),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                if (recentTransactions.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "No transactions yet.",
                        style: GoogleFonts.inter(color: Colors.white54),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children:
                          recentTransactions.map((tx) {
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
                              onDismissed: (direction) {
                                provider.deleteTransaction(tx.id);
                              },
                              child: TransactionCard(
                                title: tx.title,
                                subtitle: DateFormat(
                                  'MMM dd, yyyy',
                                ).format(tx.date),
                                amount: tx.amount,
                                isIncome: tx.type == 'Income',
                                icon:
                                    tx.type == 'Income'
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                const SizedBox(height: 10),

                Center(
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: Small_bttn(
                      label: 'View All Transactions',
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TransactionsScreen(),
                            ),
                          ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 12),
              ],
            ),
          ),

          floatingActionButton: FloatingActionButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTransaction(),
                  ),
                ),
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  List<ChartData> _generateChartData(TransactionProvider provider) {
    List<ChartData> dynamicData = [];

    // Generate the exact dates for the last 5 days
    for (int i = 4; i >= 0; i--) {
      DateTime targetDate = DateTime.now().subtract(Duration(days: i));
      String dayString = DateFormat('MMM dd').format(targetDate);

      // Calculate total for this specific day
      double dayTotal = 0;
      for (var tx in provider.transactions) {
        if (tx.date.year == targetDate.year &&
            tx.date.month == targetDate.month &&
            tx.date.day == targetDate.day) {
          dayTotal += (tx.type == 'Expense' ? -tx.amount : tx.amount);
        }
      }
      dynamicData.add(ChartData(dayString, dayTotal));
    }
    return dynamicData;
  }
}
