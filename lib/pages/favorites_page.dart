import 'package:flutter/material.dart';
import 'package:flutter_recipes/data/database.dart';
import 'package:flutter_recipes/models/recipe.dart';
import 'package:flutter_recipes/session/session_manager.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  //declarations
  final DatabaseHelper dbHelper = DatabaseHelper();
  late Future<List<Recipe>> _favorites;
  late int userId;

  @override
  void initState() {
    //what to do when initializing
    super.initState();
    userId = SessionManager.instance.currentUserId ?? 0;
    _favorites = dbHelper.getFavoriteRecipes(userId).then((recipes) {
      return recipes.map((recipeMap) {
        return Recipe(
          name: recipeMap['name'],
          creator: recipeMap['creator'],
          ingredients: (recipeMap['ingredients'] as String).split(','),
          health: recipeMap['health'],
          type: recipeMap['type'],
          diet: recipeMap['diet'],
          rating: recipeMap['rating'],
          raters: recipeMap['raters'],
          //image: AssetImage(recipeMap['image']),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('F A V O R I T E S'))),
      body: FutureBuilder<List<Recipe>>(
        future: _favorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No created recipes.'));
          } else {
            List<Recipe> favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                Recipe recipe = favorites[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.amber,
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
                      dbHelper.removeFavoriteRecipe(userId, recipeId);
                      setState(() {
                        favorites.remove(recipe);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Recipe removed from Favorites')),
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
