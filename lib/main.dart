import 'package:flutter/material.dart';
import 'package:flutter_recipes/pages/home_page.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  //await sqlite
  var db = await openDatabase('app_db.db');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
