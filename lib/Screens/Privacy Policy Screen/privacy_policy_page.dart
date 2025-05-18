import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy Statements:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                physics: PageScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your privacy is critically important to us. Below we outline our policies regarding the collection, use, and disclosure of personal information.',
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black87),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '1. Information We Collect',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'We may collect personal information such as your name, email address, and usage data to provide a better experience.',
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black87),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '2. How We Use Your Information',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Your data is used to improve app functionality, provide support, and enhance user experience.',
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black87),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '3. Sharing Your Information',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'We do not share your personal information with third parties except as required by law or to protect our rights.',
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black87),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '4. Data Security',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'We implement robust security measures to protect your data from unauthorized access.',
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black87),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '5. Changes to This Policy',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'We may update this privacy policy from time to time. Please review this page periodically for changes.',
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black87),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '6. Cookies and Tracking Technologies',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'We use cookies and similar tracking technologies to enhance the user experience and analyze usage patterns.',
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black87),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '7. Third-Party Links',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Our app may contain links to third-party websites. We are not responsible for their privacy practices.',
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black87),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '8. User Control and Access',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'You have the right to access, modify, or delete your personal information at any time.',
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black87),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '9. International Transfers',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Your data may be transferred to and maintained on servers located outside of your country.',
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black87),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '10. Contact Us',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'If you have any questions or concerns regarding this privacy policy, please contact us at support@ourapp.com.',
                      style: TextStyle(
                          fontSize: 16, height: 1.5, color: Colors.black87),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: const Text(
                          'Accept and Continue',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
