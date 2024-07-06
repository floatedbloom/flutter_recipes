import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipes/data/database.dart';
import 'package:flutter_recipes/models/recipe.dart';
import 'dart:ui';

import 'package:flutter_recipes/session/session_manager.dart';

//5star rating neeeded

// ignore: must_be_immutable
class RecipeTile extends StatelessWidget {
  Recipe recipe;
  final DatabaseHelper dbHelper = DatabaseHelper();

  RecipeTile({super.key, required this.recipe});

  //add to favorite function
  void addFavorite(Recipe r) async {
    int userId = SessionManager.instance.currentUserId ?? 0;
    print(userId);
    int recipeId = await dbHelper.getIdByRecipe(recipe) ?? 0;
    print(recipeId);
    dbHelper.addFavoriteRecipe(userId, recipeId);
  }

  //add to later function
  void addLater(Recipe r) async {
    int userId = SessionManager.instance.currentUserId ?? 0;
    int recipeId = await dbHelper.getIdByRecipe(recipe) ?? 0;
    dbHelper.addLaterRecipe(userId, recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //open expanded view if you click a recipe tile
      onTap: () {
        showCupertinoModalPopup(
          context: context, 
          builder: (BuildContext context) {
            return Center(
              child: SizedBox(
                //not quite fully screen-sized
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  //blurs the bakcground
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: CupertinoPopupSurface(
                      child: Material(
                        color: Colors.transparent,
                        //scrollable
                        child: Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //top is recipe name
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  color: const Color.fromARGB(255, 43, 73, 86),
                                  child: Center(
                                    child: Text(
                                      recipe.name,
                                      style: const TextStyle(color: Colors.white, fontSize: 24),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                //general info
                                Container(
                                  padding: const EdgeInsets.all(25.0),
                                  color: const Color.fromARGB(255, 87, 149, 143),
                                  child: Column(
                                    children: [
                                      Text('Creator: ${recipe.creator}', style: const TextStyle(color: Color.fromARGB(255, 121, 54, 75), fontSize: 20, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      Text('Rating: ${recipe.rating}', style: const TextStyle(color: Color.fromARGB(255, 121, 54, 75), fontSize: 20, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      Text('Healthiness: ${recipe.health}', style: const TextStyle(color: Color.fromARGB(255, 121, 54, 75), fontSize: 20, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      Text('Type of food: ${recipe.type}', style: const TextStyle(color: Color.fromARGB(255, 121, 54, 75), fontSize: 20, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      Text('Specified diet: ${recipe.diet}', style: const TextStyle(color: Color.fromARGB(255, 121, 54, 75), fontSize: 20, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      Text('Ingredients: ${recipe.ingredients}', style: const TextStyle(color: Color.fromARGB(255, 121, 54, 75), fontSize: 20, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 20),
                                      Image(image: recipe.image) 
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),                              
                                //5 star rating scale
                                //this is hard
                                const SizedBox(height: 10),
                                
                                //favorite button
                                CupertinoButton(
                                  child: const Text('Favorite'),
                                  onPressed: () {
                                    addFavorite(recipe);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Recipe added to Favorites')),
                                    );
                                  },
                                ),
                                const SizedBox(height: 5),
                                //close button
                                CupertinoButton(
                                  child: const Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        );
      },
      child: Container(
        margin: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 129, 161, 187),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                recipe.name, 
                style: const TextStyle(
                  color: Color.fromARGB(255, 67, 63, 63),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
      
            //image clipped
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(image: recipe.image),
            ),
            
            //smaller elements
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //creator name
                      Text(recipe.creator, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      //star rating
                      Text('\u2B50${recipe.rating}', style: const TextStyle(color: Colors.black )),
                      const SizedBox(height: 5),
                      //health rating
                      Text('\u2764\uFE0F${recipe.health}', style: const TextStyle(color: Colors.black )),
                    ],
                  ),
                  //save for later button
                  GestureDetector(
                    onTap: () {
                      addLater(recipe);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Recipe added to Try Later')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(21),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12), bottomRight: Radius.circular(12)
                        )
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}