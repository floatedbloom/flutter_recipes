import 'package:flutter/material.dart';
import 'package:flutter_recipes/pages/change_password.dart';
import 'package:flutter_recipes/pages/favorites_page.dart';
import 'package:flutter_recipes/pages/later_page.dart';
import 'package:flutter_recipes/pages/own_recipes.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 500),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 20.0,
            padding: const EdgeInsets.all(20.0),
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.blueGrey)
                    )
                  )
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoritesPage()),
                  );
                },
                child: const Text("F A V O R I T E S"),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.blueGrey)
                    )
                  )
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LaterPage()),
                  );
                },
                child: const Text("T R Y   L A T E R"),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.blueGrey)
                    )
                  )
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OwnRecipes()),
                  );
                },
                child: const Text("M Y   R E C I P E S"),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.blueGrey)
                    )
                  )
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePassword()),
                  );
                },
                child: const Text("   C H A N G E\nP A S S W O R D"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
