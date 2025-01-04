import 'package:aesproject/controllers/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aesproject/main.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({Key? key}) : super(key: key);

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final user = await DatabaseHelper.instance.getUser(username, password);

    if (user != null) {
      // Store user ID in Shared Preferences
       prefs!.setInt('userId', user['id']);

      // Navigate to the home view
      Get.offAllNamed('/');
    } else {
      Get.snackbar(
        'Login Failed',
        'Invalid username or password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final user = await DatabaseHelper.instance.getUser(
                  _usernameController.text,
                  _passwordController.text,
                );
               
                if (user != null) {
                   _login();
                } else {
                  Get.snackbar('Login Failed', 'Invalid username or password',
                      backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
