import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';


class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;
  int currentTab = 0; // This will hold the index for the Bottom Navigation

  @override
  void initState() {
    super.initState();
    // Initialize pages
    pages = [
      HomePage(), // Home page
      Booking(), // Booking page
      Profile(), // Profile page
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        color: Colors.black,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        animationDuration: Duration(milliseconds: 100),
        items: [
          Icon(Icons.home_filled, color: Colors.white, size: 23),
          Icon(Icons.book, color: Colors.white, size: 23),
          Icon(Icons.person_outlined, color: Colors.white, size: 23),
        ],
        onTap: (index) {
          setState(() {
            currentTab = index; // Update the current tab index
          });
        },
      ),
      body:
          pages[currentTab], // Show the correct page based on current tab index
    );
  }
}