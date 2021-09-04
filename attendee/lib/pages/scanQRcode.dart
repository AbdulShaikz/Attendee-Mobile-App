import 'dart:async';

import 'package:attendee/Screens/success.dart';
import 'package:attendee/constants.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String qrCodeResult = "Not Yet Scanned";
  String uid = FirebaseAuth.instance.currentUser.uid;

  CollectionReference student_details;
  final CollectionReference tutor_details =
      FirebaseFirestore.instance.collection("tutors");
  final CollectionReference CollectionAttendanceDetails =
      FirebaseFirestore.instance.collection('attendance');

  var totalClassesAttended = 1;
  bool errorOccurred = false;
  String timeString;
  Timer timer;

  String stuName;
  String rollno;
  String subject;
  String id;
  var address;
  // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);

  final String formatted = DateFormat('dd-MM-yyyy').format(DateTime.now());

  void _getTime() {
    final String formattedDateTime =
        DateFormat('yyyy-MM-dd \n kk:mm:ss').format(DateTime.now()).toString();
    //DateFormat('yyyy-MM-dd').toString();
    setState(() {
      timeString = formattedDateTime;
    });
  }

  // Position position;
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    var lastPosition = await Geolocator.getLastKnownPosition();
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var adresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    print(lastPosition);

    setState(() {
      // locationMessage =
      //     "Lattitude : ${position.latitude} Longitude : ${position.longitude}";
      //address1 = adresses.first.featureName;
      address = adresses.first.addressLine;
    });
    // print("Address1 :$address1 \nAddress2 : $address2");
  }

  @override
  void initState() {
    student_details = FirebaseFirestore.instance.collection('students');
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
    var classesAttended;
    String actualTime;
    var timeStamp;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("Scanner", style: TextStyle(color: Colors.lightGreen)),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Result",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              qrCodeResult,
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            MaterialButton(
              color: Colors.black87,
              minWidth: double.infinity,
              height: 60,
              padding: EdgeInsets.all(15.0),
              onPressed: () async {
                try {
                  await getCurrentLocation();
                  String codeSanner = await BarcodeScanner.scan();

                  //barcode scnner
                  if (!mounted) return;
                  setState(() {
                    qrCodeResult = codeSanner;
                  });
                  timeStamp = student_details.doc(uid).get().then((value) {
                    return value.data()['TimeStamp'];
                  });
                  actualTime = DateFormat.jm().format(DateTime.now());
                  print(
                      "TimeStamp : ${timeStamp} \n Actual Time : $actualTime");
                  if (qrCodeResult != "" ||
                      qrCodeResult != 'Validity Expired' ||
                      timeStamp != actualTime) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => entrySuccessful()));
                    print('Qr code is $qrCodeResult');
                    int index = qrCodeResult.indexOf('-');
                    subject = await qrCodeResult.substring(
                        index + 1, qrCodeResult.length);
                    id = await qrCodeResult.substring(0, index);
                    errorOccurred = false;
                  } else {
                    errorOccurred = true;
                  }
                } catch (e) {
                  print(
                      '$e is the exception'); // we can print that user has denied for the permisions
                  print('$e is the exception');
                  errorOccurred =
                      true; //we can print on the page that user has cancelled
                }
                //position = await getLocation();
                if (errorOccurred == false) {
                  rollno = await student_details.doc(uid).get().then((doc) {
                    return doc.data()['rollno'];
                  });
                  stuName = await student_details.doc(uid).get().then((doc) {
                    return doc.data()['fullname'];
                  });
                  // await getCurrentLocation();
                  await student_details.doc(uid).get().then((doc) async {
                    Map<String, dynamic> stuMap = await doc.data();
                    print("$stuMap firstly");
                    if (!stuMap.containsKey('Subjects')) {
                      print("Hello");
                      await student_details.doc(uid).set({
                        'Subjects': {subject: 0},
                        'TotalClassesAttended': 0,
                      }, SetOptions(merge: true));
                    }
                  });

                  classesAttended =
                      await student_details.doc(uid).get().then((doc) async {
                    Map<String, dynamic> map = await doc.data();
                    if (map.containsKey('Subjects')) {
                      Map<String, dynamic> stuMap2 =
                          await doc.data()['Subjects'];
                      if (!stuMap2.containsKey(subject)) {
                        await student_details.doc(uid).set({
                          'Subjects': {subject: 0}
                        }, SetOptions(merge: true));
                      }
                    }
                    var val = await doc.data()['Subjects'][subject];
                    return val;
                    //return value.data()['noOfClassesAttended'];
                  });
                  print("$classesAttended is classesAttended ");
                  classesAttended =
                      await classesAttended == null ? 0 : classesAttended;

                  totalClassesAttended =
                      await student_details.doc(uid).get().then((doc) async {
                    // Map<String, dynamic> classesMap = await doc.data();
                    // print('${classesMap.toString()} is the classesMap');
                    // if (!classesMap.containsKey('TotalClassesAttended')) {
                    //   await student_details.doc(uid).set(
                    //       {'TotalClassesAttended': 1}, SetOptions(merge: true));
                    // }
                    var val = await doc.data()['TotalClassesAttended'];
                    return val;
                  });

                  totalClassesAttended = await totalClassesAttended == null
                      ? 1
                      : totalClassesAttended;

                  if (!mounted) return;
                  setState(() {
                    //qrCodeResult = codeSanner;
                    scanned = true;
                    // if (temp != codeSanner) {
                    classesAttended += 1;
                    totalClassesAttended += 1;
                    //temp = codeSanner;
                    // DatabaseService().attendance(
                    //     auth.currentUser.displayName, timeString, '1');
                  });

                  await CollectionAttendanceDetails.doc(formatted)
                      .collection("Today's Tutors")
                      .doc(id)
                      .set({
                    rollno: {
                      'Name': '$stuName',
                      subject: classesAttended,
                      'TotalClassesAttended': totalClassesAttended,
                      'Location': address,
                    },
                  }, SetOptions(merge: true));

                  await student_details.doc(uid).set({
                    'Subjects': {subject: classesAttended},
                    'TotalClassesAttended': totalClassesAttended,
                    'tutorid': id,
                    'TimeStamp': actualTime,
                  }, SetOptions(merge: true));

                  print('$formatted is formatted');
                } else {
                  if (actualTime == timeStamp) {
                    showToast("Already marked as Present for $subject class!",
                        Colors.redAccent, Colors.white, Toast.LENGTH_LONG);
                  } else {
                    showToast("Something went wrong!", Colors.redAccent,
                        Colors.white, Toast.LENGTH_LONG);
                  }
                  //errorOccurred = false;
                }
              },
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.green,
                  ),
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                "Scan QR",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.lightGreen),
              ),
            )
          ],
        ),
      ),
    );
  }
}
