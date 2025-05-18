import 'dart:convert';
import 'package:flutter/material.dart';
import '../../API/api_class.dart';
import '../../Them/color_notifier_page.dart';
import 'notification_model.dart';
import 'package:http/http.dart' as http;
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

Future<void> markAsRead(String notificationId) async {
  await http.post(
    Uri.parse(ApiClass.getEndpoint('newBackEnd/mark_as_read.php')),
    body: {'notification_id': notificationId.toString()},
  );
}

Future<void> deleteNotification(String notificationId) async {
  final response = await http.post(
    Uri.parse(ApiClass.getEndpoint('newBackEnd/delete_notification.php')),
    body: {'notification_id': notificationId.toString()},
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to delete notification');
  }
}

class NotificationsPage extends StatefulWidget {
  final String studentId;
  final ColorNotifier colorNotifier;

  NotificationsPage({required this.studentId, required this.colorNotifier});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationModel>> _notificationsFuture;
  final ColorNotifier colorNotifier = ColorNotifier(Colors.white);

  @override
  void initState() {
    super.initState();
    _notificationsFuture = fetchNotifications(widget.studentId);
  }

  void _markAsRead(NotificationModel notification) async {
    await markAsRead(notification.notification_id);
    _refreshNotifications();
  }

  void _deleteNotification(NotificationModel notification) async {
    try {
      await deleteNotification(notification.notification_id);
      _refreshNotifications();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete notification')),
      );
    }
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      _notificationsFuture = fetchNotifications(widget.studentId);
    });
  }

  String _formatTime(String dateTime) {
    final dateFormat = DateFormat("hh:mm a");
    final date = DateTime.parse(dateTime);
    return dateFormat.format(date);
  }

  String _formatDate(String dateTime) {
    final dateFormat = DateFormat("MMMM dd, yyyy");
    final date = DateTime.parse(dateTime);
    return dateFormat.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
        valueListenable: widget.colorNotifier,
        builder: (context, currentColor, child) {
          return Scaffold(
            backgroundColor: currentColor,
            appBar: AppBar(
              title: const Text(
                'Notifications',
                  style: TextStyle(fontSize: 28, color: Colors.white)),
              centerTitle: true,
              backgroundColor: Colors.blue.shade800,
              elevation: 5,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: _refreshNotifications,
              color: Colors.orange,
              // Custom color for the spinner
              backgroundColor: Colors.blue.shade900,
              // Custom background color
              strokeWidth: 3.0,
              // Custom stroke width for the spinner
              displacement: 50.0,
              // Space between the indicator and the content
              child: FutureBuilder<List<NotificationModel>>(
                future: _notificationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: const Text('No notifications'));
                  }

                  var notifications = snapshot.data!;
                  Map<String, List<NotificationModel>> groupedNotifications =
                      {};
                  for (var notification in notifications) {
                    String date = _formatDate(notification.createdAt);
                    if (!groupedNotifications.containsKey(date)) {
                      groupedNotifications[date] = [];
                    }
                    groupedNotifications[date]!.add(notification);
                  }

                  return ListView.builder(
                    itemCount: groupedNotifications.keys.length,
                    itemBuilder: (context, index) {
                      String date = groupedNotifications.keys.elementAt(index);
                      List<NotificationModel> notificationsForDate =
                          groupedNotifications[date]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Text(
                              date,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: notificationsForDate.length,
                            itemBuilder: (context, subIndex) {
                              final notification =
                                  notificationsForDate[subIndex];
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Card(
                                  elevation: 10,
                                  color: Colors.blue.shade900,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification.message,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _formatTime(notification.createdAt),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (!notification.isRead)
                                              ElevatedButton(
                                                onPressed: () =>
                                                    _markAsRead(notification),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.orangeAccent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Mark as Read',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  _deleteNotification(
                                                      notification),
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.redAccent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        });
  }
}