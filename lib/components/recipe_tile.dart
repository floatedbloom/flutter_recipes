import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipes/data/database.dart';
import 'package:flutter_recipes/models/recipe.dart';
import 'package:flutter_recipes/pages/home_page.dart';
import 'package:flutter_recipes/session/session_manager.dart';

// ignore: must_be_immutable
class RecipeTile extends StatefulWidget {
  Recipe recipe;

  RecipeTile({super.key, required this.recipe});

  @override
  State<RecipeTile> createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  int? selectedRating;

  void addFavorite(Recipe r) async {
    int userId = SessionManager.instance.currentUserId ?? 0;
    int recipeId = await dbHelper.getIdByRecipe(widget.recipe) ?? 0;
    dbHelper.addFavoriteRecipe(userId, recipeId);
  }

  void addLater(Recipe r) async {
    int userId = SessionManager.instance.currentUserId ?? 0;
    int recipeId = await dbHelper.getIdByRecipe(widget.recipe) ?? 0;
    dbHelper.addLaterRecipe(userId, recipeId);
  }

  void addRating(Recipe r, int myRating) async {
    int recipeId = await dbHelper.getIdByRecipe(widget.recipe) ?? 0;
    await dbHelper.addRating(recipeId, myRating);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: CupertinoPopupSurface(
                      child: Material(
                        color: Colors.transparent,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                width: MediaQuery.of(context).size.width * 0.9,
                                color: const Color.fromARGB(255, 43, 73, 86),
                                child: Center(
                                  child: Text(
                                    widget.recipe.name,
                                    style: const TextStyle(color: Colors.white, fontSize: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(25.0),
                                color: const Color.fromARGB(255, 87, 149, 143),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Creator: ${widget.recipe.creator}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Text('Rating: ${widget.recipe.rating}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Text('Healthiness: ${widget.recipe.health}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Text('Type of food: ${widget.recipe.type}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Text('Specified diet: ${widget.recipe.diet}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Text('Ingredients: ${widget.recipe.ingredients}', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                    //const SizedBox(height: 20),
                                    //Image(image: widget.recipe.image)
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      for (int i = 1; i <= 5; i++)
                                        CupertinoButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedRating = i;
                                            });
                                          },
                                          child: Icon(
                                            selectedRating != null && i <= selectedRating!
                                                ? CupertinoIcons.star_fill
                                                : CupertinoIcons.star,
                                            color: selectedRating != null && i <= selectedRating!
                                                ? Colors.orange
                                                : Colors.grey,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  CupertinoButton(
                                    onPressed: () {
                                      if (selectedRating != null) {
                                        addRating(widget.recipe, selectedRating!);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const HomePage()),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Recipe rated with $selectedRating stars')),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Please select a rating')),
                                        );
                                      }
                                    },
                                    child: const Text('Rate Recipe'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              CupertinoButton(
                                child: const Text('Favorite'),
                                onPressed: () {
                                  addFavorite(widget.recipe);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Recipe added to Favorites')),
                                  );
                                },
                              ),
                              const SizedBox(height: 5),
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
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 129, 161, 187),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    widget.recipe.name,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 67, 63, 63),
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            const Center(
               child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),  child: Icon(Icons.hot_tub),),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Text(widget.recipe.creator, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                        const SizedBox(height: 5),
                        Center(
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.yellow, size: 28),
                              Text('${widget.recipe.rating}', style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20,)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: Row(
                            children: [
                              const Icon(Icons.favorite, color: Colors.red, size: 28),
                              Text('${widget.recipe.health}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20,)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      addLater(widget.recipe);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Recipe added to Try Later')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
