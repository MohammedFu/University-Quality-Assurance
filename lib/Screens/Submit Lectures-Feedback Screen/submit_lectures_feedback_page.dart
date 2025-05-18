// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//
// class SubmitFeedbackPage extends StatefulWidget {
//   final String studentId;
//
//   const SubmitFeedbackPage({Key? key, required this.studentId}) : super(key: key);
//
//   @override
//   _SubmitFeedbackPageState createState() => _SubmitFeedbackPageState();
// }
//
// class _SubmitFeedbackPageState extends State<SubmitFeedbackPage> {
//   final String fetchTopicsUrl = 'http://10.0.2.2/newBackEnd/get_topic_names.php';
//   final String submitFeedbackUrl = 'http://10.0.2.2/newBackEnd/submit_feedback.php';
//
//   String? selectedLectureId;
//   List<dynamic> topics = [];
//   final TextEditingController feedbackController = TextEditingController();
//   double selectedRating = 3.0; // Default rating value
//
//   @override
//   void initState() {
//     super.initState();
//     fetchTopics();
//   }
//
//   Future<void> fetchTopics() async {
//     try {
//       final response = await http.get(Uri.parse(fetchTopicsUrl));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data["status"] == "success") {
//           // Directly assign all topics without filtering
//           topics = data["topics"];
//           setState(() {});
//         } else {
//           showError(data["message"]);
//         }
//       } else {
//         showError("Failed to fetch topics. Status code: ${response.statusCode}");
//       }
//     } catch (e) {
//       showError("An error occurred while fetching topics: $e");
//     }
//   }
//
//   Future<void> submitFeedback() async {
//     if (selectedLectureId == null || selectedLectureId!.isEmpty) {
//       showError("Please select a lecture.");
//       return;
//     }
//
//     final feedbackText = feedbackController.text.trim();
//     if (feedbackText.isEmpty) {
//       showError("Please enter your feedback.");
//       return;
//     }
//
//     try {
//       final response = await http.post(
//         Uri.parse(submitFeedbackUrl),
//         body: {
//           'student_id': widget.studentId,
//           'lecture_id': selectedLectureId,
//           'feedback_text': feedbackText,
//           'rating': selectedRating.toString(), // Include rating in submission
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 'success') {
//           showSuccess("Feedback submitted successfully!");
//           feedbackController.clear();
//           setState(() {
//             selectedLectureId = null;
//             selectedRating = 3.0; // Reset rating
//           });
//         } else {
//           showError(data['message']);
//         }
//       } else {
//         showError("Failed to submit feedback. Status code: ${response.statusCode}");
//       }
//     } catch (e) {
//       showError("An error occurred while submitting feedback: $e");
//     }
//   }
//
//   void showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(message),
//       backgroundColor: Colors.red,
//     ));
//   }
//
//   void showSuccess(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(message),
//       backgroundColor: Colors.green,
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Submit Feedback',
//           style: TextStyle(fontSize: 28, color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blue.shade800,
//         elevation: 5,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Dropdown for selecting lecture
//             DropdownButtonFormField<String>(
//               isExpanded: true,
//               value: selectedLectureId,
//               items: [
//                 const DropdownMenuItem(
//                   value: null,
//                   child: Text("Select a lecture"),
//                 ),
//                 ...topics.map<DropdownMenuItem<String>>((topic) {
//                   return DropdownMenuItem<String>(
//                     value: topic['lecture_id'].toString(),
//                     child: Row(
//                       children: [
//                         Text(
//                           '${topic['lecture_id']})',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(width: 8), // Add some spacing between the two texts
//                         Expanded(
//                           child: Text(
//                             '\t${topic['topic_name']}',
//                             style: TextStyle(),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 2,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   selectedLectureId = value;
//                 });
//               },
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Select a lecture",
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Rating Bar
//             const Text(
//               'Rate the lecture:',
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             RatingBar.builder(
//               initialRating: selectedRating,
//               minRating: 1,
//               direction: Axis.horizontal,
//               allowHalfRating: true,
//               itemCount: 5,
//               itemBuilder: (context, _) => const Icon(
//                 Icons.star,
//                 color: Colors.amber,
//               ),
//               onRatingUpdate: (rating) {
//                 setState(() {
//                   selectedRating = rating;
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             // Feedback TextField
//             TextField(
//               controller: feedbackController,
//               maxLines: 4,
//               decoration: const InputDecoration(
//                 labelText: 'Feedback Text',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Submit Button
//             ElevatedButton(
//               onPressed: submitFeedback,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 backgroundColor: Colors.blueAccent,
//                 textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 5,
//               ),
//               child: const Text(
//                 'Submit Feedback',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../API/api_class.dart';

class SubmitFeedbackPage extends StatefulWidget {
  final String studentId;

  const SubmitFeedbackPage({Key? key, required this.studentId}) : super(key: key);

  @override
  _SubmitFeedbackPageState createState() => _SubmitFeedbackPageState();
}

class _SubmitFeedbackPageState extends State<SubmitFeedbackPage> {
  final String fetchTopicsUrl = ApiClass.getEndpoint('newBackEnd/get_topic_names.php');
  final String submitFeedbackUrl = ApiClass.getEndpoint('newBackEnd/submit_feedback.php');

  String? selectedLectureId;
  List<dynamic> topics = [];
  final TextEditingController feedbackController = TextEditingController();
  double selectedRating = 2.5; // Default rating value

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    try {
      final response = await http.get(Uri.parse(fetchTopicsUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "success") {
          Set<String> uniqueLectureIds = {};
          topics = data["topics"].where((topic) {
            if (uniqueLectureIds.contains(topic['lecture_id'].toString())) {
              return false; // Skip duplicates
            } else {
              uniqueLectureIds.add(topic['lecture_id'].toString());
              return true; // Include unique item
            }
          }).toList();
          setState(() {});
        } else {
          showError(data["message"]);
        }
      } else {
        showError("Failed to fetch topics. Status code: ${response.statusCode}");
      }
    } catch (e) {
      showError("An error occurred while fetching topics: $e");
    }
  }

  Future<void> submitFeedback() async {
    if (selectedLectureId == null || selectedLectureId!.isEmpty) {
      showError("Please select a lecture.");
      return;
    }

    final feedbackText = feedbackController.text.trim();
    if (feedbackText.isEmpty) {
      showError("Please enter your feedback.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(submitFeedbackUrl),
        body: {
          'student_id': widget.studentId,
          'lecture_id': selectedLectureId,
          'feedback_text': feedbackText,
          'rating': selectedRating.toString(), // Include rating in submission
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          showSuccess("Feedback submitted successfully!");
          feedbackController.clear();
          setState(() {
            selectedLectureId = null;
            selectedRating = 3.0; // Reset rating
          });
        } else {
          showError(data['message']);
        }
      } else {
        showError("Failed to submit feedback. Status code: ${response.statusCode}");
      }
    } catch (e) {
      showError("An error occurred while submitting feedback: $e");
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Submit Feedback',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 60.0, right: 20.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dropdown for selecting lecture
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: selectedLectureId,
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text("Select a lecture"),
                ),
                ...topics.map<DropdownMenuItem<String>>((topic) {
                  return DropdownMenuItem<String>(
                    value: topic['lecture_id'].toString(),
                    child: Row(
                      children: [
                        Text(
                          '${topic['lecture_id']})',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8), // Add some spacing between the two texts
                        Expanded(
                          child: Text(
                            '\t${topic['topic_name']}',
                            style: TextStyle(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() {
                  selectedLectureId = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Select a lecture",
              ),
            ),
            const SizedBox(height: 20),
            // Rating Bar
            Center(
              child: const Text(
                'Rate the lecture:',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: RatingBar.builder(
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
                  setState(() {
                    selectedRating = rating;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            // Feedback TextField
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Feedback Text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
              onPressed: submitFeedback,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blueAccent,
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Submit Feedback',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}