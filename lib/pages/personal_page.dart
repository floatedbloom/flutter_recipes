import 'package:flutter/material.dart';
import 'package:flutter_recipes/pages/favorites_page.dart';
import 'package:flutter_recipes/pages/later_page.dart';
import 'package:flutter_recipes/pages/own_recipes.dart';

//previously created recipes[delete uploaded recipe], change password, favorites, laters

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesPage()));
              }, 
              child: const Text("Favorites")
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LaterPage()));
              }, 
              child: const Text("Try Later")
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnRecipes()));
              }, 
              child: const Text("Creations")
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesPage()));
              }, 
              child: const Text("Change Password")
            ),
          ],
        ),
      )
    );
  }
}