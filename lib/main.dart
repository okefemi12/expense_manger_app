import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

// UI
import 'package:expense_manager/navigation/bottomnav.dart';

// Models
import 'package:expense_manager/models/transaction_model.dart';
import 'package:expense_manager/models/account_model.dart';
import 'package:expense_manager/models/budget_model.dart';

// Providers
import 'package:expense_manager/providers/transaction_provider.dart';
import 'package:expense_manager/providers/account_provider.dart';
import 'package:expense_manager/providers/budget_provider.dart';
import 'package:expense_manager/providers/currency_provider.dart';
import 'package:expense_manager/providers/category_tag_provider.dart';

void main() async {
  // This ensures Flutter is fully awake before opening databases
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive
  await Hive.initFlutter();

  // 2. Register Adapters safely so they don't double-register
  if (!Hive.isAdapterRegistered(0))
    Hive.registerAdapter(TransactionModelAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(AccountModelAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(BudgetModelAdapter());

  // 3. Open all boxes safely
  try {
    await Hive.openBox<TransactionModel>('transactionsBox');
    await Hive.openBox<AccountModel>('accountsBox');
    await Hive.openBox<BudgetModel>('budgetsBox');
    await Hive.openBox('settingsBox'); // <-- The missing piece!
  } catch (e) {
    // FATAL CRASH RESCUE: If the database corrupted during our rapid testing,
    // this will wipe the corrupted files and start fresh instead of freezing!
    await Hive.deleteBoxFromDisk('transactionsBox');
    await Hive.deleteBoxFromDisk('accountsBox');
    await Hive.deleteBoxFromDisk('budgetsBox');
    await Hive.deleteBoxFromDisk('settingsBox');

    await Hive.openBox<TransactionModel>('transactionsBox');
    await Hive.openBox<AccountModel>('accountsBox');
    await Hive.openBox<BudgetModel>('budgetsBox');
    await Hive.openBox('settingsBox');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
        ChangeNotifierProvider(create: (_) => CategoryTagProvider()),
      ],
      child: MaterialApp(
        title: 'Expense Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF121212),
        ),
        home: BottomNav(),
      ),
    );
  }
}
