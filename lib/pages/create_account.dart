import 'package:flutter/material.dart';
import 'package:flutter_recipes/data/database.dart';
import 'package:flutter_recipes/pages/login.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

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

    //capture context
    BuildContext currentContext = context;

    //check the 2 passwords
    if (confirm != password) {
      ScaffoldMessenger.of(currentContext).showSnackBar(
        const SnackBar(content: Text('Passwords do not match'))
      );
    } else {
      //craete new user as Map
      Map<String, dynamic> userMap = {
        'username': username,
        'password': password,
        'email': email,
      };      
      //put into db
      await DatabaseHelper().insertUser(userMap);

      //send to login screen
      Navigator.of(currentContext).push(
        MaterialPageRoute(
          builder: (context) => const LoginScreen()
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('C R E A T E   A C C O U N T'), automaticallyImplyLeading: false, centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'U S E R N A M E'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E M A I L'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'P A S S W O R D'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmController,
              decoration: const InputDecoration(labelText: 'C O N F I R M   P A S S W O R D'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createAccount,
              child: const Text('C R E A T E'),
            ),
          ],
        ),
      ),
    );
  }
}
