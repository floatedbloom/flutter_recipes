import 'package:flutter/material.dart';
import 'package:flutter_recipes/data/database.dart';
import 'package:flutter_recipes/models/recipe.dart';
import 'package:flutter_recipes/session/session_manager.dart';

class LaterPage extends StatefulWidget {
  const LaterPage({super.key});

  @override
  State<LaterPage> createState() => _LaterPageState();
}

class _LaterPageState extends State<LaterPage> {
  //declarations
  final DatabaseHelper dbHelper = DatabaseHelper();
  late Future<List<Recipe>> _favorites;
  late int userId;

  @override
  void initState() {
    //what to do when initializing
    super.initState();
    userId = SessionManager.instance.currentUserId ?? 0;
    _favorites = dbHelper.getLaterRecipes(userId).then((recipes) {
      return recipes.map((recipeMap) {
        return Recipe(
          name: recipeMap['name'],
          creator: recipeMap['creator'],
          ingredients: (recipeMap['ingredients'] as String).split(','),
          health: recipeMap['health'],
          type: recipeMap['type'],
          diet: recipeMap['diet'],
          image: AssetImage(recipeMap['image']),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('T R Y   L A T E R'))),
      body: FutureBuilder<List<Recipe>>(
        future: _favorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes saved for later.'));
          } else {
            List<Recipe> favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                Recipe recipe = favorites[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: recipe.image,
                    radius: 25,
                  ),
                  title: Text(recipe.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Creator: ${recipe.creator}'),
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
                      dbHelper.removeLaterRecipe(userId, recipeId);
                      setState(() {
                        favorites.remove(recipe);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Recipe removed from Try Later')),
                      );
                    }, 
                    label: const Text('Remove'),
                    icon: const Icon(Icons.remove_circle_rounded),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
