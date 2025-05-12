import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationForm extends StatefulWidget {
  final String userId;

  const ApplicationForm({super.key, required this.userId});

  @override
  State<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  String? _selectedHelpType;
  String? _userName;
  String? _userMobile;
  bool _isLoading = true;
  String _message = '';

  final List<String> _helpTypes = [
    'ত্রাণ',
    'আর্থিক সাহায্য',
    'রক্ত',
    'চিকিৎসা',
    'শিক্ষা',
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final doc = await _firestore.collection('users').doc(widget.userId).get();
    if (doc.exists) {
      setState(() {
        _userName = doc['name'];
        _userMobile = doc['mobile'];
        _isLoading = false;
      });
    }
  }

  void _submitApplication() async {
    if (_selectedHelpType == null ||
        _addressController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      setState(() {
        _message = 'সব তথ্য দিন';
      });
      return;
    }

    try {
      await _firestore.collection('applications').add({
        'user_id': widget.userId,
        'name': _userName,
        'mobile': _userMobile,
        'address': _addressController.text.trim(),
        'help_type': _selectedHelpType,
        'description': _descriptionController.text.trim(),
        'submitted_at': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      setState(() {
        _message = 'আবেদন সফলভাবে জমা হয়েছে';
        _addressController.clear();
        _descriptionController.clear();
        _selectedHelpType = null;
      });
    } catch (e) {
      setState(() {
        _message = 'আবেদন জমা দিতে সমস্যা হয়েছে';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('আবেদন ফর্ম')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('নাম: $_userName',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            Text('মোবাইল: $_userMobile',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'ঠিকানা'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedHelpType,
              items: _helpTypes
                  .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedHelpType = value;
                });
              },
              decoration: const InputDecoration(labelText: 'সাহায্যের ধরন'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'বিস্তারিত বর্ণনা'),
              maxLines: 10,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitApplication,
              child: const Text('আবেদন করুন'),
            ),
            const SizedBox(height: 10),
            Text(
              _message,
              style: TextStyle(
                color: _message.contains('সফল') ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
