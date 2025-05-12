import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  Future<void> _launchPhone(String number, BuildContext context) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone dialer')),
      );
    }
  }

  Future<void> _launchFacebook(BuildContext context) async {
    final Uri fbUri = Uri.parse(
      'https://www.facebook.com/profile.php?id=61574591373718',
    );
    if (await canLaunchUrl(fbUri)) {
      await launchUrl(fbUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Facebook link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('আমাদের সম্পর্কে'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'আমাদের সম্পর্কে',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'আমরা একটি সেবামূলক প্রতিষ্ঠান যা মানুষের সাহায্যের জন্য কাজ করে। '
                  'আমাদের লক্ষ্য হলো সমাজের সুবিধাবঞ্চিত মানুষদের পাশে দাঁড়ানো এবং তাদের জীবনমান উন্নত করা।',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'যোগাযোগ করুন:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.green, size: 24),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _launchPhone('+8801793864849', context),
                  child: const Text(
                    '+8801793-864849',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.facebook, color: Colors.blue, size: 24),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _launchFacebook(context),
                  child: const Text(
                    'আমাদের ফেসবুক প্রোফাইল',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
