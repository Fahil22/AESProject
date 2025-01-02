import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/password_controller.dart';

class HomeView extends StatelessWidget {
  final PasswordController _controller = Get.put(PasswordController());

  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load from GetStorage, then mirror to file
    _controller.loadPasswords();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Manager'),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        if (_controller.passwords.isEmpty) {
          return const Center(
            child: Text(
              'No passwords found.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: _controller.passwords.length,
          itemBuilder: (context, index) {
            final passwordItem = _controller.passwords[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(
                  passwordItem.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () => Get.toNamed('/view_password', arguments: passwordItem),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    _controller.deletePassword(passwordItem.id);
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => Get.toNamed('/add_password'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}