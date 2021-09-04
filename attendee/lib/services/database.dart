import 'package:attendee/models/userdeails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../constants.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference student_details =
      FirebaseFirestore.instance.collection('students');
  final CollectionReference tutor_details =
      FirebaseFirestore.instance.collection("tutors");
  final DocumentReference attendanceDetails = FirebaseFirestore.instance
      .collection("attendance")
      .doc(DateFormat('dd-MM-yyyy').format(DateTime.now()));
  final CollectionReference CollectionAttendanceDetails =
      FirebaseFirestore.instance.collection('attendance');

  CollectionReference reference = isTutor
      ? FirebaseFirestore.instance.collection("tutors")
      : FirebaseFirestore.instance.collection('students');

  FirebaseAuth auth = FirebaseAuth.instance;

  Future updateStudentData(
      String fullname,
      String mobilenumber,
      String email,
      String rollno,
      String tutorid,
      String role,
      int TotalClasses,
      int TotalClassesAttended) async {
    return await student_details.doc(uid).set({
      'role': role,
      'fullname': fullname,
      'mobilenumber': mobilenumber,
      'email': email,
      'rollno': rollno,
      'tutorid': tutorid,
      //'noOfClassesAttended': attendance,
      'TotalClasses': 0,
      'TotalClassesAttended': 0,
      'TimeStamp': null, //FMERT series
    });
  }

  Future updateAndAddStudentData(var attendance) async {
    return await student_details.doc(uid).set(
      {'attendance': attendance},
      SetOptions(merge: true),
    );
  }

  Future updateAndAddTutorData(var numberOfClasses) async {
    return await tutor_details
        .doc(uid)
        .set({'numberOfClasses': numberOfClasses}, SetOptions(merge: true));
  }

  Future updateTutorData(String fullname, String mobilenumber, String email,
      String rollno, String tutorid, String role, int numberOfClasses) async {
    return await tutor_details.doc(uid).set({
      'fullname': fullname,
      'mobilenumber': mobilenumber,
      'email': email,
      'rollno': rollno,
      'tutorid': tutorid,
      'role': role,
      // 'Subjects': numberOfClasses, //FMERT series
    });
  }

  Future attendance() async {
    final String formatted = DateFormat('dd-MM-yyyy').format(DateTime.now());

    Map<String, String> map = {
      //'dateTime': [formattedDate],//FDI series
    };
    //await attendanceDetails.update(map);
    return await CollectionAttendanceDetails.doc(formatted).set({});
  }

  List<userdetails> _studentDetailsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return userdetails(
        fullname: doc.data()['fullname'] ?? '',
        mobilenumber: doc.data()['mobilenumber'] ?? '',
        email: doc.data()['email'] ?? '',
        rollno: doc.data()['rollno'] ?? '',
        tutorid: doc.data()['tutorid'] ?? '',
        //role: doc.data()['role'] ?? '',
      );
    }).toList();
  }

  //get students stream
  Stream<List<userdetails>> get students {
    return student_details.snapshots().map(_studentDetailsFromSnapshot);
  }

  //tutorsDetails from snapshot
  List<userdetails> _tutorDetailsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return userdetails(
        fullname: doc.data()['fullname'] ?? '',
        mobilenumber: doc.data()['mobilenumber'] ?? '',
        email: doc.data()['email'] ?? '',
        rollno: doc.data()['rollno'] ?? '',
        tutorid: doc.data()['tutorid'] ?? '',
      );
    }).toList();
  }

  //get tutors stream
  Stream<List<userdetails>> get tutors {
    return student_details
        .snapshots()
        .map(_tutorDetailsFromSnapshot); //pehle tha _studentDetailsFromSnapshot
  }

  void display() {
    tutor_details.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
      });
    });
  }

  dynamic getData(String string) async {
    String userId = await FirebaseAuth.instance.currentUser.uid;
    final document = isTutor
        ? FirebaseFirestore.instance.doc('tutors/$userId')
        : await FirebaseFirestore.instance.doc(
            'students/$userId'); //can also add await before FirebaseFirestore
    document.get().then((DocumentSnapshot) async {
      if (string == 'role') {
        checkRole = DocumentSnapshot.data()[string].toString();
        print('$checkRole inside getData Function');
        //return checkRole;
        print(checkRole);
        return DocumentSnapshot.data()[string].toString();
      } else {
        //print(result);
        //result = DocumentSnapshot.data()[string].toString();
        print(
            '${DocumentSnapshot.data()[string].toString()} in the database else block');
        return DocumentSnapshot.data()[string].toString();
      }
      //print(document("name"));
    });
  }
}
