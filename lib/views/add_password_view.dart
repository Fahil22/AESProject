import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/password_controller.dart';

class AddPasswordView extends StatelessWidget {
  final PasswordController _controller = Get.find();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AddPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _controller.addPassword(
                  _titleController.text,
                  _passwordController.text,
                );
                Get.back();
              },
              child: const Text('Save Password'),
            ),
          ],
        ),
      ),
    );
  }
}
