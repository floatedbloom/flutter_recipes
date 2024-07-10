import 'dart:async';
import 'package:flutter_recipes/models/recipe.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app.db');
    return await openDatabase(
      path,
      version: 1, 
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        email TEXT,
        password TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE recipes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        rating DOUBLE,
        raters int,
        creator TEXT,
        ingredients TEXT,
        health DOUBLE,
        type TEXT,
        diet TEXT,
      )
    ''');
    await db.execute('''
      CREATE TABLE favorite_recipes(
        user_id INTEGER,
        recipe_id INTEGER,
        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(recipe_id) REFERENCES recipes(id),
        PRIMARY KEY(user_id, recipe_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE later_recipes(
        user_id INTEGER,
        recipe_id INTEGER,
        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(recipe_id) REFERENCES recipes(id),
        PRIMARY KEY(user_id, recipe_id)
      )
    ''');
  }

  //get user stuff
  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<String> getPasswordByUsername(String username) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      columns: ['password'],
      where: 'username = ?',
      whereArgs: [username],
    );
    if (results.isNotEmpty) {
      return results.first['password'] as String;
    } else {
      throw Exception('User not found');
    }
  }

  Future<int> getIdByUsername(int username) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      columns: ['id'],
      where: 'username = ?',
      whereArgs: [username],
    );
    if (results.isNotEmpty) {
      return results.first['id'] as int;
    } else {
      throw Exception('User not found');
    }
  }

  //modify users

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await database;
    return await db.query('users');
  }

  Future<int> updatePassword(String username, String newPassword) async {
    Database db = await database;
    return await db.rawUpdate(
      'UPDATE users SET password = ? WHERE username = ?', [newPassword,username],
    );
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Recipe methods
  Future<int?> getIdByRecipe(Recipe recipe) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'recipes',
      columns: ['id'],
      where: 'name = ? AND creator = ? AND health = ? AND type = ? AND diet = ?',
      whereArgs: [recipe.name, recipe.creator, recipe.health, recipe.type, recipe.diet],
    );
    //check for emptiness
    if (results.isNotEmpty) {
      return results.first['id'] as int;
    } else {
      return null;
    }
  }

  Future<int> insertRecipe(Map<String, dynamic> recipe) async {
    Database db = await database;
    return await db.insert('recipes', recipe);
  }

  Future<List<Map<String, dynamic>>> getRecipes() async {
    Database db = await database;
    return await db.query('recipes');
  }

  Future<List<Map<String, dynamic>>> getUserRecipes(String username) async {
    Database db = await database;
    return await db.query('recipes', where: 'creator = ?', whereArgs: [username],);
  }

  Future<int> updateRecipe(Map<String, dynamic> recipe) async {
    Database db = await database;
    int id = recipe['id'];
    return await db.update('recipes', recipe, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteRecipe(int id) async {
    Database db = await database;
    return await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }
  // Favorite Recipes methods
  Future<int> addFavoriteRecipe(int userId, int recipeId) async {
    Database db = await database;
    return await db.insert('favorite_recipes', {
      'user_id': userId,
      'recipe_id': recipeId,
    });
  }

  Future<int> removeFavoriteRecipe(int userId, int recipeId) async {
    Database db = await database;
    return await db.delete(
      'favorite_recipes',
      where: 'user_id = ? AND recipe_id = ?',
      whereArgs: [userId, recipeId],
    );
  }

  Future<List<Map<String, dynamic>>> getFavoriteRecipes(int userId) async {
    Database db = await database;
    return await db.query(
      'recipes',
      columns: ['recipes.*'],
      where: 'recipes.id IN (SELECT recipe_id FROM favorite_recipes WHERE user_id = ?)',
      whereArgs: [userId],
    );
  }

  // Try Later Recipes methods
  Future<int> addLaterRecipe(int userId, int recipeId) async {
    Database db = await database;
    return await db.insert('later_recipes', {
      'user_id': userId,
      'recipe_id': recipeId,
    });
  }

  Future<int> removeLaterRecipe(int userId, int recipeId) async {
    Database db = await database;
    return await db.delete(
      'later_recipes',
      where: 'user_id = ? AND recipe_id = ?',
      whereArgs: [userId, recipeId],
    );
  }

  Future<List<Map<String, dynamic>>> getLaterRecipes(int userId) async {
    Database db = await database;
    return await db.query(
      'recipes',
      columns: ['recipes.*'],
      where: 'recipes.id IN (SELECT recipe_id FROM later_recipes WHERE user_id = ?)',
      whereArgs: [userId],
    );
  }

  Future<void> addRating(int recipeId, int newRating) async {
    Database db = await database;
    
    // Get the current rating
    List<Map<String, dynamic>> ratingResult = await db.query(
      'recipes',
      columns: ['rating'],
      where: 'id = ?',
      whereArgs: [recipeId],
    );

    // Ensure there is a result
    if (ratingResult.isEmpty) {
      throw Exception('Recipe not found');
    }
    
    // Extract the rating from the result set
    double rating = ratingResult.first['rating'] as double;

    // Get the current raters count
    List<Map<String, dynamic>> ratersResult = await db.query(
      'recipes',
      columns: ['raters'],
      where: 'id = ?',
      whereArgs: [recipeId],
    );

    // Ensure there is a result
    if (ratersResult.isEmpty) {
      throw Exception('Recipe not found');
    }

    // Extract the raters count from the result set
    int raters = ratersResult.first['raters'] as int;

    // Calculate the updated values
    int updatedRaters = raters + 1;
    double updatedRating = ((rating * raters) + newRating) / updatedRaters;

    //round
    double roundedUpdatedRating = double.parse(updatedRating.toStringAsFixed(1));

    // Update the database
    await db.rawUpdate(
      'UPDATE recipes SET rating=?, raters=? WHERE id=?',
      [roundedUpdatedRating, updatedRaters, recipeId]
    );
  }
}

