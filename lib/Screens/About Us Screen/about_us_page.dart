import 'package:flutter/material.dart';
import '../../Them/color_notifier_page.dart';

class AboutUsScreen extends StatefulWidget {
  final ColorNotifier colorNotifier;

  const AboutUsScreen({super.key, required this.colorNotifier});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final ColorNotifier colorNotifier = ColorNotifier(Colors.white);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
        valueListenable: widget.colorNotifier,
        builder: (context, currentColor, child) {
          return Scaffold(
            backgroundColor: currentColor,
            appBar: AppBar(
              title: Text('About Us'),
              centerTitle: true,
              backgroundColor: Colors.blue.shade800,
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
                  Center(
                    child: Image.asset(
                      'assets/images/Logo.png',
                      height: 150,
                      width: 650,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Text(
                      '\t\t\tQuality Assurance\n '
                      '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t&\n'
                      '\t\t\t\t\t\t\t\t\t\t\t'
                      '\t\t\t\t\t\t\t\t\t\t\t\t Lecture Follow-Up',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Our Mission:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Our app is dedicated to ensuring the '
                    'quality of education by streamlining the process of lecture '
                    'follow-up, feedback collection, and evaluation. We aim to bridge '
                    'the gap between students and lecturers, providing a platform for '
                    'ansparent communication and continuous improvement.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Features:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '- Lecture schedules and details tailored to students\' academic profiles.\n '
                    '- Feedback submission and evaluation for lecture quality assurance. '
                    '\n- Notifications for reminders and updates. '
                    '\n- Easy-to-use interface for seamless interaction.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
