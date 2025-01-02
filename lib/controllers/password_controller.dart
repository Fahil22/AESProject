import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/password_model.dart';
import '../utils/encryption_helper.dart';
import '../storage/external_storage_handler.dart';

class PasswordController extends GetxController {
  final GetStorage _storage = GetStorage();
  final EncryptionHelper _encryptionHelper = EncryptionHelper();
  final ExternalStorageHandler _externalStorageHandler = ExternalStorageHandler();

  // Observable list of password objects
  var passwords = <Password>[].obs;

  /// Adds a new password, encrypts it, and saves to GetStorage + file
  void addPassword(String title, String plaintextPassword) {
    final encrypted = _encryptionHelper.encrypt(plaintextPassword);

    final password = Password(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      encryptedPassword: encrypted,
    );

    passwords.add(password);
    _saveToBoth();
  }

  /// Deletes a password by id
  void deletePassword(String id) {
    final index = passwords.indexWhere((p) => p.id == id);
    if (index != -1) {
      passwords.removeAt(index);
      _saveToBoth();
    }
  }

  /// Reads from GetStorage, populates [passwords], then mirrors to file
  void loadPasswords() {
    try {
      // 1) Load from GetStorage
      final storedData = _storage.read<List>('passwords') ?? [];
      passwords.value = storedData
          .map((item) => Password.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      // 2) Mirror to external file
      _saveToFile();
    } catch (e) {
      print('Error loading passwords from GetStorage: $e');
    }
  }

  /// Save to GetStorage, then also overwrite the file with the same data
  void _saveToBoth() {
    try {
      // 1) Save to GetStorage
      final jsonList = passwords.map((p) => p.toJson()).toList();
      _storage.write('passwords', jsonList);

      // 2) Mirror to external file
      _saveToFile();
    } catch (e) {
      print('Error saving passwords: $e');
    }
  }

  /// Overwrite the external file with the current [passwords] list
  void _saveToFile() async {
    try {
      final jsonList = passwords.map((p) => p.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      await _externalStorageHandler.saveToFile(jsonString);
    } catch (e) {
      print('Error writing to external file: $e');
    }
  }
}
