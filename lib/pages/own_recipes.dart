//import 'dart:io';

import 'package:flutter/material.dart';
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
  late int userId;
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
        rating: recipeMap['rating'],
        raters: recipeMap['raters'],
        //image: FileImage(File(recipeMap['image'])),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('M Y   R E C I P E S'))),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          Recipe recipe = recipes[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 175, 102, 163),
              radius: 25,
            ),
            title: Text(recipe.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rating: ${recipe.rating.toStringAsFixed(1)}'),
                Text('Health: ${recipe.health.toStringAsFixed(1)}'),
                Text('Type: ${recipe.type}'),
                Text('Diet: ${recipe.diet}'),
                Text('Ingredients: ${recipe.ingredients.join(', ')}'),
              ],
            ),
            trailing: ElevatedButton.icon(
              onPressed: () async {
                userId = SessionManager.instance.currentUserId ?? 0;
                int recipeId = await dbHelper.getIdByRecipe(recipe) ?? 0;
                dbHelper.deleteRecipe(recipeId);
                setState(() {
                  recipes.remove(recipe);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recipe deleted')),
                );
              }, 
              label: const Text('Delete'),
              icon: const Icon(Icons.remove_circle_rounded),
            ),
          );
        },
      ),
    );
  }
}

      