import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'providers/expense_provider.dart';
import 'screens/category_management_screen.dart';
import 'screens/home_screen.dart';
import 'screens/tag_management_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;

  const MyApp({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider(localStorage)),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(), // Main entry point, HomeScreen
          '/manage_categories':
              (context) =>
                  CategoryManagementScreen(), // Route for managing categories
          '/manage_tags':
              (context) => TagManagementScreen(), // Route for managing tags
        },
        // Removed 'home:' since 'initialRoute' is used to define the home route
      ),
    );
  }
}
