import 'package:attendee/constants.dart';
import 'package:attendee/pages/editProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:attendee/models/userdeails.dart';

class ProfileView extends StatefulWidget {
  final userdetails userdetail;
  ProfileView({this.userdetail});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // var name, rollno, phonenumber, email, tutorid;
  @override
  Widget build(BuildContext context) {
    String user = isTutor ? "tutors" : "students";
    String uid = FirebaseAuth.instance.currentUser.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.lightGreen),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.lightGreen,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => EditProfile()));
        },
      ),
      body: Material(
        child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(user)
                .doc(uid)
                .snapshots(),
            builder: (_, snap) {
              if (!snap.hasData) return LinearProgressIndicator();
              if (user == "students") {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          title: Text(
                        'Fullname: ${snap.data.data()['fullname']}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      )),
                      ListTile(
                          title: Text(
                              'Roll Number: ${snap.data.data()['rollno']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0))),
                      ListTile(
                          title: Text('Email: ${snap.data.data()['email']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0))),
                      ListTile(
                          title: Text(
                              'Mobile Number: ${snap.data.data()['mobilenumber']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0))),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          title: Text(
                              'Fullname: ${snap.data.data()['fullname']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0))),
                      ListTile(
                          title: Text(
                              'Tutor Id: ${snap.data.data()['tutorid']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0))),
                      ListTile(
                          title: Text('Email: ${snap.data.data()['email']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0))),
                      ListTile(
                          title: Text(
                              'Mobile Number: ${snap.data.data()['mobilenumber']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0))),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
// return StreamProvider<List<userdetails>>.value(
//   value: DatabaseService().students,
//   initialData: [],
//   child: SafeArea(
//     child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.lightGreen,
//           title: Text('Profile'),
//           actions: <Widget>[
//             TextButton.icon(
//                 onPressed: () async {
//                   await _auth.signOut();
//                   Navigator.of(context).pushNamed('/homepage');
//                   //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Homepage()));
//                 },
//                 icon: Icon(Icons.person),
//                 label: Text('Logout'))
//           ],
//         ),
//         body: //Center(
//             ProfileDetails() // ,
//         //),
//         ),
//   ),
// );
