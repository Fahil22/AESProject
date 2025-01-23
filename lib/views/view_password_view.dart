import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../models/password_model.dart';
import '../utils/encryption_helper.dart';

class ViewPasswordView extends StatefulWidget {
  const ViewPasswordView({Key? key}) : super(key: key);

  @override
  _ViewPasswordViewState createState() => _ViewPasswordViewState();
}

class _ViewPasswordViewState extends State<ViewPasswordView> {
  final EncryptionHelper _encryptionHelper = EncryptionHelper();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final Password password = Get.arguments;
    String decryptedPassword;

    try {
      decryptedPassword = _encryptionHelper.decrypt(password.encryptedPassword);
    } catch (e) {
      decryptedPassword = 'Error decrypting password';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(password.title, style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),),
        backgroundColor: const Color.fromARGB(221, 46, 154, 226),
        actions: [
          IconButton(
            icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.white),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.white),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: decryptedPassword));
              Get.snackbar(
                'Copied',
                'Password copied to clipboard',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color.fromARGB(221, 46, 154, 226),
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(221, 0, 57, 95),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: const Color.fromARGB(221, 0, 57, 95)
                .withOpacity(0.5)
                .withAlpha(44),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Decrypted Password:',
                    style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isPasswordVisible
                        ? decryptedPassword
                        : '*' * decryptedPassword.length,
                    style:  GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _calculatePasswordStrength(decryptedPassword);
                        },
                        icon: const Icon(
                          Icons.security,
                          color: Colors.white,
                        ),
                        label:  Text('Check Strength',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _calculatePasswordStrength(String password) {
    int strength = 0;

    // Length check
    strength += password.length > 12
        ? 2
        : password.length > 8
            ? 1
            : 0;

    // Complexity checks
    strength += password.contains(RegExp(r'[A-Z]')) ? 1 : 0;
    strength += password.contains(RegExp(r'[a-z]')) ? 1 : 0;
    strength += password.contains(RegExp(r'[0-9]')) ? 1 : 0;
    strength += password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ? 1 : 0;

    String strengthText;
    Color strengthColor;

    switch (strength) {
      case 0:
      case 1:
        strengthText = 'Weak';
        strengthColor = Colors.red;
        break;
      case 2:
      case 3:
        strengthText = 'Medium';
        strengthColor = Colors.orange;
        break;
      case 4:
      case 5:
        strengthText = 'Strong';
        strengthColor = Colors.green;
        break;
      default:
        strengthText = 'Very Strong';
        strengthColor = Colors.teal;
    }

    Get.defaultDialog(
      title: 'Password Strength',
      content: Column(
        children: [
          Text(
            strengthText,
            style: TextStyle(
              color: strengthColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text('Strength Score: $strength/5'),
        ],
      ),
      confirm: TextButton(
        onPressed: () => Get.back(),
        child: const Text('OK'),
      ),
    );
  }
}
