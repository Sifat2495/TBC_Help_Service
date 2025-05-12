import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApplications extends StatelessWidget {
  final String userId;

  const MyApplications({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final appQuery = FirebaseFirestore.instance
        .collection('applications')
        .where('user_id', isEqualTo: userId)
        .orderBy('submitted_at', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('আমার আবেদনসমূহ'),
        backgroundColor: const Color(0xFF11354e),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: appQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'আপনার কোনো আবেদন পাওয়া যায়নি',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final applications = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final app = applications[index];
              final helpType = app['help_type'];
              final address = app['address'];
              final status = app['status'];
              final submittedAt = app['submitted_at']?.toDate();
              final description = app['description'];

              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        gradient: LinearGradient(
                          colors: [Color(0xFF13783e), Color(0xFF11354e)],
                        ),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Text(
                        helpType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (description.isNotEmpty)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.description, color: Colors.black54),
                                const SizedBox(width: 8),
                                Expanded(child: Text('বিবরণ: $description')),
                              ],
                            ),
                          const SizedBox(height: 8),
                          if (address.isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.black54),
                                const SizedBox(width: 8),
                                Expanded(child: Text('ঠিকানা: $address')),
                              ],
                            ),
                          const SizedBox(height: 8),
                          if (submittedAt != null)
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
                                const SizedBox(width: 8),
                                Text(
                                  'তারিখ: ${submittedAt.day}/${submittedAt.month}/${submittedAt.year}',
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.info, color: Colors.black54),
                              const SizedBox(width: 8),
                              const Text('স্ট্যাটাস: '),
                              _buildStatusChip(status),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    String label = '';
    Color color;

    switch (status) {
      case 'pending':
        label = 'বিচারাধীন';
        color = Colors.orange;
        break;
      case 'approved':
        label = 'অনুমোদিত';
        color = Colors.green;
        break;
      case 'rejected':
        label = 'প্রত্যাখ্যাত';
        color = Colors.red;
        break;
      default:
        label = 'অজানা';
        color = Colors.grey;
    }

    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
      shape: const StadiumBorder(),
    );
  }
}
