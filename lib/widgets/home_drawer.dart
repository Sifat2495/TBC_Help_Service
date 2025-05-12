import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_screen.dart';
import 'about.dart';

class HomeDrawer extends StatelessWidget {
  final String userId;

  const HomeDrawer({super.key, required this.userId});

  Future<Map<String, String>> _getUserData() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      final data = doc.data()!;
      final name = data['name'] ?? 'নাম পাওয়া যায়নি';
      final mobile = data['mobile'] ?? 'মোবাইল নম্বর নেই';
      return {'name': name, 'mobile': mobile};
    }
    return {'name': 'অজানা ব্যবহারকারী', 'mobile': ''};
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<Map<String, String>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        final name = snapshot.data?['name'] ?? 'লোড হচ্ছে...';
        final mobile = snapshot.data?['mobile'] ?? '';

        return Drawer(
          width: screenWidth * 0.5,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF11354e),
                ),
                accountName: Text(
                  name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(mobile),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage('assets/TBC.jpeg'),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.black),
                      title: const Text('হোম', style: TextStyle(color: Colors.black)),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.info, color: Colors.black),
                      title: const Text('আমাদের সম্পর্কে', style: TextStyle(color: Colors.black)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutUsPage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.black),
                      title: const Text('লগ আউট', style: TextStyle(color: Colors.black)),
                      onTap: () async {
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('লগ আউট নিশ্চিত করুন'),
                            content: const Text('আপনি কি সত্যিই লগ আউট করতে চান?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('না'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('হ্যাঁ'),
                              ),
                            ],
                          ),
                        );

                        if (shouldLogout == true) {
                          try {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.remove('userId'); // Clear saved user ID

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  (route) => false,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('লগ আউটে সমস্যা হয়েছে')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
