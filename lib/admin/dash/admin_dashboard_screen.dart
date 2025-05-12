import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login_screen.dart';
import '../img/banner_mgmt.dart';
import 'admin_banner.dart';
import 'admin_dashboard_widgets.dart'; // Modular widget

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final applicationsQuery = FirebaseFirestore.instance
        .collection('applications')
        .orderBy('submitted_at', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('অ্যাডমিন ড্যাশবোর্ড'),
        centerTitle: true,
        backgroundColor: const Color(0xFF11354e),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red.shade400),
            tooltip: 'লগ আউট',
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('লগ আউট নিশ্চিত করুন'),
                  content: const Text('আপনি কি লগ আউট করতে চান?'),
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
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('isSuperAdminLoggedIn');

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                );
              }
            },
          ),
        ],
      ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BannerManagementPage(),
                  ),
                );
              },
              child: const Text('ব্যানার পরিচালনা করুন'),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: NetworkBannerSlider(), // 👈 Add banner at top
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: applicationsQuery.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'কোনো ব্যবহারকারী পাওয়া যায়নি',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  final applications = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: applications.length,
                    itemBuilder: (context, index) {
                      final application = applications[index];
                      return AdminUserCard(
                        applicationId: application.id,
                        name: application['name'],
                        mobile: application['mobile'],
                        status: application['status'],
                        description: application['description'],
                        type: application['help_type'],
                        address: application['address'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
    );
  }
}
