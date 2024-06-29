import 'package:flutter/material.dart';
import 'package:flutter_recipes/components/recipe_expand.dart';
import 'package:flutter_recipes/models/recipe.dart';

// ignore: must_be_immutable
class RecipeTile extends StatelessWidget {
  Recipe recipe;
  void Function()? onTap;

  RecipeTile({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //send to expanded view if you click a recipe tile
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => ExpandedView(name: recipe.name),
          ),
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
              child: recipe.image,
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
                    onTap: onTap,
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