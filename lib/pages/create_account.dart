import 'package:flutter/material.dart';
import 'package:flutter_recipes/data/database.dart';
import 'package:flutter_recipes/pages/login.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  //fields values
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();


  Future<void> _createAccount() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirm = _confirmController.text;

    //check the 2 passwords
    if (confirm != password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match'))
      );
    } else {
      //craete new user as Map
      Map<String, dynamic> userMap = {
        'name': username,
        'password': password,
        'email': email,
      };      
      //put into db
      await DatabaseHelper().insertUser(userMap);

      //send to login screen
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const LoginScreen()
        ),
      );
    }

    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createAccount,
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
