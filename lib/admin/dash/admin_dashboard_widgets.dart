import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminUserCard extends StatefulWidget {
  final String applicationId;
  final String description;
  final String name;
  final String mobile;
  final String status;
  final String type;
  final String address;

  const AdminUserCard({
    super.key,
    required this.applicationId,
    required this.description,
    required this.name,
    required this.mobile,
    required this.status,
    required this.type,
    required this.address,
  });

  @override
  State<AdminUserCard> createState() => _AdminUserCardState();
}

class _AdminUserCardState extends State<AdminUserCard> {
  late String _selectedStatus;

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.status;
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() {
      _selectedStatus = newStatus;
    });

    try {
      await FirebaseFirestore.instance
          .collection('applications')
          .doc(widget.applicationId)
          .update({'status': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('স্ট্যাটাস আপডেট হয়েছে')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('স্ট্যাটাস আপডেট করতে ব্যর্থ হয়েছে')),
      );
    }
  }

  void _confirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('আবেদন মুছে ফেলবেন?'),
        content: const Text('আপনি কি নিশ্চিতভাবে এই আবেদনটি মুছে ফেলতে চান?'),
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

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('applications')
            .doc(widget.applicationId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('আবেদন মুছে ফেলা হয়েছে')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('আবেদন মুছে ফেলতে ব্যর্থ হয়েছে')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              widget.name,
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
                Row(
                  children: [
                    const Icon(Icons.merge_type, color: Colors.black54),
                    const SizedBox(width: 8),
                    Expanded(child: Text('সাহায্যের ধরন: ${widget.type}',style: TextStyle(fontWeight: FontWeight.bold),)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.description, color: Colors.black54),
                    const SizedBox(width: 8),
                    Expanded(child: Text('বিবরণ: ${widget.description}')),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.black54),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final Uri phoneUri = Uri(scheme: 'tel', path: widget.mobile);
                          if (await canLaunchUrl(phoneUri)) {
                            await launchUrl(phoneUri);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Could not launch phone dialer')),
                            );
                          }
                        },
                        child: Text(
                          'মোবাইল নম্বর: ${widget.mobile}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.black54),
                    const SizedBox(width: 8),
                    Expanded(child: Text('ঠিকানা: ${widget.address}')),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.info, color: Colors.black54),
                    const SizedBox(width: 8),
                    const Text('স্ট্যাটাস: '),
                    DropdownButton<String>(
                      value: _selectedStatus,
                      isDense: true,
                      borderRadius: BorderRadius.circular(8),
                      dropdownColor: Colors.white,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(_selectedStatus),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'pending',
                          child: Text(
                            'বিচারাধীন',
                            style: TextStyle(color: _getStatusColor('pending')),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'approved',
                          child: Text(
                            'অনুমোদিত',
                            style: TextStyle(color: _getStatusColor('approved')),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'rejected',
                          child: Text(
                            'প্রত্যাখ্যাত',
                            style: TextStyle(color: _getStatusColor('rejected')),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _updateStatus(value);
                        }
                      },
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _confirmDelete,
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
