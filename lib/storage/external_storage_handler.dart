import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ExternalStorageHandler {
  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      
      if (androidInfo.version.sdkInt >= 33) {
        // For Android 13+ (API 33+)
        final permissions = await Future.wait([
          Permission.photos.request(),
          Permission.videos.request(),
          Permission.audio.request(),
        ]);
        
        return permissions.every((status) => status.isGranted);
      } else {
        // For older Android versions
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return true; // For non-Android platforms
  }

  Future<String> getStoragePath() async {
    if (!await _requestPermissions()) {
      throw 'Storage permissions not granted';
    }

    final directory = await getApplicationDocumentsDirectory();
    // Create a specific folder for your app data
    final appFolder = Directory('${directory.path}/aesproject');
    
    if (!await appFolder.exists()) {
      await appFolder.create(recursive: true);
    }
    
    return appFolder.path;
  }

  Future<File> createFile(String fileName) async {
    final path = await getStoragePath();
    return File('$path/$fileName');
  }

  Future<bool> saveFile(String fileName, String content) async {
    try {
      final file = await createFile(fileName);
      await file.writeAsString(content);
      return true;
    } catch (e) {
      print('Error saving file: $e');
      return false;
    }
  }

  Future<String?> readFile(String fileName) async {
    try {
      final file = await createFile(fileName);
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      print('Error reading file: $e');
      return null;
    }
  }
}
