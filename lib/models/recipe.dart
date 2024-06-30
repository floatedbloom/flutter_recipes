import 'package:flutter/material.dart';

class Recipe {
  final String name;
  double rating = 5;
  final String creator;
  final List<String> ingredients;
  final double health;
  final String type;
  final String diet;
  final ImageProvider image;

  Recipe({
    required this.name, //required this.rating, 
    required this.creator, required this.ingredients,
    required this.health, required this.type, required this.diet, required this.image,
    });
}