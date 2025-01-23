import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/password_controller.dart';

class AddPasswordView extends StatelessWidget {
  final PasswordController _controller = Get.find();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AddPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Add Password', style:  GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),),
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
                    'Add Password',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle:  GoogleFonts.poppins(
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
                    style: const TextStyle(color: Colors.white),
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
    // Validate password length
    if (_passwordController.text.length > 64) {
      Get.snackbar(
        'Error', 
        'Password cannot exceed 64 characters',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM, // Optional: ensures consistent snackbar position
      );
      return;
    }

    // Ensure title and password are not empty
    if (_titleController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Both Title and Password are required',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Add password
    _controller.addPassword(
      _titleController.text.trim(), // Trim extra spaces
      _passwordController.text,
    );

    // Close the dialog or screen
    Get.back();
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white.withOpacity(0.2), // Semi-transparent button
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Rounded corners
    ),
  ),
  child: Text(
    'Save Password',
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