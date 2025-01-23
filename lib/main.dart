import 'package:aesproject/controllers/database_helper.dart';
import 'package:aesproject/views/EditPasswordView.dart';
import 'package:aesproject/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/home_view.dart';
import 'views/add_password_view.dart';
import 'views/view_password_view.dart';
SharedPreferences ? prefs;
  final dbHelper = DatabaseHelper.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dbHelper.flushDatabase();

  // Initialize GetStorage
  await GetStorage.init();
  prefs = await SharedPreferences.getInstance();
  // Request appropriate storage permissions
  await requestPermissions();

  runApp(const MyApp());
}

/// Request storage permissions based on the Android version

Future<void> requestPermissions() async {
  if (await Permission.manageExternalStorage.request().isGranted) {
    print("Manage external storage permission granted");
  } else if (await Permission.storage.request().isGranted) {
    print("Storage permission granted");
  } else {
    print("Storage permission denied");
    // Show dialog to explain why permissions are needed
    Get.dialog(
      AlertDialog(
        title: Text('Storage Permission Required'),
        content: Text('This app needs storage access to save your encrypted passwords securely.'),
        actions: [
          TextButton(
            child: Text('Open Settings'),
            onPressed: () {
              Get.back();
              openAppSettings();
            },
          ),
        ],
      ),
    );
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: prefs!.getInt('userId') == null ? '/login' : '/',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/', page: () => HomeView()),
        GetPage(name: '/add_password', page: () => AddPasswordView()),
        GetPage(name: '/view_password', page: () => ViewPasswordView()),
        GetPage(name: '/edit_password', page: () => EditPasswordView()),
      ],
    );
  }
}
