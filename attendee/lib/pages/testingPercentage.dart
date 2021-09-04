import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TestingPercentage extends StatefulWidget {
  @override
  _TestingPercentageState createState() => _TestingPercentageState();
}

class _TestingPercentageState extends State<TestingPercentage> {
  Stream students_stream;

  final CollectionReference student_details =
      FirebaseFirestore.instance.collection('students');
  final CollectionReference tutor_details =
      FirebaseFirestore.instance.collection("tutors");
  final CollectionReference CollectionAttendanceDetails =
      FirebaseFirestore.instance.collection('attendance');

  dynamic percentage = 0.0;
  var roundedPercentage;
  var id;
  var cTook;
  var prevCTook;
  var cAttended;

  final String formatted = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    students_stream =
        student_details.doc(FirebaseAuth.instance.currentUser.uid).snapshots();
  }

  displayPercentage() {
    roundedPercentage = double.parse((percentage).toStringAsFixed(2));
    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 13.0,
      animation: true,
      percent: percentage,
      center: Text(
        "${roundedPercentage * 100.0}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      footer: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Text(
          "Attendance Percentage",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.purple,
    );
  }

  streamOfPercentage() {
    return StreamBuilder<QuerySnapshot>(
        stream: CollectionAttendanceDetails.doc(formatted)
            .collection("Today's Tutors")
            .snapshots(),
        builder: (_, snap) {
          // if (!snap.hasData) {
          //   return CircularProgressIndicator(); // or place here percentage = 0.0
          // }
          if (snap.hasError) {
            return Text("Something went wrong!");
          }
          if (snap.hasData) {
            var ds = snap.data.docs;
            double sum = 0.0;
            for (int i = 0; i < ds.length; i++)
              sum += (ds[i]['TotalClassesTook']).toDouble();
            if (prevCTook != cTook) {
              student_details
                  .doc(FirebaseAuth.instance.currentUser.uid)
                  .set({'TotalClasses': sum}, SetOptions(merge: true));
              prevCTook = cTook;
            }
          }
          return displayPercentage();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
          stream: students_stream,
          builder: (_, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) percentage = 0.0;
            if (snapshot.hasData) {
              try {
                id = snapshot.data['tutorid'];
                print('This is id :$id');
                cAttended = snapshot.data['TotalClassesAttended'];
                cTook = snapshot.data['TotalClasses'];
                cAttended = snapshot.data['TotalClassesAttended'];
                percentage = ((cAttended / cTook) * 100.0) / 100;
                print("Percentage  $percentage");
                print("TCT :$cTook  TCA:$cAttended");

                return streamOfPercentage();
              } catch (e) {
                cAttended = 0;
              }
            }
            return displayPercentage();
            //return Container();
          }),
    );
  }
}
