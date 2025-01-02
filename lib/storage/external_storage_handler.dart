import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ExternalStorageHandler {
  /// Returns a File handle in external storage: /Android/data/<package>/files/passwords.txt
  Future<File> _getFile() async {
    // Request permission if needed
    if (await _requestStoragePermission()) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final filePath = '${directory.path}/passwords.txt';
        return File(filePath);
      } else {
        throw 'External storage directory not available';
      }
    } else {
      throw 'Storage permission denied';
    }
  }

  /// Explicitly request storage permission
  Future<bool> _requestStoragePermission() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      final result = await Permission.storage.request();
      return result.isGranted;
    }
    return true; // already granted
  }

  /// Overwrite the file with [data]
  Future<void> saveToFile(String data) async {
    final file = await _getFile();
    await file.writeAsString(data, mode: FileMode.write);
  }

  /// Read data from file
  Future<String> readFromFile() async {
    try {
      final file = await _getFile();
      return await file.readAsString();
    } catch (e) {
      return 'error';
    }
  }
}
