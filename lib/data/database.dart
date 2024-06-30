import 'dart:async';
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
        creator TEXT,
        ingredients TEXT,
        health DOUBLE,
        type TEXT,
        diet TEXT,
        image TEXT
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

  Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await database;
    int id = user['id'];
    return await db.update('users', user, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Recipe methods
  Future<int> insertRecipe(Map<String, dynamic> recipe) async {
    Database db = await database;
    return await db.insert('recipes', recipe);
  }

  Future<List<Map<String, dynamic>>> getRecipes() async {
    Database db = await database;
    return await db.query('recipes');
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
    return await db.insert('try_later_recipes', {
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
      where: 'recipes.id IN (SELECT recipe_id FROM try_later_recipes WHERE user_id = ?)',
      whereArgs: [userId],
    );
  }
}

