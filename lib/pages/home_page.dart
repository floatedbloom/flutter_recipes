import 'package:flutter/material.dart';
import 'package:flutter_recipes/components/bottom_nav.dart';
import 'package:flutter_recipes/pages/favorites_page.dart';
import 'package:flutter_recipes/pages/hot_page.dart';
import 'package:flutter_recipes/pages/later_page.dart';
import 'package:flutter_recipes/pages/personal_page.dart';
import 'package:flutter_recipes/pages/search_page.dart';

//on start, homepage w/ nav bar, init on 'hot' page, list w/ search, favorites, create

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
    const FavoritesPage(),
    const PersonalPage(),
    const LaterPage(),
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
        title: const Text("R E C I P E   A P P"),
      ),

      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBar(index),
      ),

      body: _pages[_selectedIndex],
    );
  }
}