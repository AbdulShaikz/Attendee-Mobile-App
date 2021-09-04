import 'package:attendee/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TotalClasses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Stream documentStream = FirebaseFirestore.instance
        .collection('tutors')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots();
    return Container();
  }
}
