import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'views/home_view.dart';
import 'views/add_password_view.dart';
import 'views/view_password_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Request appropriate storage permissions
  await requestPermissions();

  runApp(const MyApp());
}

/// Request storage permissions based on the Android version

Future<void> requestPermissions() async {
  if (await Permission.storage.request().isGranted) {
    print("Storage permission granted");
  } else if (await Permission.manageExternalStorage.request().isGranted) {
    print("Manage external storage permission granted");
  } else {
    print("Storage permission denied");
    await openAppSettings();
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeView()),
        GetPage(name: '/add_password', page: () => AddPasswordView()),
        GetPage(name: '/view_password', page: () => ViewPasswordView()),
      ],
    );
  }
}
