import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Them/color_notifier_page.dart';

class ChangePasswordPage extends StatefulWidget {
  final String studentId; // Assume this is passed when navigating to this page
  final ColorNotifier colorNotifier;

  const ChangePasswordPage(
      {super.key, required this.studentId, required this.colorNotifier});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final ColorNotifier colorNotifier = ColorNotifier(Colors.white);

  bool _isLoading = false;
  String _errorMessage = '';

  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  Future<void> _changePassword() async {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _errorMessage = 'New password and confirmation do not match.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Reset any previous errors
    });

    // Send the password change request to the PHP backend
    final response = await http.post(
      Uri.parse('http://10.0.2.2/newBackEnd/change_password.php'),
      // Replace with your backend URL
      body: {
        'student_id': widget.studentId,
        'old_password': oldPassword,
        'new_password': newPassword,
      },
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      // Success: Show a confirmation message or navigate back
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Password Changed'),
          content: const Text('Your password has been successfully updated.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous screen
                // Clear the text fields
                _oldPasswordController.clear();
                _newPasswordController.clear();
                _confirmPasswordController.clear();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Failure: Show an error message
      setState(() {
        _errorMessage = 'Failed to change password. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
        valueListenable: widget.colorNotifier,
        builder: (context, currentColor, child) {
          return Scaffold(
            backgroundColor: currentColor,
            appBar: AppBar(
              title: const Text('Change Password',
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
                            Icons.lock,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Change Your Password',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        _buildPasswordField(
                          'Old Password',
                          _oldPasswordController,
                          _oldPasswordVisible,
                          () {
                            setState(() {
                              _oldPasswordVisible = !_oldPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildPasswordField(
                          'New Password',
                          _newPasswordController,
                          _newPasswordVisible,
                          () {
                            setState(() {
                              _newPasswordVisible = !_newPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildPasswordField(
                          'Confirm New Password',
                          _confirmPasswordController,
                          _confirmPasswordVisible,
                          () {
                            setState(() {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            });
                          },
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
                                  onPressed: _changePassword,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade800,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  child: const Text(
                                    'Change Password',
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

  Widget _buildPasswordField(String label, TextEditingController controller,
      bool isVisible, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.white), // Set border color to white
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: Colors.white), // Set focused border color to white
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class ChangePasswordPage extends StatefulWidget {
//   final String studentId; // Assume this is passed when navigating to this page
//
//   ChangePasswordPage({required this.studentId});
//
//   @override
//   _ChangePasswordPageState createState() => _ChangePasswordPageState();
// }
//
// class _ChangePasswordPageState extends State<ChangePasswordPage> {
//   final _oldPasswordController = TextEditingController();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//
//   bool _isLoading = false;
//   String _errorMessage = '';
//
//   bool _oldPasswordVisible = false;
//   bool _newPasswordVisible = false;
//   bool _confirmPasswordVisible = false;
//
//   Future<void> _changePassword() async {
//     final oldPassword = _oldPasswordController.text.trim();
//     final newPassword = _newPasswordController.text.trim();
//     final confirmPassword = _confirmPasswordController.text.trim();
//
//     if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
//       setState(() {
//         _errorMessage = 'Please fill in all fields.';
//       });
//       return;
//     }
//
//     if (newPassword != confirmPassword) {
//       setState(() {
//         _errorMessage = 'New password and confirmation do not match.';
//       });
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//       _errorMessage = ''; // Reset any previous errors
//     });
//
//     // Send the password change request to the PHP backend
//     final response = await http.post(
//       Uri.parse(
//           'http://10.0.2.2/newBackEnd/change_password.php'), // Replace with your backend URL
//       body: {
//         'student_id': widget.studentId,
//         'old_password': oldPassword,
//         'new_password': newPassword,
//       },
//     );
//
//     setState(() {
//       _isLoading = false;
//     });
//
//     if (response.statusCode == 200) {
//       // Success: Show a confirmation message or navigate back
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Password Changed'),
//           content: Text('Your password has been successfully updated.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 // Navigator.pop(context);
//                 Navigator.pop(context); // Navigate back to the previous screen
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // Failure: Show an error message
//       setState(() {
//         _errorMessage = 'Failed to change password. Please try again.';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Change Password'),
//         backgroundColor: Colors.blue.shade900,
//         centerTitle: true,
//         elevation: 5,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Change Password',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _oldPasswordController,
//               obscureText: !_oldPasswordVisible,
//               decoration: InputDecoration(
//                 labelText: 'Old Password',
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _oldPasswordVisible
//                         ? Icons.visibility
//                         : Icons.visibility_off,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _oldPasswordVisible = !_oldPasswordVisible;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 12),
//             TextField(
//               controller: _newPasswordController,
//               obscureText: !_newPasswordVisible,
//               decoration: InputDecoration(
//                 labelText: 'New Password',
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _newPasswordVisible
//                         ? Icons.visibility
//                         : Icons.visibility_off,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _newPasswordVisible = !_newPasswordVisible;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 12),
//             TextField(
//               controller: _confirmPasswordController,
//               obscureText: !_confirmPasswordVisible,
//               decoration: InputDecoration(
//                 labelText: 'Confirm New Password',
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _confirmPasswordVisible
//                         ? Icons.visibility
//                         : Icons.visibility_off,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _confirmPasswordVisible = !_confirmPasswordVisible;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             if (_errorMessage.isNotEmpty)
//               Text(
//                 _errorMessage,
//                 style: TextStyle(color: Colors.red),
//               ),
//             SizedBox(height: 20),
//             _isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : Center(
//                     child: ElevatedButton(
//                       onPressed: _changePassword,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue.shade800,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15.0),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 10),
//                       ),
//                       child: Text('Change Password'),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
