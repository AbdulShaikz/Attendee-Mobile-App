import 'package:attendee/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:attendee/models/user.dart';
import 'package:flutter/material.dart';
import 'package:attendee/constants.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference student_details =
      FirebaseFirestore.instance.collection('students');
  final CollectionReference tutor_details =
      FirebaseFirestore.instance.collection("tutors");

  Users _userFromFirebaseUser(User user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<Users> get userstream {
    return _firebaseAuth.authStateChanges().map(_userFromFirebaseUser);
    //.map((User user)=> _userFromFirebaseUser(user)); same
  }

  Future<String> getCurrentUID() async {
    return (await _firebaseAuth.currentUser.uid);
  }

  Future signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      //User user;
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = userCredential.user;
      // if (!userCredential.user.emailVerified) {
      //   Navigator.of(context).pushReplacement(
      //       MaterialPageRoute(builder: (context) => VerifyScreen()));
      // } else {
      //   user = userCredential.user;
      // }

      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emessage = e.message;
      } else if (e.code == 'wrong-password') {
        emessage = e.message;
      }
    }
  }

  Future registerWithEmailAndPassword(
      String email,
      String password,
      String name,
      String mobilenumber,
      String rollno,
      String tutorid,
      String role,
      BuildContext context) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //if(userCredential.user.emailVerified)
      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>VerifyScreen()));
      User user = userCredential.user;
      //usersaved = user;
      //creating document for the user with uid
      await !isTutor
          ? DatabaseService(uid: user.uid).updateStudentData(
              name, mobilenumber, email, rollno, tutorid, role, 0, 0)
          : DatabaseService(uid: user.uid).updateTutorData(
              name, mobilenumber, email, rollno, tutorid, role, 0);
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emessage = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        emessage = "The account already exists for that email.";
      }
    } catch (e) {
      print(e);
    }
  }

  Future signOut() async {
    try {
      // userName = "";
      return await _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
