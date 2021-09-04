import 'package:attendee/constants.dart';
import 'package:attendee/getExactLocation.dart';
import 'package:attendee/models/userdeails.dart';
import 'package:attendee/pages/dashboardDetails.dart';
import 'package:attendee/pages/displayPercentage.dart';
import 'package:attendee/pages/profilePage.dart';
import 'package:attendee/pages/scanQRcode.dart';
import 'package:attendee/pages/studentDashboardDetails.dart';
import 'package:attendee/pages/testingPercentage.dart';
import 'package:attendee/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

String name;

class _StudentDashboardState extends State<StudentDashboard>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;

  userdetails userdetail;
  bool _loadOnce = true;

  String res;
  SharedPreferences logindata;
  bool login;
  bool type;
  var prevId;
  var prevTcT = 0;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final AuthenticationService _auth = AuthenticationService();

  final CollectionReference student_details =
      FirebaseFirestore.instance.collection('students');
  final CollectionReference tutor_details =
      FirebaseFirestore.instance.collection("tutors");
  final CollectionReference CollectionAttendanceDetails =
      FirebaseFirestore.instance.collection('attendance');

  String uid = FirebaseAuth.instance.currentUser.uid;
  Stream students_stream;

  final String formatted = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1400));
    animationController.repeat(reverse: true);
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    //animationController.forward();
    super.initState();
    students_stream =
        student_details.doc(FirebaseAuth.instance.currentUser.uid).snapshots();
    // initial();
    //Future<String> res = DatabaseService().getData('email');
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
  }

  header() {
    return UserAccountsDrawerHeader(
      accountName: StreamBuilder(
          stream: students_stream,
          builder: (_, snap1) {
            try {
              //name = snap1.data['fullname'];
              if (!snap1.hasData) return LinearProgressIndicator();
              return ListTile(
                  title: Text('${snap1.data['fullname']}',
                      style: TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 16,
                      )));
            } catch (e) {
              return CircularProgressIndicator();
            }
          }),
      accountEmail: //Text('${DatabaseService().getData('emailid')}'),
          StreamBuilder(
        stream: students_stream,
        builder: (_, snap2) {
          try {
            if (!snap2.hasData)
              return LinearProgressIndicator();
            else {
              return ShaderMask(
                child: ListTile(
                  title: Text('${snap2.data['email']}',
                      style: TextStyle(
                          //color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                //foreground: Paint()..shader = linearGradient),
                shaderCallback: (rect) {
                  return LinearGradient(
                    stops: [
                      animation.value - 0.45,
                      animation.value,
                      animation.value + 0.45,
                    ],
                    colors: [
                      Colors.orange[800],
                      Colors.white,
                      Colors.green[800]
                    ],
                  ).createShader(rect);
                },
              );
            }
          } catch (e) {
            return CircularProgressIndicator();
          }
        },
      ),
      decoration: BoxDecoration(color: const Color(0xDD000000)),
    );
  }

  items() {
    return ListView(
      children: <Widget>[
        header(),
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(Icons.perm_identity_outlined, color: Colors.black),
              Text('Profile', style: TextStyle(color: Colors.black)),
            ],
          ),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ProfileView())),
        ),
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(Icons.details_rounded, color: Colors.black),
              Text('Attendance Details', style: TextStyle(color: Colors.black)),
            ],
          ),
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => StudentClassesDetails())),
        ),
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(Icons.qr_code_scanner_rounded, color: Colors.black),
              Text('Scan QR', style: TextStyle(color: Colors.black)),
            ],
          ),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ScanPage())),
        ),
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(Icons.exit_to_app_rounded, color: Colors.black),
              Text('Logout', style: TextStyle(color: Colors.black)),
            ],
          ),
          onTap: () async {
            await _auth.signOut();
            Navigator.of(context).pushNamed('/homepage');
          },
        ),
      ],
    );
  }

  // displayPercentage() {
  //   var totalCT = students_stream.map((event) { return event.data['TotalClasses'];});
  //   var totalCA = students_stream.map((event) { return event.data['TotalClassesAttended'];});
  //   var percent = ((totalCA/totalCT) * 100.0) / 100;
  //   var roundPercentage = double.parse((percent.toStringAsFixed(2));
  //   return CircularPercentIndicator(
  //     radius: 120.0,
  //     lineWidth: 13.0,
  //     animation: true,
  //     percent: percent,
  //     center: Text(
  //       "${roundPercentage * 100.0}",
  //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
  //     ),
  //     footer: Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
  //       child: Text(
  //         "Attendance Percentage",
  //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
  //       ),
  //     ),
  //     circularStrokeCap: CircularStrokeCap.round,
  //     progressColor: Colors.purple,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    String uid = _firebaseAuth.currentUser.uid;
    String accountType = isTutor ? 'tutors' : 'students';
    //drawerOpened = false;
    //final drawerHeader = header();
    //print('$result testing outside');
    final drawerItems = items();
    return Container(
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black87,
              title: Text('Student Dashboard',
                  style: TextStyle(color: Colors.lightGreen)),
              actions: <Widget>[
                TextButton.icon(
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.of(context).pushNamed('/homepage');
                      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Homepage()));
                    },
                    icon: Icon(
                      Icons.person,
                      color: Colors.green,
                    ),
                    label: Text(
                      'Logout',
                      style: TextStyle(color: Colors.green),
                    ))
              ],
            ),
            drawer: Drawer(
              child: drawerItems,
            ),
            onDrawerChanged: (isOpen) {
              drawerOpened = true;
              print("DrawerOpened in Dashboard : $drawerOpened");
              print(isOpen);
              if (isOpen == false) drawerOpened = false;
            },
            body: drawerOpened == true ? Container() : TestingPercentage()),
      ),
    );
  }
}
