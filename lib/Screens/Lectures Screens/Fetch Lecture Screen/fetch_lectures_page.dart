import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../API/api_class.dart';
import '../../../Them/color_notifier_page.dart';
import '../../Scince Question Screen/scince_question_page.dart';
import '../Fetch Lecture Details Screen/fetch_lecture_details_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DailyLecturesPage extends StatefulWidget {
  final String studentId;
  final ColorNotifier colorNotifier;

  const DailyLecturesPage({
    Key? key,
    required this.studentId,
    required this.colorNotifier,
  }) : super(key: key);

  @override
  _DailyLecturesPageState createState() => _DailyLecturesPageState();
}

class _DailyLecturesPageState extends State<DailyLecturesPage>
    with SingleTickerProviderStateMixin {
  final String apiUrl = ApiClass.getEndpoint('newBackEnd/fetch_lectures.php');
  final String feedbackApiUrl = ApiClass.getEndpoint(
      'newBackEnd/submit_feedback.php'); // Add this endpoint for feedback
  List<dynamic> lectures = [];
  bool isLoading = true;
  String errorMessage = '';
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    fetchLectures();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchLectures() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'student_id': widget.studentId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            lectures = data['lectures'];
            isLoading = false;
            _controller.forward();
          });
        } else {
          setState(() {
            errorMessage = data['message'];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching lecture data: $e';
        isLoading = false;
      });
    }
  }

  Future<void> submitFeedback(
      String lectureId, double rating, String feedback) async {
    try {
      final response = await http.post(
        Uri.parse(feedbackApiUrl),
        body: {
          'student_id': widget.studentId,
          'lecture_id': lectureId,
          'rating': rating.toString(),
          'feedback_text': feedback,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Feedback submitted successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit feedback')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting feedback: $e')),
      );
    }
  }

  void openFeedbackDialog(String lectureId) {
    double selectedRating = 3.0;
    String feedbackText = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey
              .withOpacity(1.0), // Remove the default white background
          title: const Text(
            'Give Your Feedback',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Rate the lecture:',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                RatingBar.builder(
                  initialRating: selectedRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    selectedRating = rating;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) => feedbackText = value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Your Feedback',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                submitFeedback(lectureId, selectedRating, feedbackText);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.amber, // Custom button color
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
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
              '    Welcome to\n         Today\'s Lectures',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue.shade800,
            elevation: 5,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
            ),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : lectures.isEmpty
                      ? Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red, width: 2),
                            ),
                            child: const Text(
                              'No lectures for today.',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : FadeTransition(
                          opacity: _controller,
                          child: Scrollbar(
                            thickness: 8.0,
                            radius: const Radius.circular(10),
                            child: ListView.builder(
                              itemCount: lectures.length,
                              itemBuilder: (context, index) {
                                final lecture = lectures[index];
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
                                            'Course: ${lecture['course_name']}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Lecture Day: ${lecture['day_of_week']}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Text(
                                            'Time: ${lecture['start_time']} - ${lecture['end_time']}',
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
                                              ElevatedButton(
                                                onPressed: () {
                                                  final lectureId =
                                                      lecture['lecture_id'];
                                                  if (lectureId != null) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            LectureDetailsPage(
                                                          studentId:
                                                              widget.studentId,
                                                          lectureId: lectureId
                                                              .toString(),
                                                          colorNotifier: widget
                                                              .colorNotifier,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Lecture ID not available'),
                                                      ),
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.blueAccent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Lecture Details',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  final lectureId =
                                                      lecture['lecture_id'];
                                                  if (lectureId != null) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            FetchScinceQuestionsPage(
                                                          studentId:
                                                              widget.studentId,
                                                          lectureId: lectureId,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Lecture ID not available'),
                                                      ),
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Today\'s Questions',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  final lectureId =
                                                      lecture['lecture_id']
                                                          .toString();
                                                  openFeedbackDialog(lectureId);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.orangeAccent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Give Your Feed',
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
                          ),
                        ),
        );
      },
    );
  }
}
