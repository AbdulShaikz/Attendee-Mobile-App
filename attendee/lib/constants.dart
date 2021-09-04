import 'package:attendee/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

bool isTutor = true;
bool scanned = false;
bool present = false;
bool drawerOpened = false;
String emessage = "";
//String userName = "";
String checkRole;
User usersaved;
dynamic result = 'hi';

Map<String, List<String>> mapIds = new Map();

void showToast(String msg, Color bgColor, Color textColor, Toast length) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: length,
    gravity: ToastGravity.BOTTOM_LEFT,
    timeInSecForIosWeb: 1,
    backgroundColor: bgColor,
    textColor: textColor,
    fontSize: 16.0,
  );
}
