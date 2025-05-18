// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../API/api_class.dart';
// import '../../Them/color_notifier_page.dart';
// import '../Login Screen/login_page.dart';
// import '../Dashboard Screen/Dashboard.dart';
// import '../About Us Screen/about_us_page.dart';
// import '../Settings Screen/settings_page.dart';
// import '../Privacy Policy Screen/privacy_policy_page.dart';
// import '../Change Password Screen/change_password_page.dart';
// import '../Notification Screen/notification_page.dart';
// import '../Lectures Screens/Fetch Lecture Screen/fetch_lectures_page.dart';
// import '../Profile Screen/fetch_profile_page.dart';
//
// class MainPage extends StatefulWidget {
//   final String studentId;
//   final ColorNotifier colorNotifier;
//
//   const MainPage(
//       {super.key, required this.studentId, required this.colorNotifier});
//
//   @override
//   _MainPageState createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   late String firstName;
//   late String lastName;
//   String? email;
//   bool isLoading = true;
//   bool isGridView = true;
//   final ColorNotifier colorNotifier = ColorNotifier(Colors.white);
//
//   @override
//   void initState() {
//     super.initState();
//     firstName = '';
//     lastName = '';
//     _fetchStudentData();
//   }
//
//   Future<void> _fetchStudentData() async {
//     try {
//       final response = await http.post(
//         Uri.parse(ApiClass.getEndpoint('newBackEnd/get_student_details.php')),
//         body: {'student_id': widget.studentId},
//       );
//
//       final responseData = json.decode(response.body);
//       if (responseData['status'] == 'success') {
//         setState(() {
//           firstName = responseData['data']['first_name'] ?? '';
//           lastName = responseData['data']['last_name'] ?? '';
//           email = responseData['data']['email'];
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> logout(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LoginPage(colorNotifier: colorNotifier),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<Color>(
//       valueListenable: widget.colorNotifier,
//       builder: (context, currentColor, child) {
//         return Scaffold(
//           backgroundColor: currentColor,
//           drawer: _buildDrawer(currentColor),
//           appBar: AppBar(
//             title: Row(
//               children: [
//                 SizedBox(width: 30.w),
//                 Text(
//                   'University Quality\n\t\t\t\t\t\t\tAssurance',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20.sp, // Responsive text scaling
//                     fontWeight: FontWeight.bold,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//               ],
//             ),
//             centerTitle: true,
//             backgroundColor: Colors.blue.shade900,
//           ),
//           body: isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Column(
//                   children: [
//                     _buildWelcomeBanner(),
//                     _buildBody(),
//                   ],
//                 ),
//         );
//       },
//     );
//   }
//
//   Widget _buildDrawer(Color currentColor) {
//     return Drawer(
//       backgroundColor: currentColor,
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           UserAccountsDrawerHeader(
//             accountName: Text(
//               isLoading ? 'Loading...' : '$firstName $lastName',
//               style: TextStyle(color: Colors.white, fontSize: 18.sp),
//             ),
//             accountEmail: Text(
//               isLoading ? 'Fetching email...' : (email ?? ''),
//               style: TextStyle(color: Colors.white70, fontSize: 14.sp),
//             ),
//             currentAccountPicture: CircleAvatar(
//               backgroundColor: Colors.white,
//               child: isLoading
//                   ? CircularProgressIndicator()
//                   : Text(
//                       '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}',
//                       style: TextStyle(
//                           fontSize: 28.sp, color: Colors.blue.shade900),
//                     ),
//             ),
//             decoration: BoxDecoration(color: Colors.blue.shade900),
//           ),
//           ..._buildDrawerOptions(),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _buildDrawerOptions() {
//     return [
//       _buildDrawerOption(Icons.settings, 'Settings', () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => SettingsPage(
//                       colorNotifier: colorNotifier,
//                       isGridView: isGridView,
//                       toggleLayout: () {
//                         setState(() {
//                           isGridView = !isGridView;
//                         });
//                       },
//                     )));
//       }),
//       _buildDrawerOption(Icons.logout, 'Logout', () => logout(context),
//           iconColor: Colors.red, textColor: Colors.red),
//     ];
//   }
//
//   Widget _buildDrawerOption(IconData icon, String title, VoidCallback onTap,
//       {Color? iconColor, Color? textColor}) {
//     return ListTile(
//       leading: Icon(icon, color: iconColor ?? Colors.black),
//       title: Text(title,
//           style: TextStyle(color: textColor ?? Colors.black, fontSize: 14.sp)),
//       onTap: onTap,
//     );
//   }
//
//   Widget _buildWelcomeBanner() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade900,
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Welcome Again,',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold)),
//           SizedBox(height: 8.h),
//           Text('$firstName $lastName',
//               style: TextStyle(color: Colors.white, fontSize: 16.sp)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBody() {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.all(20.w),
//         child: isGridView ? _buildGridView() : _buildListView(),
//       ),
//     );
//   }
//
//   Widget _buildGridView() {
//     return GridView.count(
//       crossAxisCount: 2,
//       crossAxisSpacing: 15.w,
//       mainAxisSpacing: 15.h,
//       children: _buildButtons(context).map((button) {
//         return ElevatedButton.icon(
//           icon: Icon(button.icon, size: 24.w, color: Colors.white),
//           label: Text(button.label,
//               style: TextStyle(fontSize: 14.sp, color: Colors.white)),
//           style: ElevatedButton.styleFrom(
//             padding: EdgeInsets.all(16.w),
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.r)),
//             backgroundColor: Colors.blue.shade900,
//           ),
//           onPressed: button.onPressed,
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildListView() {
//     return ListView.separated(
//       itemBuilder: (context, index) {
//         final button = _buildButtons(context)[index];
//         return ListTile(
//           leading: Icon(button.icon, size: 24.w, color: Colors.blue.shade900),
//           title: Text(button.label,
//               style: TextStyle(fontSize: 14.sp, color: Colors.black)),
//           onTap: button.onPressed,
//         );
//       },
//       separatorBuilder: (context, index) => SizedBox(height: 15.h),
//       itemCount: _buildButtons(context).length,
//     );
//   }
//
//   List<_ButtonData> _buildButtons(BuildContext context) {
//     return [
//       _ButtonData(
//         icon: Icons.book,
//         label: 'View Lectures',
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => DailyLecturesPage(
//                       studentId: widget.studentId,
//                       colorNotifier: colorNotifier,
//                     )),
//           );
//         },
//       ),
//       // Add more buttons here
//     ];
//   }
// }
//
// class _ButtonData {
//   final IconData icon;
//   final String label;
//   final VoidCallback onPressed;
//
//   _ButtonData(
//       {required this.icon, required this.label, required this.onPressed});
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lmw/Screens/Attendance%20Screen/submit_attendance_page.dart';
import 'package:lmw/Screens/Change%20Password%20Screen/change_password_page.dart';
import 'package:lmw/Screens/Privacy%20Policy%20Screen/privacy_policy_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../API/api_class.dart';
import '../../Them/color_notifier_page.dart';
import '../About Us Screen/about_us_page.dart';
import '../Course Screen/course_page.dart';
import '../Dashboard Screen/Dashboard.dart';
import '../Lectures%20Screens/Fetch%20Lecture%20Screen/fetch_lectures_page.dart';
import '../Login Screen/login_page.dart';
import '../Notification Screen/notification_page.dart';
import '../Profile%20Screen/fetch_profile_page.dart';
import '../Settings Screen/settings_page.dart';
import '../Submit Lectures-Feedback Screen/submit_lectures_feedback_page.dart';

class MainPage extends StatefulWidget {
  final String studentId;
  final ColorNotifier colorNotifier;

  const MainPage(
      {super.key, required this.studentId, required this.colorNotifier});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String firstName;
  late String lastName;
  String? email;
  bool isLoading = true;
  bool isGridView = true; // Toggle between GridView and ListView
  final ColorNotifier colorNotifier = ColorNotifier(Colors.white);

  @override
  void initState() {
    super.initState();
    firstName = ''; // Default value
    lastName = ''; // Default value
    _fetchStudentData();
  }

  Future<void> _fetchStudentData() async {
    try {
      final response = await http.post(
        Uri.parse(ApiClass.getEndpoint('newBackEnd/get_student_details.php')),
        body: {'student_id': widget.studentId},
      );

      final responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        setState(() {
          firstName = responseData['data']['first_name'] ?? '';
          lastName = responseData['data']['last_name'] ?? '';
          email = responseData['data']['email'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(colorNotifier: colorNotifier),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
        valueListenable: widget.colorNotifier,
        builder: (context, currentColor, child) {
          return Scaffold(
            backgroundColor: currentColor,
            drawer: Drawer(
              backgroundColor: currentColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      isLoading ? 'Loading...' : '$firstName $lastName',
                      style: TextStyle(color: Colors.white),
                    ),
                    accountEmail: Text(
                      isLoading ? 'Fetching email...' : (email ?? ''),
                      style: TextStyle(color: Colors.white70),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}',
                              style: TextStyle(
                                fontSize: 40.0,
                                color: Colors.blue.shade900,
                              ),
                            ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsPage(
                            isGridView: isGridView,
                            toggleLayout: () {
                              setState(() {
                                isGridView = !isGridView;
                              });
                            },
                            colorNotifier: colorNotifier,
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.change_circle),
                    title: Text('Change Password'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePasswordPage(
                            studentId: widget.studentId,
                            colorNotifier: colorNotifier,
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.dashboard),
                    title: Text('Dashboard'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardPage(
                            studentId: widget.studentId,
                            colorNotifier: colorNotifier,
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.privacy_tip),
                    title: Text('Privacy Policy'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivacyPolicyPage(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About Us'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AboutUsScreen(colorNotifier: colorNotifier),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  SizedBox(height: 265,),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text('Logout', style: TextStyle(color: Colors.red)),
                    onTap: () => logout(context),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              title: const Row(
                children: [
                  SizedBox(width: 30),
                  Text(
                    'University Quality\n\t\t\t\t\t\t\tAssurance',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              centerTitle: true,
              backgroundColor: Colors.blue.shade900,
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome Again,',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$firstName $lastName',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              email ?? '',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //color: currentColor,
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            //color: currentColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: isGridView
                              ? GridView.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  children:
                                      _buildButtons(context).map((button) {
                                    return ElevatedButton.icon(
                                      icon: Icon(
                                        button.icon,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        button.label,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        primary: Colors.blue.shade900,
                                      ),
                                      onPressed: button.onPressed,
                                    );
                                  }).toList(),
                                )
                              : ListView.separated(
                                  itemBuilder: (context, index) {
                                    final button =
                                        _buildButtons(context)[index];
                                    return Card(
                                      margin: EdgeInsets.only(top: 20),
                                      elevation: 5,
                                      color: Colors.blue.shade900,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ListTile(
                                        leading: Icon(
                                          button.icon,
                                          size: 32,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          button.label,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        onTap: button.onPressed,
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 15),
                                  itemCount: _buildButtons(context).length,
                                ),
                        ),
                      ),
                    ],
                  ),
          );
        });
  }

  List<_ButtonData> _buildButtons(BuildContext context) {
    return [
      _ButtonData(
        icon: Icons.book,
        label: 'View Lectures',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DailyLecturesPage(
                studentId: widget.studentId,
                colorNotifier: colorNotifier,
              ),
            ),
          );
        },
      ),
      _ButtonData(
        icon: Icons.person,
        label: 'Profile',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FetchProfilePage(studentId: widget.studentId),
            ),
          );
        },
      ),
      _ButtonData(
        icon: Icons.schedule_send,
        label: 'Attendance',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AttendancePage(),
            ),
          );
        },
      ),
      _ButtonData(
        icon: Icons.notifications,
        label: 'Notifications',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationsPage(
                studentId: widget.studentId,
                colorNotifier: colorNotifier,
              ),
            ),
          );
        },
      ),
      _ButtonData(
        icon: Icons.feedback,
        label: 'Submit Feedback',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SubmitFeedbackPage(studentId: widget.studentId),
            ),
          );
        },
      ),
      _ButtonData(
        icon: Icons.menu_book,
        label: 'Courses',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoursesPage(
                studentId: widget.studentId,
                colorNotifier: colorNotifier,
              ),
            ),
          );
        },
      ),
    ];
  }
}

class _ButtonData {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  _ButtonData({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
}
