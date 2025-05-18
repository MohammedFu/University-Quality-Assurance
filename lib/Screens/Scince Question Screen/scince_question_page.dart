import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../API/api_class.dart';

class FetchScinceQuestionsPage extends StatefulWidget {
  final String studentId;
  final String lectureId;

  FetchScinceQuestionsPage({required this.studentId, required this.lectureId});

  @override
  _FetchScinceQuestionsPageState createState() =>
      _FetchScinceQuestionsPageState();
}

class _FetchScinceQuestionsPageState extends State<FetchScinceQuestionsPage> {
  List<Map<String, dynamic>> _questions = [];
  Map<String, dynamic> _selectedAnswers = {};
  bool _isLoading = true;
  String? _errorMessage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      final response = await http.post(
        Uri.parse(ApiClass.getEndpoint('newBackEnd/fetch_questions.php')),
        body: {
          'student_id': widget.studentId,
          'lecture_id': widget.lectureId,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          setState(() {
            _questions =
            List<Map<String, dynamic>>.from(jsonResponse['questions']);
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = jsonResponse['message'];
            _isLoading = false;
          });
        }
      } else {
        throw Exception(
            'Failed to fetch questions. Status code: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: $error';
        _isLoading = false;
      });
    }
  }

  Future<void> _submitAnswers() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await http.post(
        Uri.parse(ApiClass.getEndpoint('newBackEnd/submit_answer.php')),
        body: {
          'student_id': widget.studentId,
          'lecture_id': widget.lectureId,
          'answers': json.encode(_selectedAnswers),
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 'success') {
          setState(() {
            _questions.removeWhere((question) =>
                _selectedAnswers.keys.contains(question['question_id']));
            _selectedAnswers.clear();
          });

          // Show success message in an AlertDialog
          _showSuccessDialog('Answers submitted successfully!');
        } else {
          _showErrorDialog('Error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to submit answers. Status code: ${response.statusCode}');
      }
    } catch (error) {
      _showErrorDialog('Error: $error');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Today\'s Science \n            Questions of The Lecture',
            style: TextStyle(fontSize: 22, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null || _questions.isEmpty
          ? Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade300,
                blurRadius: 10,
                offset: const Offset(4, 4),
              ),
            ],
            border: Border.all(
              color: Colors.blue.shade400,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check,
                size: 40,
                color: Colors.blue,
              ),
              const SizedBox(height: 10),
              Text(
                'You Have Answered All The Questions For Today\'s Lecture',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      )
      // Center(
      //   child: Text(
      //     'You Have Answered All The Questions For Today\'s Lecture',
      //     style: TextStyle(fontSize: 18, color: Colors.grey),
      //     textAlign: TextAlign.center,
      //   ),
      // )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          question['question_text'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          softWrap: true,
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            _buildChoice(
                                question['question_id'],
                                'A',
                                question['choice_one']),
                            _buildChoice(
                                question['question_id'],
                                'B',
                                question['choice_two']),
                            _buildChoice(
                                question['question_id'],
                                'C',
                                question['choice_three']),
                            _buildChoice(
                                question['question_id'],
                                'D',
                                question['choice_four']),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _questions.isNotEmpty
          ? FloatingActionButton(
        onPressed: _submitAnswers,
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.send, color: Colors.white),
      )
          : null,
    );
  }

  Widget _buildChoice(String questionId, String option, String choiceText) {
    return Row(
      children: [
        Radio<String>(
          value: choiceText,
          groupValue: _selectedAnswers[questionId],

          activeColor: Colors.black, // Updated color for better visibility
          onChanged: (value) {
            setState(() {
              _selectedAnswers[questionId] = value!;
            });
          },
        ),
        Expanded(
          child: Text(
            '$option) $choiceText',
            softWrap: true,
            style: TextStyle(
                color: Colors.white, letterSpacing: 1.0, fontSize: 22),
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../../API/api_class.dart';
//
// class FetchScinceQuestionsPage extends StatefulWidget {
//   final String studentId;
//   final String lectureId;
//
//   FetchScinceQuestionsPage({required this.studentId, required this.lectureId});
//
//   @override
//   _FetchScinceQuestionsPageState createState() =>
//       _FetchScinceQuestionsPageState();
// }
//
// class _FetchScinceQuestionsPageState extends State<FetchScinceQuestionsPage> {
//   List<Map<String, dynamic>> _questions = [];
//   Map<String, dynamic> _selectedAnswers = {};
//   bool _isLoading = true;
//   String? _errorMessage;
//   bool _isSubmitting = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchQuestions();
//   }
//
//   Future<void> _fetchQuestions() async {
//     try {
//       final response = await http.post(
//         Uri.parse(ApiClass.getEndpoint('newBackEnd/fetch_questions.php')),
//         body: {
//           'student_id': widget.studentId,
//           'lecture_id': widget.lectureId,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         if (jsonResponse['status'] == 'success') {
//           setState(() {
//             _questions =
//             List<Map<String, dynamic>>.from(jsonResponse['questions']);
//             _isLoading = false;
//           });
//         } else {
//           setState(() {
//             _errorMessage = jsonResponse['message'];
//             _isLoading = false;
//           });
//         }
//       } else {
//         throw Exception(
//             'Failed to fetch questions. Status code: ${response.statusCode}');
//       }
//     } catch (error) {
//       setState(() {
//         _errorMessage = 'Error: $error';
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _submitAnswers() async {
//     if (_isSubmitting) return;
//
//     setState(() {
//       _isSubmitting = true;
//     });
//
//     try {
//       final response = await http.post(
//         Uri.parse(ApiClass.getEndpoint('newBackEnd/submit_answer.php')),
//         body: {
//           'student_id': widget.studentId,
//           'lecture_id': widget.lectureId,
//           'answers': json.encode(_selectedAnswers),
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//
//         if (jsonResponse['status'] == 'success') {
//           setState(() {
//             // Remove answered questions from the list
//             _questions.removeWhere((question) =>
//                 _selectedAnswers.keys.contains(question['question_id']));
//             _selectedAnswers.clear();
//           });
//
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Answers submitted successfully!')),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error: ${jsonResponse['message']}')),
//           );
//         }
//       } else {
//         throw Exception(
//             'Failed to submit answers. Status code: ${response.statusCode}');
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $error')),
//       );
//     } finally {
//       setState(() {
//         _isSubmitting = false;
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//             'Today\'s Science \n            Questions of The Lecture',
//             style: TextStyle(fontSize: 22, color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: Colors.blue.shade800,
//         elevation: 5,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _errorMessage != null
//           ? Center(child: Text(_errorMessage!))
//           : _questions.isEmpty
//           ? const Center(child: Text('No questions available.'))
//           : Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//                 itemCount: _questions.length,
//                 itemBuilder: (context, index) {
//                   final question = _questions[index];
//                   return Container(
//                     margin: const EdgeInsets.only(
//                       top: 20,
//                       left: 20,
//                       right: 20,
//                       bottom: 20,
//                     ),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.blue.shade800,
//                           Colors.blue.shade400
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             question['question_text'],
//                             style: const TextStyle(
//                               fontSize: 24,
//                               fontStyle: FontStyle.italic,
//                               letterSpacing: 1.0,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                             softWrap: true,
//                           ),
//                           const SizedBox(height: 10),
//                           Column(
//                             children: [
//                               _buildChoice(
//                                   question['question_id'],
//                                   'A',
//                                   question['choice_one']),
//                               _buildChoice(
//                                   question['question_id'],
//                                   'B',
//                                   question['choice_two']),
//                               _buildChoice(
//                                   question['question_id'],
//                                   'C',
//                                   question['choice_three']),
//                               _buildChoice(
//                                   question['question_id'],
//                                   'D',
//                                   question['choice_four']),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//           ),
//         ],
//       ),
//       floatingActionButton: _questions.isNotEmpty
//           ? FloatingActionButton(
//         onPressed: _submitAnswers,
//         backgroundColor: Colors.blue.shade800,
//         child: const Icon(Icons.send, color: Colors.white),
//       )
//           : null,
//     );
//   }
//
//   Widget _buildChoice(String questionId, String option, String choiceText) {
//     return Row(
//       children: [
//         Radio<String>(
//           value: choiceText,
//           groupValue: _selectedAnswers[questionId],
//           activeColor: Colors.black,
//           onChanged: (value) {
//             setState(() {
//               _selectedAnswers[questionId] = value!;
//             });
//           },
//         ),
//         Expanded(
//           child: Text(
//             '$option) $choiceText',
//             softWrap: true,
//             style: TextStyle(
//                 color: Colors.white, letterSpacing: 1.0, fontSize: 22),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../../API/api_class.dart';
//
// class FetchScinceQuestionsPage extends StatefulWidget {
//   final String studentId;
//   final String lectureId;
//
//   FetchScinceQuestionsPage({required this.studentId, required this.lectureId});
//
//   @override
//   _FetchScinceQuestionsPageState createState() =>
//       _FetchScinceQuestionsPageState();
// }
//
// class _FetchScinceQuestionsPageState extends State<FetchScinceQuestionsPage> {
//   List<Map<String, dynamic>> _questions = [];
//   Map<String, dynamic> _selectedAnswers = {};
//   bool _isLoading = true;
//   String? _errorMessage;
//   bool _isSubmitting = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchQuestions();
//   }
//
//   Future<void> _fetchQuestions() async {
//     try {
//       final response = await http.post(
//         Uri.parse(ApiClass.getEndpoint('newBackEnd/fetch_questions.php')),
//         body: {
//           'student_id': widget.studentId,
//           'lecture_id': widget.lectureId,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         if (jsonResponse['status'] == 'success') {
//           setState(() {
//             _questions =
//                 List<Map<String, dynamic>>.from(jsonResponse['questions']);
//             _isLoading = false;
//           });
//         } else {
//           setState(() {
//             _errorMessage = jsonResponse['message'];
//             _isLoading = false;
//           });
//         }
//       } else {
//         throw Exception(
//             'Failed to fetch questions. Status code: ${response.statusCode}');
//       }
//     } catch (error) {
//       setState(() {
//         _errorMessage = 'Error: $error';
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _submitAnswers() async {
//     if (_isSubmitting) return;
//
//     setState(() {
//       _isSubmitting = true;
//     });
//
//     try {
//       final response = await http.post(
//         Uri.parse(ApiClass.getEndpoint('newBackEnd/submit_answer.php')),
//         body: {
//           'student_id': widget.studentId,
//           'lecture_id': widget.lectureId,
//           'answers': json.encode(_selectedAnswers),
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//
//         if (jsonResponse['status'] == 'success') {
//           setState(() {
//             _selectedAnswers.clear();
//           });
//
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Answers submitted successfully!')),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error: ${jsonResponse['message']}')),
//           );
//         }
//       } else {
//         throw Exception(
//             'Failed to submit answers. Status code: ${response.statusCode}');
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $error')),
//       );
//     } finally {
//       setState(() {
//         _isSubmitting = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//             'Today\'s Science \n            Questions of The Lecture',
//             style: TextStyle(fontSize: 22, color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: Colors.blue.shade800,
//         elevation: 5,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _errorMessage != null
//               ? Center(child: Text(_errorMessage!))
//               : _questions.isEmpty
//                   ? const Center(child: Text('No questions available.'))
//                   : Column(
//                       children: [
//                         Expanded(
//                           child: ListView.builder(
//                               itemCount: _questions.length,
//                               itemBuilder: (context, index) {
//                                 final question = _questions[index];
//                                 return Container(
//                                   margin: const EdgeInsets.only(
//                                     top: 20,
//                                     left: 20,
//                                     right: 20,
//                                     bottom: 20,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         Colors.blue.shade800,
//                                         Colors.blue.shade400
//                                       ],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                     ),
//                                     borderRadius: BorderRadius.circular(25),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(16.0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           question['question_text'],
//                                           style: const TextStyle(
//                                             fontSize: 24,
//                                             fontStyle: FontStyle.italic,
//                                             letterSpacing: 1.0,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.black,
//                                           ),
//                                           softWrap: true,
//                                         ),
//                                         const SizedBox(height: 10),
//                                         Column(
//                                           children: [
//                                             _buildChoice(
//                                                 question['question_id'],
//                                                 'A',
//                                                 question['choice_one']),
//                                             _buildChoice(
//                                                 question['question_id'],
//                                                 'B',
//                                                 question['choice_two']),
//                                             _buildChoice(
//                                                 question['question_id'],
//                                                 'C',
//                                                 question['choice_three']),
//                                             _buildChoice(
//                                                 question['question_id'],
//                                                 'D',
//                                                 question['choice_four']),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               }),
//                         ),
//                       ],
//                     ),
//       floatingActionButton: _questions.isNotEmpty
//           ? FloatingActionButton(
//               onPressed: _submitAnswers,
//               backgroundColor: Colors.blue.shade800,
//               child: const Icon(Icons.send, color: Colors.white),
//             )
//           : null, // Floating button only if there are questions
//     );
//   }
//
//   Widget _buildChoice(String questionId, String option, String choiceText) {
//     return Row(
//       children: [
//         Radio<String>(
//           value: choiceText,
//           groupValue: _selectedAnswers[questionId],
//
//           activeColor: Colors.black, // Updated color for better visibility
//           onChanged: (value) {
//             setState(() {
//               _selectedAnswers[questionId] = value!;
//             });
//           },
//         ),
//         Expanded(
//           child: Text(
//             '$option) $choiceText',
//             softWrap: true,
//             style: TextStyle(
//                 color: Colors.white, letterSpacing: 1.0, fontSize: 22),
//           ),
//         ),
//       ],
//     );
//   }
// }
