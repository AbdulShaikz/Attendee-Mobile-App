import 'package:attendee/models/userdeails.dart';
import 'package:attendee/pages/userdetails.dart';
import 'package:attendee/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllStudents extends StatefulWidget {
  @override
  _AllStudentsState createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<userdetails>>.value(
      value: DatabaseService().students,
      initialData: [],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.black87,
            title: Text(
              'My Students',
              style: TextStyle(color: Colors.lightGreen),
            ),
            actions: <Widget>[],
          ),
          body: //Center(
              UserDetails(),
        ),
      ),
    );
  }
}
