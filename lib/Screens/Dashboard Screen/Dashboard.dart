import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lmw/Screens/Main%20Screen/main_page.dart';
import 'dart:convert';
import '../../API/api_class.dart';
import '../../Them/color_notifier_page.dart';
import '../Lectures Screens/Fetch Lecture Screen/fetch_lectures_page.dart';
import '../Notification Screen/notification_model.dart';
import '../Submit Lectures-Feedback Screen/submit_lectures_feedback_page.dart';
import 'package:intl/intl.dart';

Future<List<NotificationModel>> fetchNotifications(String studentId) async {
  final response = await http.post(
    Uri.parse(ApiClass.getEndpoint('newBackEnd/fetch_notifications.php')),
    body: {'student_id': studentId.toString()},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success']) {
      return (data['notifications'] as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    }
  }
  throw Exception('Failed to load notifications');
}

class DashboardPage extends StatefulWidget {
  final String studentId;
  final ColorNotifier colorNotifier;

  DashboardPage({required this.studentId, required this.colorNotifier});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<NotificationModel>> _notificationsFuture;
  String? firstName;
  String? lastName;
  bool isLoading = true;
  final ColorNotifier colorNotifier = ColorNotifier(Colors.white);

  @override
  void initState() {
    super.initState();
    _notificationsFuture = fetchNotifications(widget.studentId);
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
          firstName = responseData['data']['first_name'];
          lastName = responseData['data']['last_name'];
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

  String formatTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('HH:mm').format(dateTime);
  }

  String formatDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
        valueListenable: widget.colorNotifier,
        builder: (context, currentColor, child) {
          return Scaffold(
            backgroundColor: currentColor,
            appBar: AppBar(
              title: Text('Student Dashboard',
                  style: TextStyle(fontSize: 28, color: Colors.white)),
              centerTitle: true,
              backgroundColor: Colors.blue.shade800,
              elevation: 5,
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(25)),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(
                            studentId: widget.studentId,
                            colorNotifier: widget.colorNotifier,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 28,
                    ))
              ],
            ),
            body: isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    color: Colors.blue.shade900,
                    onRefresh: () async {
                      setState(() {
                        _notificationsFuture =
                            fetchNotifications(widget.studentId);
                      });
                    },
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome Section with Stylish Container
                          Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              "Welcome Again, $firstName $lastName",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),

                          Text(
                            "Upcoming Lectures",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),
                          SizedBox(height: 8),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: Colors.blue.shade900,
                            elevation: 6,
                            child: ListTile(
                              title: Text("Today\'s Lectuers",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              subtitle: Text("Click to Check",
                                  style: TextStyle(color: Colors.white70)),
                              trailing: Icon(Icons.arrow_forward,
                                  color: Colors.white),
                              onTap: () {
                                Navigator.pushReplacement(
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
                          ),
                          SizedBox(height: 16),

                          Text(
                            "Attendance Overview",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),
                          SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: 0.85, // Example: 85% attendance
                            backgroundColor: Colors.grey[300],
                            color: Colors.green,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "You’ve attended 85% of your lectures this semester!",
                            style: TextStyle(color: Colors.green),
                          ),

                          SizedBox(height: 16),

                          // Pending Feedback Section with Navigation
                          Text(
                            "Pending Feedback",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),
                          SizedBox(height: 8),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: Colors.blue.shade900,
                            elevation: 6,
                            child: ListTile(
                              title: Text("Lecture Feedback",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              subtitle: Text(
                                "Complete feedback for last week's lectures.",
                                style: TextStyle(color: Colors.white70),
                              ),
                              trailing:
                                  Icon(Icons.feedback, color: Colors.white),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubmitFeedbackPage(
                                        studentId: widget.studentId),
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 16),

                          // Notifications Section with Stylish Cards
                          Text(
                            "Notifications",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),
                          SizedBox(height: 8),
                          FutureBuilder<List<NotificationModel>>(
                            future: _notificationsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(child: Text('No notifications'));
                              }

                              var notifications = snapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: notifications.length,
                                itemBuilder: (context, index) {
                                  final notification = notifications[index];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Notification Date
                                      Text(
                                        formatDate(notification.createdAt),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Card(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        color: Colors.blue.shade900,
                                        elevation: 4,
                                        child: ListTile(
                                          title: Text(
                                            notification.message,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          subtitle: Text(
                                              "Time: ${formatTime(notification.createdAt)}",
                                              style: TextStyle(
                                                  color: Colors.white70)),
                                          trailing: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubmitFeedbackPage(
                                                          studentId:
                                                              widget.studentId),
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons.arrow_forward,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
