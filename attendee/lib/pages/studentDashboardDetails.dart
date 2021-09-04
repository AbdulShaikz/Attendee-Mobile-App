import 'package:attendee/pages/dashboardDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentClassesDetails extends StatefulWidget {
  @override
  _ClassesDetails createState() => _ClassesDetails();
}

class _ClassesDetails extends State<StudentClassesDetails> {
  // final Stream<QuerySnapshot> _usersStream =
  //     FirebaseFirestore.instance.collection('students').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text("Attendance Details",
              style: TextStyle(color: Colors.lightGreen)),
          centerTitle: true,
        ),
        body: ClassesDetails());
  }
}
