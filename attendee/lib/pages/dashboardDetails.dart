import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:attendee/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClassesDetails extends StatefulWidget {
  @override
  _ClassesDetails createState() => _ClassesDetails();
}

class _ClassesDetails extends State<ClassesDetails> {
  //String uid = Firebase
  String user = isTutor ? 'tutors' : 'students';
  String field = isTutor ? 'Subjects' : 'Attendance';
  final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
      .collection(isTutor ? 'tutors' : 'students')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: StreamBuilder(
        stream: _usersStream,
        builder: (_, snapshot) {
          try {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return Column(
              children: <Widget>[
                ListTile(
                  title: Row(children: <Widget>[
                    Expanded(
                        child: Text(
                      "Subjects",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                    Expanded(
                        child: Text(
                      "Number Of Classes",
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                  ]),
                ),
                Expanded(
                  child: ListView(
                    children:
                        (snapshot.data.get('Subjects') as Map<String, dynamic>)
                            .entries
                            .map((MapEntry mapEntry) {
                      return ListTile(
                          title: Text(mapEntry.key),
                          trailing: Text(mapEntry.value.toString()));
                    }).toList(),
                  ),
                ),
              ],
            );
          } catch (e) {
            return Container(
                child: Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    "No data available!",
                    textStyle:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 4,
                pause: const Duration(milliseconds: 500),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
            ));
          }
        },
      ),
    );
  }
}
