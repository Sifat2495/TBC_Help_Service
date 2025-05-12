import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import '../admin/dash/admin_banner.dart';
import '../widgets/home_section_button.dart';
import '../widgets/home_drawer.dart';
import 'application_form.dart';
import 'my_applications.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(userId: userId),
      appBar: AppBar(title: const Text('TBC Help Service'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const NetworkBannerSlider(),
                  const SizedBox(height: 20),
                  const Text(
                    'স্বাগতম!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.pink.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'মানবতার ডাকে সাড়া দিন,\n'
                                  'আপনার সহায়তায় হাসবে একটি মুখ।\n'
                                  'ছোট্ট একটি দান হতে পারে কারো বেঁচে থাকার আশার আলো।\n'
                                  'ভালোবাসা ভাগ করলে বাড়ে, কষ্ট ভাগ করলে কমে।\n'
                                  'চলুন, আজই হাত বাড়াই—মানুষের পাশে দাঁড়াই।',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/nagad.png',
                                  width: 32,
                                  height: 32,
                                ),
                                const SizedBox(width: 10),
                                Image.asset(
                                  'assets/rocket.png',
                                  width: 32,
                                  height: 32,
                                ),
                                const SizedBox(width: 10),
                                Image.asset(
                                  'assets/bkash.png',
                                  width: 32,
                                  height: 32,
                                ),
                                const SizedBox(width: 10),                                const Text(
                                  '01793864849',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.copy, size: 20, color: Colors.green[800],),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.blue[100],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  tooltip: 'Copy number',
                                  onPressed: () {
                                    Clipboard.setData(const ClipboardData(text: '01793864849'));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Phone number copied to clipboard!'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'তারুণ্যের বৃহত্তর চৌদ্দগ্রাম',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  HomeSectionButton(
                    text: 'সাহায্যের জন্য আবেদন করুন',
                    icon: Icons.edit,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ApplicationForm(userId: userId),
                        ),
                      );
                    },
                  ),
                  HomeSectionButton(
                    text: 'আমার আবেদনসমূহ',
                    icon: Icons.list_alt,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MyApplications(userId: userId),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'This application is developed by MD. Sakiul Hasan Sifat.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
