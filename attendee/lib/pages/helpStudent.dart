import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:intl/intl.dart';

class HelpStudent extends StatefulWidget {
  @override
  _HelpStudentState createState() => _HelpStudentState();
}

final RoundedLoadingButtonController _btnController =
    RoundedLoadingButtonController();
final CollectionReference CollectionAttendanceDetails =
    FirebaseFirestore.instance.collection('attendance');
TextEditingController roll = new TextEditingController();
TextEditingController Studentname = new TextEditingController();

markAsPresent(String rollNumber, String name) async {
  final String formatted = DateFormat('dd-MM-yyyy').format(DateTime.now());
  await CollectionAttendanceDetails.doc(formatted).set({
    '$rollNumber': {'name': name},
  }, SetOptions(merge: true));
  Timer(Duration(seconds: 3), () {
    _btnController.success();

    Timer(Duration(seconds: 1), () {
      _btnController.reset();
    });
  });
}

class _HelpStudentState extends State<HelpStudent> {
  @override
  Widget build(BuildContext context) {
    String rollNumber;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          'Manual Entry',
          style: TextStyle(color: Colors.lightGreen),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            roll.clear();
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            size: 20,
            color: Colors.green,
          ),
        ),
      ),
      body: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: new Material(
              child: SingleChildScrollView(
            child: new Container(
                padding: const EdgeInsets.all(30.0),
                color: Colors.white,
                child: new Container(
                  child: new Center(
                      child: new Column(children: [
                    new Padding(padding: EdgeInsets.only(top: 140.0)),
                    new Text(
                      'Manual Entry',
                      style: new TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 50.0)),
                    new TextFormField(
                      controller: roll,
                      decoration: new InputDecoration(
                        labelText: "Enter Roll Number",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "Field cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      //keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (String value) {
                        setState(() async {
                          roll.text = await value;
                          //this._password = value;
                        });
                      },
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 25.0)),
                    new TextFormField(
                      controller: Studentname,
                      decoration: new InputDecoration(
                        labelText: "Enter StudentName",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "Field cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      //keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (String value) {
                        setState(() async {
                          Studentname.text = await value;
                          //this._password = value;
                        });
                      },
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 50.0)),
                    RoundedLoadingButton(
                      color: Colors.black87,
                      child: Text('Present',
                          style: TextStyle(
                              color: Colors.lightGreen, fontSize: 18.0)),
                      controller: _btnController,
                      onPressed: () {
                        markAsPresent(roll.text, Studentname.text);
                      },
                    )
                  ])),
                )),
          ))),
    );
  }
}
