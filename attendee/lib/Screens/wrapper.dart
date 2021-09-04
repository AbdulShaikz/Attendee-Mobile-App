import 'package:attendee/constants.dart';
import 'package:attendee/dashboard.dart';
import 'package:attendee/pages/homepage.dart';
import 'package:attendee/pages/login.dart';
import 'package:attendee/models/user.dart';
import 'package:attendee/pages/studentDashboard.dart';
import 'package:attendee/pages/tutorDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:attendee/services/authentication_service.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final firebaseUser = context.watch<User>();
    final user = Provider.of<Users>(context);
    if (user == null)
      return Homepage();
    else
      return Homepage(); // return homepage or authentication
  }
}
