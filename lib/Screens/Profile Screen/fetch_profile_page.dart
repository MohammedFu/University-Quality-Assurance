import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../API/api_class.dart';

class FetchProfilePage extends StatefulWidget {
  final String studentId;

  const FetchProfilePage({super.key, required this.studentId});

  @override
  _FetchProfilePageState createState() => _FetchProfilePageState();
}

class _FetchProfilePageState extends State<FetchProfilePage> {
  String fname = '';
  String lname = '';
  String email = '';
  String password = '';
  String major_name = '';
  String year = '';
  String level = '';
  String semester = '';
  String college_name = '';
  final String apiUrl = ApiClass.getEndpoint('newBackEnd/fetch_profile.php');

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await http
          .post(Uri.parse(apiUrl), body: {'student_id': widget.studentId});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          fname = data['profile']['first_name'];
          lname = data['profile']['last_name'];
          email = data['profile']['email'];
          password = data['profile']['password'];
          major_name = data['profile']['major_name'];
          year = data['profile']['year'];
          level = data['profile']['level'];
          semester = data['profile']['semester_name'];
          college_name = data['profile']['college_name'];
        });
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontSize: 28, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
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
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Text(
                        '${fname.isNotEmpty ? fname[0] : ''}${lname.isNotEmpty ? lname[0] : ''}',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Personal Information',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  _buildProfileRow(Icons.person, 'Full Name', '$fname $lname'),
                  _buildProfileRow(Icons.email, 'Email', email),
                  _buildProfileRow(Icons.lock, 'Password', password),
                  const SizedBox(height: 20),
                  Text(
                    'Academic Information',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  _buildProfileRow(Icons.school, 'Major', major_name),
                  _buildProfileRow(Icons.calendar_today, 'Year', year),
                  _buildProfileRow(Icons.ad_units_outlined, 'Level', level),
                  _buildProfileRow(Icons.date_range, 'Semester', semester),
                  _buildProfileRow(
                      Icons.account_balance, 'College', college_name),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Space between rows
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 15),
          Text(
            '$label:',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
