import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin/dash/admin_dashboard_screen.dart';
import 'screens/home_screen.dart';
import 'login_screen.dart';
import 'colors.dart'; // Your custom color constants
import 'firebase_options.dart'; // Firebase initialization config

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TBC Help Service',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 4,
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: secondaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: text),
          bodyMedium: TextStyle(color: text),
          bodySmall: TextStyle(color: text),
        ),
        iconTheme: IconThemeData(color: accentColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return const LoginScreen(); // Fallback
          }
        },
      ),
    );
  }

  // Logic to determine the initial screen based on stored preferences
  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if super admin is logged in
    final isSuperAdmin = prefs.getBool('isSuperAdminLoggedIn') ?? false;
    if (isSuperAdmin) {
      return const AdminDashboardScreen();
    }

    // Check if a user is logged in
    final userId = prefs.getString('userId');
    if (userId != null) {
      return HomeScreen(userId: userId);
    }

    // Default to login screen
    return const LoginScreen();
  }
}
