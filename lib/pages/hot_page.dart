import 'package:flutter/material.dart';
import 'package:flutter_recipes/components/recipe_tile.dart';
import 'package:flutter_recipes/models/recipe.dart';

class HotPage extends StatefulWidget {
  const HotPage({super.key});

  @override
  State<HotPage> createState() => _HotPageState();
}

class _HotPageState extends State<HotPage> {
  Recipe first = Recipe(
    name: 'first', creator: 'george', ingredients: ['sugar', 'water'], 
    health: 3.3, type: 'first', diet: 'keto', image: const AssetImage('images/water.jfif')
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RecipeTile(recipe: first),  
        ],
      )
    );
  }
}