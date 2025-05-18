import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../API/api_class.dart';
import '../../Them/color_notifier_page.dart';

class CoursesPage extends StatefulWidget {
  final String studentId; // Receive the student ID
  final ColorNotifier colorNotifier;

  const CoursesPage(
      {super.key, required this.studentId, required this.colorNotifier});

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<dynamic> courses = [];
  String errorMessage = "";
  final ColorNotifier colorNotifier = ColorNotifier(Colors.white);

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final response = await http.post(
      Uri.parse(ApiClass.getEndpoint('newBackEnd/get_courses.php')),
      body: {'student_id': widget.studentId}, // Use the provided student ID
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          courses = data['courses'];
          errorMessage = ""; // Clear any previous error message
        });
      } else {
        setState(() {
          errorMessage = data['message']; // Set error message from response
        });
      }
    } else {
      setState(() {
        errorMessage = 'Failed to load courses'; // Handle HTTP errors
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
              title: const Text(
                'Courses',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.blue.shade800,
              elevation: 5,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
            ),
            body: errorMessage.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : courses.isNotEmpty
                    ? ListView.builder(
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 40.0, horizontal: 16.0),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: InkWell(
                              onTap: () {
                                // Handle tap if needed, e.g., navigate to course details
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade600,
                                      Colors.blue.shade300
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16.0),
                                  title: Text(
                                    course['course_name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Level: ${course['level']}.\nMajor: ${course['major_name']}.\nCollege: ${course['college_name']}.',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No courses found.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
          );
        });
  }
}
