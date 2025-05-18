import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../API/api_class.dart';
import '../../../Them/color_notifier_page.dart';

class LectureDetailsPage extends StatefulWidget {
  final String lectureId;
  final ColorNotifier colorNotifier;

  const LectureDetailsPage(
      {Key? key,
      required this.lectureId,
      required String studentId,
      required this.colorNotifier})
      : super(key: key);

  @override
  _LectureDetailsPageState createState() => _LectureDetailsPageState();
}

class _LectureDetailsPageState extends State<LectureDetailsPage>
    with SingleTickerProviderStateMixin {
  final String apiUrl = ApiClass.getEndpoint('newBackEnd/fetch_lecture_details.php');
  Map<String, dynamic>? lectureDetails;
  bool isLoading = true;
  String errorMessage = '';
  late AnimationController _controller;
  final ColorNotifier colorNotifier = ColorNotifier(Colors.white);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    fetchLectureDetails();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchLectureDetails() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'lecture_id': widget.lectureId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            lectureDetails = data['lecture_details'];
            isLoading = false;
            _controller.forward();
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Unknown error occurred';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load lecture details';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
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
              title:
                  const Text('Lecture Details', style: TextStyle(fontSize: 22)),
              centerTitle: true,
              backgroundColor: Colors.blue.shade800,
              elevation: 5,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(
                        child: Text(
                          errorMessage,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      )
                    : lectureDetails == null
                        ? const Center(child: Text('No details available.'))
                        : FadeTransition(
                            opacity: _controller,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Card(
                                  elevation: 12,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.shade800,
                                          Colors.blue.shade400
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    height:
                                        600, // Increased height for better spacing
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.book,
                                                color: Colors.white, size: 30),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                lectureDetails![
                                                        'course_name'] ??
                                                    'Unknown Course',
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          height: 30,
                                          thickness: 1.5,
                                          color: Colors.white70,
                                        ),
                                        _buildInfoRow(
                                          Icons.date_range,
                                          'Date',
                                          lectureDetails!['lecture_date'] ??
                                              'N/A',
                                        ),
                                        const SizedBox(height: 10),
                                        _buildInfoRow(
                                          Icons.access_time,
                                          'Time',
                                          '${lectureDetails!['start_time'] ?? 'N/A'} - ${lectureDetails!['end_time'] ?? 'N/A'}',
                                        ),
                                        const SizedBox(height: 10),
                                        _buildInfoRow(
                                          Icons.calendar_today,
                                          'Day',
                                          lectureDetails!['day_of_week'] ??
                                              'N/A',
                                        ),
                                        const SizedBox(height: 10),
                                        _buildInfoRow(
                                          Icons.person,
                                          'Lecturer',
                                          '${lectureDetails!['first_name'] ?? 'N/A'} ${lectureDetails!['last_name'] ?? 'N/A'}',
                                        ),
                                        const SizedBox(height: 10),
                                        _buildInfoRow(
                                          Icons.school,
                                          'Major',
                                          lectureDetails!['major_name'] ??
                                              'N/A',
                                        ),
                                        const SizedBox(height: 10),
                                        _buildInfoRow(
                                          Icons.schedule,
                                          'Status',
                                          lectureDetails!['status'] ?? 'N/A',
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Description:',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          lectureDetails!['description'] ??
                                              'No description available.',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
          );
        });
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 25),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ),
      ],
    );
  }
}