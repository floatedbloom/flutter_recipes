import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_recipes/components/recipe_tile.dart';
import 'package:flutter_recipes/data/database.dart';
import 'package:flutter_recipes/models/recipe.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Recipe> filteredRecipes = [];
  List<Recipe> recipes = [];

  //load recipes and convert them from db's to Recipe type
  void loadRecipes() async {
    List<Map<String, dynamic>> recipeMaps = await dbHelper.getRecipes();
    List<Recipe> fetchedRecipes = recipeMaps.map((recipeMap) {
      return Recipe(
        name: recipeMap['name'],
        creator: recipeMap['creator'],
        ingredients: (recipeMap['ingredients'] as String).split(','),
        health: recipeMap['health'],
        type: recipeMap['type'],
        diet: recipeMap['diet'],
        image: FileImage(File(recipeMap['image'])),
      );
    }).toList();

    setState(() {
      recipes = fetchedRecipes;
    });
  }

  @override
  //initialize to have all recipes
  void initState() {
    loadRecipes();
    super.initState();
  }

  //dynamically filter recipes while typing into search
  void _onSearchChanged(String query) {
    setState(() {
      filteredRecipes = recipes.where((recipe) =>
          recipe.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search Recipes...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                return RecipeTile(recipe: filteredRecipes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}