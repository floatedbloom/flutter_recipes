import 'package:flutter/material.dart';
import 'package:flutter_recipes/pages/home_page.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  //await for Hive (remember favorites, etc.)
  await Hive.initFlutter();

  //open Hive box

  var box = Hive.openBox('box');

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
