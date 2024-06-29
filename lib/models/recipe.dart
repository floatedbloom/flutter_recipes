import 'package:flutter/material.dart';

class Recipe {
  final String name;
  final double rating;
  final String creator;
  final List<String> ingredients;
  final double health;
  final String type;
  final String diet;
  final String flavor;
  final Image image;

  Recipe({
    required this.name, required this.rating, required this.creator, required this.ingredients,
    required this.health, required this.type, required this.diet, required this.flavor, 
    required this.image,
    });
}