import 'package:flutter/material.dart';
import 'package:flutter_recipes/data/database.dart';
import 'package:flutter_recipes/pages/create_account.dart';
import 'package:flutter_recipes/pages/home_page.dart';
import 'package:flutter_recipes/session/session_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //controllers for info
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async{
    String username = _usernameController.text;
    String password = _passwordController.text;

    //authentication
    bool isAuthenticated = await _authenticateUser(username, password);

    if (isAuthenticated) {
      await SessionManager.instance.setUser(username);
      //go to next screen
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password'))
      );
    }

  }

  Future<bool> _authenticateUser(String username, String password) async{
    var user = await DatabaseHelper().getUserByUsername(username);
    if (user != null) {
      String realPassword = await DatabaseHelper().getPasswordByUsername(username);
      if (password == realPassword) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("L O G I N")),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            //username field
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            //password field
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login, 
              child: const Text(
                'Login', 
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => CreateAccount(),
                  ),
                );
              }, 
              child: const Text(
                'Create Account', 
                style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}