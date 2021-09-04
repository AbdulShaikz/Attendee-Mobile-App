import 'package:attendee/pages/studentDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  // storeNewUser(user, context) {
  //   FirebaseFirestore.instance.collection('/users').add({
  //     'email' : user.email,
  //     'uid' : user.uid,
  //   }).then((value) {
  //     //Navigator.of(context).pop();
  //   }).catchError((e){
  //     print(e);
  //   });
  // }
  // Widget handleAuth(){
  //   return new StreamBuilder(
  //     stream: FirebaseAuth.instance.authChanges(),
  //     builder: (BuildContext context, snapshot) {
  //       if (snapshot.hasData) {
  //         return NavDrawerExample();
  //       },
  //     },
  //   );
  // }
}
