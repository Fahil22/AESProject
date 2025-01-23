import 'package:aesproject/utils/encryption_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final Password password = Get.arguments;
    final _encryptionHelper = EncryptionHelper();

    _titleController.text = password.title;
    final decryptedPassword =
        _encryptionHelper.decrypt(password.encryptedPassword);
    _passwordController.text = decryptedPassword;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Password',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(221, 46, 154, 226),
      ),
      backgroundColor: const Color.fromARGB(221, 0, 57, 95),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Edit Password',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _titleController,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      // Validate that the title and password fields are not empty
                      if (_titleController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Both Title and Password are required',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      // Validate password length
                      if (_passwordController.text.length > 64) {
                        Get.snackbar(
                          'Error',
                          'Password cannot exceed 64 characters',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      _controller.updatePassword(
                        password.id ?? 0,
                        _titleController.text,
                        _passwordController.text,
                      );

                      // Close the dialog or screen
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white
                          .withOpacity(0.2), // Semi-transparent button
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    child: Text(
                      'Update Password',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
