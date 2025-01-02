import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/password_model.dart';
import '../utils/encryption_helper.dart';

class ViewPasswordView extends StatelessWidget {
  final _encryptionHelper = EncryptionHelper();

  ViewPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the password from Get.arguments
    final Password password = Get.arguments;

    // Attempt to decrypt
    String decryptedPassword;
    try {
      decryptedPassword = _encryptionHelper.decrypt(password.encryptedPassword);
    } catch (e) {
      decryptedPassword = 'Error decrypting password: $e';
    }

    return Scaffold(
      appBar: AppBar(title: Text(password.title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Decrypted Password:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                decryptedPassword,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
