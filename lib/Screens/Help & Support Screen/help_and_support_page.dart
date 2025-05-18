import 'package:flutter/material.dart';

import '../../Them/color_notifier_page.dart';

class HelpSupportPage extends StatefulWidget {
  final ColorNotifier colorNotifier;
  const HelpSupportPage({super.key, required this.colorNotifier});

  @override
  _HelpSupportPageState createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  final ColorNotifier colorNotifier = ColorNotifier(Colors.white);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
        valueListenable: widget.colorNotifier,
        builder: (context, currentColor, child) {
          return Scaffold(
            backgroundColor: currentColor,
            appBar: AppBar(
              title: const Text('Help & Support',
                  style: TextStyle(fontSize: 28, color: Colors.white)),
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
              child: SingleChildScrollView(
                child: Card(
                  margin: const EdgeInsets.only(top: 40),
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade800, Colors.blue.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Icon(
                            Icons.help_outline,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'How can we help you?',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'If you have any questions or issues, feel free to reach out to our support team. We\'re here to assist you!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Frequently Asked Questions (FAQ)',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        // FAQ content
                        _buildFAQTile(
                            'How do I reset my password?',
                            'To reset your password, click on the "Forgot Password" '
                                'link in the login screen and follow the '
                                'instructions.'),
                        _buildFAQTile(
                            'How can I contact support?',
                            'You can contact our support team by using the form below or sending us an email at mohammedalsanhani2@gmail.com Or '
                                '\ncall this Phone Number for free: \n+967 770-180-062'),
                        const SizedBox(height: 20),
                        const Text(
                          'Leave us a message',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _feedbackController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Write your issue or message here...',
                            hintStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        if (_errorMessage.isNotEmpty)
                          Text(
                            _errorMessage,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                          ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Center(
                                child: ElevatedButton(
                                  onPressed: _sendMessage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade800,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  child: const Text(
                                    'Send Message',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildFAQTile(String question, String answer) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      title: Text(
        question,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        answer,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  Future<void> _sendMessage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Reset any previous errors
    });

    final feedback = _feedbackController.text.trim();

    if (feedback.isEmpty) {
      setState(() {
        _errorMessage = 'Please write a message before submitting.';
        _isLoading = false;
      });
      return;
    }

    // Simulate sending feedback to the server
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _feedbackController.clear();
      _errorMessage = '';
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Message Sent'),
        content: const Text('Your feedback has been sent successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
