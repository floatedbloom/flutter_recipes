import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_recipes/components/recipe_tile.dart';
import 'package:flutter_recipes/data/database.dart';
import 'package:flutter_recipes/models/recipe.dart';
import 'package:flutter_recipes/session/session_manager.dart';

class OwnRecipes extends StatefulWidget {
  const OwnRecipes({super.key});

  @override
  State<OwnRecipes> createState() => _OwnRecipesState();
}

class _OwnRecipesState extends State<OwnRecipes> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  String username = SessionManager.instance.currentUsername!;
  List<Recipe> recipes = [];

  //load recipes and convert them from db's to Recipe type
  void loadRecipes() async {
    List<Map<String, dynamic>> recipeMaps = await dbHelper.getUserRecipes(username);
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

  void _deleteRecipe(Recipe recipe) async {
    int recipeId = await dbHelper.getIdByRecipe(recipe) ?? 0;
    await dbHelper.deleteRecipe(recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
              child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return RecipeTile(recipe: recipes[index]);
                },
              ),
            ),
    );
  }
}