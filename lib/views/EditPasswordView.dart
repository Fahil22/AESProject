import 'package:aesproject/utils/encryption_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/password_controller.dart';
import '../models/password_model.dart';
import 'package:aesproject/main.dart';

class EditPasswordView extends StatelessWidget {
  final PasswordController _controller = Get.find();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  EditPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the password from Get.arguments
    final Password password = Get.arguments;
  final _encryptionHelper = EncryptionHelper();

    // Populate initial values
    _titleController.text = password.title;
     final decryptedPassword = _encryptionHelper.decrypt(password.encryptedPassword);
    _passwordController.text = decryptedPassword;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Password'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _controller.updatePassword(
                      password.id??0,

                      _titleController.text,
                      _passwordController.text,
                    );
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Update Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
