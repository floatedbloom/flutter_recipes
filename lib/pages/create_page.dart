import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_recipes/data/database.dart';
import 'package:flutter_recipes/models/recipe.dart';
import 'package:flutter_recipes/session/session_manager.dart';
import 'package:image_picker/image_picker.dart';

//cant create a recipe with a name you already used
//show creation screen

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper dbHelper = DatabaseHelper();

  String username = SessionManager.instance.currentUsername!;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _healthController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _dietController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  File? _image;

  @override
  void dispose() {
    _nameController.dispose();
    _ingredientsController.dispose();
    _healthController.dispose();
    _typeController.dispose();
    _dietController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      Recipe newRecipe = Recipe(
        name: _nameController.text,
        creator: username,
        ingredients: _ingredientsController.text.split(','),
        health: double.parse(_healthController.text),
        type:_typeController.text,
        diet: _dietController.text,
        image: AssetImage(_imageController.text),
      );

      await dbHelper.insertRecipe(newRecipe.toMap());

      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageController.text = pickedFile.path;
      });
    }

  }

  String? _validateIngredients(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter ingredients';
    }
    final regex = RegExp(r'^([^,]+,)*[^,]+$');
    if (!regex.hasMatch(value)) {
      return 'Please enter a comma-separated list';
    }
    return null;
  }

  String? _validateHealth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a health rating';
    }
    final health = double.tryParse(value);
    if (health == null || health < 1 || health > 5) {
      return 'Please enter a number between 1 and 5';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Recipe Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name missing";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(labelText: "Ingredients (commas and no spaces)"),
                validator: _validateIngredients,
              ),
              TextFormField(
                controller: _healthController,
                decoration: const InputDecoration(labelText: "Healthiness"),
                validator: _validateHealth,
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: "Type"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Type missing";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dietController,
                decoration: const InputDecoration(labelText: "Diet"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Diet missing";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: "Image Path"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Image missing";
                  }
                  return null;
                },
                readOnly: true,
                onTap: _pickImage,
              ),
              _image != null
                  ? Image.file(_image!)
                  : const Text('No image selected.'),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: ElevatedButton(
                  onPressed: () {
                    _saveRecipe;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Recipe created')),
                    );
                  },
                  child: const Text("Save recipe")
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}