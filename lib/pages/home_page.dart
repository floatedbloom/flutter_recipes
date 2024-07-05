import 'package:flutter/material.dart';
import 'package:flutter_recipes/components/bottom_nav.dart';
import 'package:flutter_recipes/pages/create_page.dart';
import 'package:flutter_recipes/pages/hot_page.dart';
import 'package:flutter_recipes/pages/personal_page.dart';
import 'package:flutter_recipes/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages= [
    const HotPage(),
    const SearchPage(),
    const CreatePage(),
    const PersonalPage(),
  ];

  void navigateBar (int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text("R E C I P E   A P P")),
      ),

      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBar(index),
      ),

      body: _pages[_selectedIndex],
    );
  }
}