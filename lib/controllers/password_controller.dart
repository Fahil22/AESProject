import 'package:aesproject/controllers/database_helper.dart';
import 'package:aesproject/main.dart';
import 'package:get/get.dart';
import '../models/password_model.dart';
import '../utils/encryption_helper.dart';

class PasswordController extends GetxController {
  final EncryptionHelper _encryptionHelper = EncryptionHelper();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  var passwords = <Password>[].obs;
  int? userId;

  @override
  void onInit() {
    super.onInit();
    _loadUserId();
  }

  // Load user ID from Shared Preferences
  void _loadUserId() async {
    userId = prefs!.getInt('userId');
    print("${userId}"+"user id");
    if (userId != null) {
      loadPasswords();
    }
  }

  // Load passwords from the database
  void loadPasswords() async {
    if (userId == null) return;

    final passwordMaps = await _dbHelper.getPasswords(userId!);
    passwords.value = passwordMaps
        .map((item) => Password.fromJson(item))
        .toList();
  }

  // Add a new password
  void addPassword(String title, String plaintextPassword) async {
    if (userId == null) return;

    final encrypted = _encryptionHelper.encrypt(plaintextPassword);
    final password = Password(
      id: null, // ID will be auto-incremented
      userId: userId!,
      title: title,
      encryptedPassword: encrypted,
    );

    final id = await _dbHelper.insertPassword(password.toJson());
    password.id = id;
    passwords.add(password);
  }

  // Update an existing password
  void updatePassword(int id, String newTitle, String newPlaintextPassword) async {
    final index = passwords.indexWhere((p) => p.id == id);
    if (index != -1) {
      final encryptedPassword = _encryptionHelper.encrypt(newPlaintextPassword);

      final updatedPassword = Password(
        id: id,
        userId: userId!,
        title: newTitle,
        encryptedPassword: encryptedPassword,
      );

      await _dbHelper.updatePassword(updatedPassword.toJson(), id);
      passwords[index] = updatedPassword;
    }
  }

  // Delete a password
  void deletePassword(int id) async {
    await _dbHelper.deletePassword(id);
    passwords.removeWhere((p) => p.id == id);
  }
}
