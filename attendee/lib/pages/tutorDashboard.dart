import 'package:attendee/constants.dart';
import 'package:attendee/pages/allStudents.dart';
import 'package:attendee/pages/dashboardDetails.dart';
import 'package:attendee/pages/generateQR.dart';
import 'package:attendee/pages/generateQRcode.dart';
import 'package:attendee/models/userdeails.dart';
import 'package:attendee/pages/helpStudent.dart';
import 'package:attendee/pages/profile.dart';
import 'package:attendee/pages/profilePage.dart';
import 'package:attendee/pages/scanQE.dart';
import 'package:attendee/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:attendee/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendee/pages/userdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorDashboard extends StatefulWidget {
  @override
  _TutorDashboardState createState() => _TutorDashboardState();
}

class _TutorDashboardState extends State<TutorDashboard>
    with SingleTickerProviderStateMixin {
  userdetails userdetail;
  SharedPreferences logindata;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final AuthenticationService _auth = AuthenticationService();

  AnimationController animationController;
  Animation animation;

  void initial() async {
    logindata = await SharedPreferences.getInstance();
  }

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
    //initial();
  }

  @override
  Widget build(BuildContext context) {
    String accountType = isTutor ? 'tutors' : 'students';

    final Shader linearGradient = LinearGradient(
      colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(accountType);
    String uid = _firebaseAuth.currentUser.uid;

    final drawerHeader = UserAccountsDrawerHeader(
      accountName: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tutors')
              .doc(uid)
              .snapshots(),
          builder: (_, snap) {
            try {
              if (!snap.hasData) return LinearProgressIndicator();
              return ListTile(
                  title: Text(
                '${snap.data.data()['fullname']}',
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 16,
                ),
              ));
            } catch (e) {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      accountEmail: //Text('${DatabaseService().getData('emailid')}'),
          StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tutors')
            .doc(uid)
            .snapshots(),
        builder: (_, snap) {
          try {
            if (!snap.hasData) return LinearProgressIndicator();
            return ListTile(
              title: ShaderMask(
                child: Text(
                  '${snap.data.data()['email']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    //foreground: Paint()..shader = linearGradient,
                  ),
                ),
                shaderCallback: (rect) {
                  return LinearGradient(
                    stops: [
                      animation.value - 0.4,
                      animation.value,
                      animation.value + 0.4,
                    ],
                    colors: [
                      Colors.orange[800],
                      Colors.white,
                      Colors.green[800]
                    ],
                  ).createShader(rect);
                },
              ),
            );
          } catch (e) {
            return CircularProgressIndicator();
          }
        },
      ),
      decoration: BoxDecoration(color: const Color(0xDD000000)),
      // currentAccountPicture: CircleAvatar(
      //   child: FlutterLogo(size: 42.0),
      //   backgroundColor: Colors.white,
      // ),
      // otherAccountsPictures: <Widget>[
      //   CircleAvatar(
      //     child: Text('A'),
      //     backgroundColor: Colors.yellow,
      //   ),
      //   CircleAvatar(
      //     child: Text('B'),
      //     backgroundColor: Colors.red,
      //   )
      // ],
    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(
                Icons.perm_identity_outlined,
                color: Colors.black,
              ),
              Text(
                'Profile',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          //onTap: () => Navigator.of(context).push(_NewPage(1)),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ProfileView())),
        ),
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(Icons.qr_code_rounded, color: Colors.black),
              Text(
                'Generate QR',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => GeneratePage())),
        ),
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(
                Icons.group_rounded,
                color: Colors.black,
              ),
              Text(
                'My Students',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AllStudents())),
        ),
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(
                Icons.app_registration,
                color: Colors.black,
              ),
              Text(
                'Manual Entry',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HelpStudent())),
        ),
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(
                Icons.exit_to_app_rounded,
                color: Colors.black,
              ),
              Text(
                ' Logout',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          onTap: () async {
            await _auth.signOut();
            Navigator.of(context).pushNamed('/homepage');
          },
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          'Tutor Dashboard',
          style: TextStyle(color: Colors.lightGreen),
        ),
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
      body: //Center(
          // Container(),
          ClassesDetails(),
      //),

      drawer: Drawer(
        child: drawerItems,
      ),
    );
  }
}
