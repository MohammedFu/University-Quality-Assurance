import 'package:flutter/material.dart';

import '../../Them/color_notifier_page.dart';

class TermsOfServicePage extends StatefulWidget {
  final ColorNotifier colorNotifier;

  const TermsOfServicePage({super.key, required this.colorNotifier});

  @override
  State<TermsOfServicePage> createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
        valueListenable: widget.colorNotifier,
        builder: (context, currentColor, child) {
          return Scaffold(
            backgroundColor: currentColor,
            appBar: AppBar(
              title: const Text('Terms of Service',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              backgroundColor: Colors.blue.shade900,
              centerTitle: true,
              elevation: 5,
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(25)),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to our application! Below are the terms and conditions governing the use of this app.',
                            style: TextStyle(
                                fontSize: 16, height: 1.5, color: Colors.green),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '1. Usage Guidelines',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Ensure to use the app responsibly and in accordance with applicable laws.',
                            style: TextStyle(
                                fontSize: 16, height: 1.5, color: Colors.green),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '2. Privacy Policy',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Your personal data will be handled with the utmost care as outlined in our privacy policy.',
                            style: TextStyle(
                                fontSize: 16, height: 1.5, color: Colors.green),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '3. Limitations',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'The app is provided as is, and we do not guarantee uninterrupted service.',
                            style: TextStyle(
                                fontSize: 16, height: 1.5, color: Colors.green),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '4. Amendments',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'We reserve the right to update the terms of service. Ensure you check this page periodically.',
                            style: TextStyle(
                                fontSize: 16, height: 1.5, color: Colors.green),
                          ),
                          SizedBox(height: 24),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Add functionality like accepting terms if needed
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
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
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
        });
  }
}
