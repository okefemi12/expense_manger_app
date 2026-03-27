import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:expense_manager/screens/budget.dart';
import 'package:expense_manager/screens/category_management_screen.dart';
import 'package:expense_manager/screens/core/transaction_screen.dart';
import 'package:expense_manager/screens/core/dashboard_screen.dart';
import 'package:expense_manager/screens/core/settings.dart';
import 'package:expense_manager/widgets/scale_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with WidgetsBindingObserver {
  late List<Widget> pages;
  late DashboardScreen dashboard;
  late TransactionsScreen transaction;
  late Budget budget;
  late Settings setting;
  int currentTabIndex = 0;

  @override
  void initState() {
    dashboard = DashboardScreen();
    transaction = TransactionsScreen();
    budget = Budget();
    setting = Settings();
    pages = [dashboard, transaction, budget, setting];

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 59,
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        color: const Color.fromARGB(255, 18, 30, 83),
        animationDuration: Duration(milliseconds: 280),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.money_sharp, color: Colors.white),
          Icon(Icons.bar_chart, color: Colors.white),
          Icon(Icons.settings, color: Colors.white),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
