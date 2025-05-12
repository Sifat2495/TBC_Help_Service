import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Add this import for TextInputFormatter
import 'screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  final _firestore = FirebaseFirestore.instance;

  String _errorMessage = '';
  bool _isLoading = false;
  bool _obscurePin = true;
  bool _obscureConfirmPin = true;

  void _registerUser() async {
    String name = _nameController.text.trim();
    String mobile = _mobileController.text.trim();
    String pin = _pinController.text.trim();
    String confirmPin = _confirmPinController.text.trim();

    // Validation
    if (name.isEmpty || mobile.isEmpty || pin.isEmpty || confirmPin.isEmpty) {
      setState(() {
        _errorMessage = 'সব ফিল্ড পূরণ করুন';
      });
      return;
    }

    if (!RegExp(r'^01\d{9}$').hasMatch(mobile)) {
      setState(() {
        _errorMessage = 'সঠিক ১১ সংখ্যার মোবাইল নম্বর দিন (০১ দিয়ে শুরু)';
      });
      return;
    }

    if (pin.length != 6) {
      setState(() {
        _errorMessage = 'পিন ৬ সংখ্যার হতে হবে';
      });
      return;
    }

    if (pin != confirmPin) {
      setState(() {
        _errorMessage = 'পিন এবং কনফার্ম পিন মিলছে না';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Check if mobile already exists
      final existing = await _firestore
          .collection('users')
          .where('mobile', isEqualTo: mobile)
          .get();

      if (existing.docs.isNotEmpty) {
        setState(() {
          _errorMessage = 'এই মোবাইল নম্বর আগে ব্যবহার করা হয়েছে';
          _isLoading = false;
        });
        return;
      }

      final newUser = await _firestore.collection('users').add({
        'name': name,
        'mobile': mobile,
        'pin': pin,
        'created_at': FieldValue.serverTimestamp(),
        'login_type': 'mobile',
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(userId: newUser.id)),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'রেজিস্ট্রেশন ব্যর্থ হয়েছে';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('নতুন রেজিস্ট্রেশন')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'আপনার নাম',
                hintText: 'পূর্ণ নাম লিখুন',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _mobileController,
              decoration: const InputDecoration(
                labelText: 'মোবাইল নম্বর',
                hintText: '০১XXXXXXXXX',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ], // Restrict mobile to 11 digits
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _pinController,
              obscureText: _obscurePin,
              decoration: InputDecoration(
                labelText: 'পিন',
                hintText: '৬ সংখ্যার পিন',
                suffixIcon: IconButton(
                  icon: Icon(_obscurePin ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscurePin = !_obscurePin;
                    });
                  },
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ], // Restrict pin to 6 digits
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _confirmPinController,
              obscureText: _obscureConfirmPin,
              decoration: InputDecoration(
                labelText: 'পিন কনফার্ম করুন',
                hintText: 'আবার পিন লিখুন',
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPin ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPin = !_obscureConfirmPin;
                    });
                  },
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ], // Restrict confirm pin to 6 digits
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _registerUser,
              child: const Text('রেজিস্টার করুন'),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
