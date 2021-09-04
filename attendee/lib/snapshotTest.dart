// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class Display extends StatefulWidget {
//   @override
//   _DisplayState createState() => _DisplayState();
// }
//
// class _DisplayState extends State<Display> {
//   final CollectionReference student_details =
//       FirebaseFirestore.instance.collection('students');
//   final CollectionReference tutor_details =
//       FirebaseFirestore.instance.collection("tutors");
//   final CollectionReference CollectionAttendanceDetails =
//       FirebaseFirestore.instance.collection('attendance');
//   var id = "";
//   display() {
//     Stream stuDetails =  student_details.doc("m2Hdo5eejKWfIYlD2ZJvjYepWQh2").snapshots(),
//         builder: (_, snapshot) {
//           return snapshot.data['tutorid'];
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//       child: StreamBuilder(
//           stream: display(),
//           builder: (_, snapshot) {
//             if (!snapshot.hasData)
//               return CircularProgressIndicator();
//             else {
//               print(snapshot.connectionState);
//
//               return Center(
//                 child: Container(
//                   child: Text(id),
//                 ),
//               );
//             }
//           }),
//     ));
//   }
// }
