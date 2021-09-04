import 'package:attendee/pages/profilePage.dart';
import 'package:attendee/pages/scanQRcode.dart';
import 'package:attendee/services/authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../getExactLocation.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<DrawerPage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;

  final AuthenticationService _auth = AuthenticationService();

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
  }

  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('students')
              .doc(FirebaseAuth.instance.currentUser.uid)
              .snapshots(),
          builder: (_, snap) {
            try {
              //name = snap.data.data()['fullname'];
              if (!snap.hasData) return LinearProgressIndicator();
              return ListTile(
                  title: Text('${snap.data.data()['fullname']}',
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
        stream: FirebaseFirestore.instance
            .collection('students')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .snapshots(),
        builder: (_, snap) {
          try {
            if (!snap.hasData) return LinearProgressIndicator();
            return ShaderMask(
              child: ListTile(
                title: Text('${snap.data.data()['email']}',
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
                  colors: [Colors.orange[800], Colors.white, Colors.green[800]],
                ).createShader(rect);
              },
            );
          } catch (e) {
            return CircularProgressIndicator();
          }
        },
      ),
      decoration: BoxDecoration(color: const Color(0xDD000000)),
    );
    //print('$result testing outside');
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(Icons.perm_identity_outlined, color: Colors.black),
              Text('Profile', style: TextStyle(color: Colors.black)),
            ],
          ),
          //onTap: () => Navigator.of(context).push(_NewPage(1)),
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
          //onTap: () => Navigator.of(context).push(_NewPage(1)),
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => GetExactLocation())),
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
    return Container(child: Drawer(child: drawerItems));
  }
}
