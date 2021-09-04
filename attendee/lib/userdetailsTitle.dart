import 'dart:async';

import 'package:attendee/constants.dart';
import 'package:attendee/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:attendee/models/userdeails.dart';
import 'package:intl/intl.dart';

class userdetailsTile extends StatefulWidget {
  final userdetails userdetail;
  userdetailsTile({this.userdetail});

  @override
  _userdetailsTileState createState() => _userdetailsTileState();
}

class _userdetailsTileState extends State<userdetailsTile> {
  String rollnumber;

  String timeString;
  Timer timer;
  // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);

  void _getTime() {
    final String formattedDateTime =
        DateFormat('yyyy-MM-dd \n kk:mm:ss').format(DateTime.now()).toString();
    //DateFormat('yyyy-MM-dd').toString();
    setState(() {
      timeString = formattedDateTime;
    });
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   padding: EdgeInsets.only(top: 8.0),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: <Widget>[
    //       Card(
    //         //margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
    //         child: GestureDetector(
    //           child: ListTile(
    //             // leading: CircleAvatar(
    //             //   radius: 25.0,
    //             //   backgroundColor: Colors.lightGreen,
    //             // ),
    //             title: Text(userdetail.fullname),
    //           ),
    //         ),
    //       ),
    //       Switch(
    //         value: present,
    //         onChanged: (value) {
    //           //setState(() {
    //           present = value;
    //           print(present);
    //           //});
    //         },
    //         activeTrackColor: Colors.lightGreenAccent,
    //         activeColor: Colors.green,
    //       ),
    //       //),
    //     ],
    //   ),
    // );
    return Material(
      child: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: ListTile(
          // leading: CircleAvatar(
          //   radius: 25.0,
          //   backgroundColor: Colors.lightGreen,
          // ),
          title: Text(
            widget.userdetail.fullname,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          // trailing: Switch(
          //   value: present,
          //   onChanged: (value) async {
          //     // rollnumber = widget.userdetail.rollno;
          //     // await DatabaseService().attendance;
          //     setState(() {
          //       present = value;
          //       print(present);
          //       // DatabaseService().attendance();
          //     });
          //   },
          //   activeTrackColor: Colors.lightGreenAccent,
          //   activeColor: Colors.green,
          // ),
          subtitle: Text(widget.userdetail.rollno,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
