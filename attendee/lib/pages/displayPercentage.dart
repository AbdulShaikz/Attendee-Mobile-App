import 'package:attendee/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DisplayPercentage extends StatefulWidget {
  @override
  _DisplayPercentageState createState() => _DisplayPercentageState();
}

class _DisplayPercentageState extends State<DisplayPercentage> {
  Stream students_stream;

  final CollectionReference student_details =
      FirebaseFirestore.instance.collection('students');
  final CollectionReference tutor_details =
      FirebaseFirestore.instance.collection("tutors");
  final CollectionReference CollectionAttendanceDetails =
      FirebaseFirestore.instance.collection('attendance');

  var prevId;
  var prevTcT = 0;
  dynamic percentage = 0.0;

  final String formatted = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    students_stream =
        student_details.doc(FirebaseAuth.instance.currentUser.uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
          stream: students_stream,
          builder: (_, AsyncSnapshot snapshot) {
            var id;
            var tCA;
            var tCT;
            var tC;
            var dif = 0;
            if (!snapshot.hasData) return LinearProgressIndicator();
            try {
              id = snapshot.data['tutorid'];
              print('This is id :$id');
              tCA = snapshot.data['TotalClassesAttended'];
            } catch (e) {
              tCA = 0;
            }

            try {
              if (snapshot.hasData) {
                print("DrawerOpened : $drawerOpened");

                return StreamBuilder(
                    stream: CollectionAttendanceDetails.doc(formatted)
                        .collection(id)
                        .doc(id)
                        .snapshots(),
                    builder: (_, snap) {
                      if (!snap.hasData) CircularProgressIndicator();
                      //print(snap.connectionState);
                      if (snap.hasData) {
                        try {
                          tCT = snap.data['TotalClassesTook'];
                          tC = snapshot.data['TotalClasses'];
                          if (tC == 0 ||
                              prevId == null ||
                              prevId == id ||
                              prevTcT != tCT) {
                            //snapshot.data['TotalClasses'] = tCT;
                            dif = (tCT - prevTcT);
                            dif = dif.abs();
                            tC = tC + dif;
                            student_details
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .set({'TotalClasses': tCT},
                                    SetOptions(merge: true));
                          } else {
                            if (prevId != null && prevId != id) {
                              StreamBuilder(
                                stream:
                                    CollectionAttendanceDetails.doc(formatted)
                                        .collection(prevId)
                                        .doc(prevId)
                                        .snapshots(),
                                builder: (_, prevSnap) {
                                  if (!prevSnap.hasData) {
                                    CircularProgressIndicator();
                                  } else {
                                    tC = prevSnap.data['TotalClassesTook'] +
                                        snap.data['TotalClassesTook'];
                                    student_details
                                        .doc(FirebaseAuth
                                            .instance.currentUser.uid)
                                        .set({'TotalClasses': tC},
                                            SetOptions(merge: true));
                                  }
                                },
                              );
                            } else {
                              tC = snapshot.data['TotalClasses'];
                              student_details
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .set({'TotalClasses': tC},
                                      SetOptions(merge: true));
                              //   snapshot.data['TotalClasses'] += dif;
                              tC = snapshot.data['TotalClasses'];
                              print("TC is $tC");
                            }
                          }
                          print("TCT : $tCT\nTCA : $tCA");
                          percentage = ((tCA / tC) * 100) / 100;
                          prevTcT = snap.data['TotalClassesTook'];
                        } catch (e) {
                          if (snapshot.data['TotalClasses'] != 0) {
                            var cTook = snapshot.data['TotalClasses'];
                            var cAttended =
                                snapshot.data['TotalClassesAttended'];
                            percentage = ((cAttended / cTook) * 100.0) / 100;
                            print("Percentage  $percentage");
                          } else {
                            print(e);
                            tCT = 0;
                            percentage = 0.0;
                          }
                        }
                      }
                      percentage =
                          double.parse((percentage).toStringAsFixed(2));

                      prevId = id;
                      print("Previous Id : $prevId");
                      return CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 13.0,
                        animation: true,
                        percent: percentage,
                        center: new Text(
                          "${percentage * 100.0}",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        footer: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: new Text(
                            "Attendance Percentage",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.purple,
                      );
                    });
              }
            } catch (e) {
              return Text("No data available because of $e");
            }
            return Text("No data available! ");
          }),
    );
  }
}
