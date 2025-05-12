import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:welfare/screens/home_screen.dart';
import 'admin/super_admin_login_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mobileController = TextEditingController();
  final _pinController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  String _errorMessage = '';

  void _loginUser() async {
    String mobile = _mobileController.text.trim();
    String pin = _pinController.text.trim();

    // Validation
    if (mobile.isEmpty || pin.isEmpty) {
      setState(() {
        _errorMessage = 'মোবাইল নম্বর ও পিন দিতে হবে';
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

    // Try login
    try {
      final query =
          await _firestore
              .collection('users')
              .where('mobile', isEqualTo: mobile)
              .where('pin', isEqualTo: pin)
              .get();

      if (query.docs.isNotEmpty) {
        String userId = query.docs.first.id;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(userId: userId)),
        );
      } else {
        setState(() {
          _errorMessage = 'ভুল মোবাইল নম্বর বা পিন';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'লগইন করতে সমস্যা হয়েছে';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('লগইন করুন'), centerTitle: true),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 12,
                  color: Colors.blue[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Image(
                          image: AssetImage('assets/TBC.jpeg'),
                          height: 80,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'লগইন করতে আপনার মোবাইল নম্বর ও পিন দিন',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),

                        TextField(
                          controller: _mobileController,
                          decoration: const InputDecoration(
                            labelText: 'মোবাইল নম্বর',
                            hintText: '০১XXXXXXXXX', // Hint text added
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Allow digits only
                            LengthLimitingTextInputFormatter(
                              11,
                            ), // Max 11 digits
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _pinController,
                          decoration: const InputDecoration(
                            labelText: 'পিন',
                            hintText: '৬ সংখ্যার পিন লিখুন', // Hint text added
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(
                              6,
                            ), // Limit to 6 digits
                          ],
                        ),
                        const SizedBox(height: 20),

                        ElevatedButton.icon(
                          onPressed: _loginUser,
                          icon: const Icon(Icons.login, color: Colors.white),
                          label: const Text(
                            'লগইন',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        if (_errorMessage.isNotEmpty)
                          Text(
                            _errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),

                        Divider(color: Colors.grey.shade300),
                        const SizedBox(height: 10),

                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.person_add, color: Colors.grey),
                          label: const Text(
                            'নতুন অ্যাকাউন্ট তৈরি করুন',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SuperAdminLoginScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.admin_panel_settings,
                              color: Colors.grey),
                          label: const Text(
                            'অ্যাডমিন লগইন',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Copyright Text outside and below the card
                const SizedBox(height: 20),
                Text(
                  'This application is developed by Astha Tech BD for TBC.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
