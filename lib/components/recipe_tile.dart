import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipes/data/database.dart';
import 'package:flutter_recipes/models/recipe.dart';
import 'dart:ui';

import 'package:flutter_recipes/session/session_manager.dart';

//5satr rating could take a while

//need 2 functions to be completed

// ignore: must_be_immutable
class RecipeTile extends StatelessWidget {
  Recipe recipe;
  final DatabaseHelper dbHelper = DatabaseHelper();

  RecipeTile({super.key, required this.recipe});

  //add to favorite function
  void addFavorite(Recipe r) async {
    int userId = SessionManager.instance.currentUserId ?? 0;
    int recipeId = await DatabaseHelper().getIdByRecipe(recipe) ?? 0;
    dbHelper.addFavoriteRecipe(userId, recipeId);
  }

  //add to later function
  void addLater(Recipe r) async {

  }

  //rating function 
  void rateRecipe(Recipe r) {

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
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //top is recipe name
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                color: const Color.fromARGB(255, 149, 91, 87),
                                child: Text(
                                  recipe.name,
                                  style: const TextStyle(color: Colors.white, fontSize: 24),
                                ),
                              ),
                              const SizedBox(height: 10),
                              //general info
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                color: const Color.fromARGB(255, 87, 149, 143),
                                child: Column(
                                  children: [
                                    Text('Creator: ${recipe.creator}'),
                                    Text('Rating: ${recipe.rating}'),
                                    Text('Healthiness: ${recipe.health}'),
                                    Text('Type of food: ${recipe.type}'),
                                    Text('Specified diet: ${recipe.diet}'),
                                    Text('Ingredients: ${recipe.ingredients}'),
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
                      Text('\u2B50${recipe.rating}', style: const TextStyle(color: Colors.grey )),
                      const SizedBox(height: 5),
                      //health rating
                      Text('\u2764\uFE0F${recipe.health}', style: const TextStyle(color: Colors.grey )),
                    ],
                  ),
                  //save for later button
                  GestureDetector(
                    onTap: () {
                      addLater(recipe);
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