//import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_recipes/components/recipe_tile.dart';
import 'package:flutter_recipes/data/database.dart';
import 'package:flutter_recipes/models/recipe.dart';

class HotPage extends StatefulWidget {
  const HotPage({super.key});

  @override
  State<HotPage> createState() => _HotPageState();
}

class _HotPageState extends State<HotPage> {
  DatabaseHelper dbHelper = DatabaseHelper();
  List<Recipe> selectedRecipes = [];

  @override
  void initState() {
    super.initState();
    _fetchAndSelectRecipes();
  }

  Future<void> _fetchAndSelectRecipes() async {
    List<Map<String, dynamic>> recipeMaps = await dbHelper.getRecipes();
    List<Recipe> recipes = recipeMaps.map((recipeMap) {
      return Recipe(
        name: recipeMap['name'],
        creator: recipeMap['creator'],
        ingredients: (recipeMap['ingredients'] as String).split(','),
        health: recipeMap['health'],
        type: recipeMap['type'],
        diet: recipeMap['diet'],
        rating: recipeMap['rating'],
        raters: recipeMap['raters'],
        //image: FileImage(File(recipeMap['image'])),
      );
    }).toList();
    setState(() {
      selectedRecipes = _selectRandomRecipes(recipes, 3);
    });
  }

  List<Recipe> _selectRandomRecipes(List<Recipe> recipes, int count) {
    if (recipes.length <= count) {
      return recipes;
    } else {
      recipes.shuffle(Random());
      return recipes.sublist(0, count);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: selectedRecipes.isEmpty
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: selectedRecipes.length,
                      padding: const EdgeInsets.all(20.0),
                      itemBuilder: (context, index) {
                        return RecipeTile(recipe: selectedRecipes[index]);
                      },
                    ),
                  ),
                ]
              ),
      ),
    );
  }
}