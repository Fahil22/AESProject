import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aesproject/controllers/database_helper.dart';
import 'package:aesproject/main.dart';
import 'package:aesproject/controllers/password_controller.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatelessWidget {
  final PasswordController _controller = Get.put(PasswordController());
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 0, 57, 95),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PassShield',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      prefs!.remove('userId');
                      Get.offAllNamed('/login');
                    },
                    child: Icon(
                      Icons.logout,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Password Stats
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: GlassmorphicContainer(
                width: double.infinity,
                height: 120,
                borderRadius: 15,
                blur: 10,
                alignment: Alignment.bottomCenter,
                border: 2,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.5),
                    Colors.white.withOpacity(0.2),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${_controller.passwords.length}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Total Passwords',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
            ),

            // Password List
            Expanded(
              child: Obx(() {
                if (_controller.passwords.isEmpty) {
                  return Center(
                    child: Text(
                      'No passwords saved',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 18,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _controller.passwords.length,
                  itemBuilder: (context, index) {
                    final passwordItem = _controller.passwords[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            passwordItem.title,
                            style:GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.white70),
                                onPressed: () {
                                  Get.toNamed('/edit_password',
                                      arguments: passwordItem);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _controller.deletePassword(passwordItem.id!);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Get.toNamed('/view_password',
                                arguments: passwordItem);
                            dbHelper.showAllTablesAndRecords();
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.2),
        onPressed: () => Get.toNamed('/add_password'),
        child: Icon(Icons.add, color: Colors.white70),
      ),
    );
  }
}
