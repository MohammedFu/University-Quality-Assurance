import 'package:flutter/material.dart';
import 'package:lmw/Screens/Help%20&%20Support%20Screen/help_and_support_page.dart';

import '../../Them/change_color_page.dart';
import '../../Them/color_notifier_page.dart';
import '../Terms of Service Screen/terms_of_service_page.dart';

class SettingsPage extends StatefulWidget {
  final bool isGridView;
  final VoidCallback toggleLayout;
  final ColorNotifier colorNotifier;

  SettingsPage(
      {super.key,
      required this.isGridView,
      required this.toggleLayout,
      required this.colorNotifier});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ColorNotifier colorNotifier = ColorNotifier(Colors.white);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
        valueListenable: widget.colorNotifier,
        builder: (context, currentColor, child) {
          return Scaffold(
            backgroundColor: currentColor,
            appBar: AppBar(
              title: const Text('App Settings',
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferences',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 3,
                    color: Colors.blue.shade900,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      leading: Icon(
                        widget.isGridView ? Icons.view_list : Icons.grid_view,
                        color: Colors.white,
                        size: 30,
                      ),
                      title: Text(
                        'Layout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Switch between Grid and List view for the main layout.',
                        style: TextStyle(fontSize: 14, color: Colors.white54),
                      ),
                      onTap: widget.toggleLayout,
                    ),
                  ),
                  SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 3,
                    color: Colors.blue.shade900,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      leading: Icon(
                        Icons.format_color_fill,
                        color: Colors.white,
                        size: 30,
                      ),
                      title: Text(
                        'Theme',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Switch between colors for the main theme.',
                        style: TextStyle(fontSize: 14, color: Colors.white54),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ColorChangePage(
                                    colorNotifier: widget.colorNotifier,
                                  )),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Legal',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.blue.shade900,
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      leading: Icon(
                        Icons.description,
                        color: Colors.white,
                        size: 30,
                      ),
                      title: Text(
                        'Terms of Service',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'View the terms and conditions.',
                        style: TextStyle(fontSize: 14, color: Colors.white54),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermsOfServicePage(
                              colorNotifier: widget.colorNotifier,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.blue.shade900,
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      leading: Icon(
                        Icons.live_help,
                        color: Colors.white,
                        size: 30,
                      ),
                      title: Text(
                        'Help & Support',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HelpSupportPage(
                              colorNotifier: widget.colorNotifier,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
