import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dash/admin_dashboard_screen.dart';

class SuperAdminLoginScreen extends StatefulWidget {
  const SuperAdminLoginScreen({super.key});

  @override
  State<SuperAdminLoginScreen> createState() => _SuperAdminLoginScreenState();
}

class _SuperAdminLoginScreenState extends State<SuperAdminLoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  void _loginSuperAdmin() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    const String correctUsername = 'username';
    const String correctPassword = 'password';

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Username and Password cannot be empty';
      });
      return;
    }

    if (username == correctUsername && password == correctPassword) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isSuperAdminLoggedIn', true); // ✅ Save login state
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
            (Route<dynamic> route) => false, // removes all previous routes
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Super Admin Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginSuperAdmin,
              child: const Text('Login'),
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
