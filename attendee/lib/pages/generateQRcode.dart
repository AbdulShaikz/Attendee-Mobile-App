import 'dart:async';

import 'dart:io';
import 'dart:typed_data';

import 'package:attendee/animation/FadeAnimation.dart';
import 'package:attendee/constants.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:share/share.dart';

class GeneratePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GeneratePageState();
}

class GeneratePageState extends State<GeneratePage> {
  String qrData = ""; // already generated qr code when the page opens
  FirebaseAuth auth = FirebaseAuth.instance;
  String subject;
  String idd;
  dynamic size;
  String tutorId;
  var initialValue = 0;
  var totalClassesTook = 0;

  GlobalKey globalKey = new GlobalKey();

  final CollectionReference student_details =
      FirebaseFirestore.instance.collection('students');
  CollectionReference tutor_details;
  final CollectionReference CollectionAttendanceDetails =
      FirebaseFirestore.instance.collection('attendance');

  Timer timer;
  String timeString;
  bool tp = false;
  bool _validate = false;
  String temp;
  String dropdownValue = "None";
  String rangeDropdownValue = "Default";
  dynamic range = 400.0;
  // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
  String user = isTutor ? "tutors" : "students";
  String uid = FirebaseAuth.instance.currentUser.uid;

  final String formatted = DateFormat('dd-MM-yyyy').format(DateTime.now());

  final DocumentReference documentReference = FirebaseFirestore.instance
      .collection('students')
      .doc(FirebaseAuth.instance.currentUser.uid);

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
    tutor_details = FirebaseFirestore.instance.collection("tutors");
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  setValidity() {
    Timer val;
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Validity",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
            if (qrdataFeed.text.isNotEmpty) {
              if (newValue == '10 secs') {
                if (val != null) val.cancel();
                val = Timer(Duration(seconds: 10), () {
                  setState(() {
                    qrData = 'Validity Expired';
                    qrdataFeed.clear();
                  });
                  showToast("QR code has expired!", Colors.black, Colors.green,
                      Toast.LENGTH_SHORT);
                });
              } else if (newValue == '30 secs') {
                if (val != null) val.cancel();
                val = Timer(Duration(seconds: 30), () {
                  setState(() {
                    qrData = 'Validity Expired';
                    qrdataFeed.clear();
                  });
                  showToast("QR code has expired!", Colors.black, Colors.green,
                      Toast.LENGTH_SHORT);
                });
              } else if (newValue == '60 secs') {
                if (val != null) val.cancel();
                val = Timer(Duration(seconds: 60), () {
                  setState(() {
                    qrData = 'Validity Expired';
                    qrdataFeed.clear();
                  });
                  showToast("QR code has expired!", Colors.black, Colors.green,
                      Toast.LENGTH_SHORT);
                });
              } else if (newValue == 'None') {
                if (val != null) val.cancel();
              }
            }
          },
          items: <String>['10 secs', '30 secs', '60 secs', 'None']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  setRange() {
    return Column(
      children: <Widget>[
        Text(
          'Range',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          value: rangeDropdownValue,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              rangeDropdownValue = newValue;
            });
            //if (qrdataFeed.text.isNotEmpty) {
            if (newValue == '150 cm') {
              setState(() {
                range = 150.0;
              });
              showToast("Range set to 150 cm!", Colors.black, Colors.green,
                  Toast.LENGTH_SHORT);
            } else if (newValue == '200 cm') {
              setState(() {
                qrData = qrdataFeed.text;
                range = 200.0;
              });
              showToast("Range set to 200 cm!", Colors.black, Colors.green,
                  Toast.LENGTH_SHORT);
            } else if (newValue == '250 cm') {
              setState(() {
                range = 250.0;
              });
              showToast("Range set to 250 cm!", Colors.black, Colors.green,
                  Toast.LENGTH_SHORT);
            } else if (newValue == 'Default') {
              setState(() {
                range = 400.0;
              });
              showToast("Range set to Default!", Colors.black, Colors.green,
                  Toast.LENGTH_SHORT);
            }
            //}
          },
          items: <String>['150 cm', '200 cm', '250 cm', 'Default']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var numberOfClasses;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          'QR Code Generator',
          style: TextStyle(color: Colors.lightGreen),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _captureAndSharePng();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: RepaintBoundary(
                  key: globalKey,
                  child: QrImage(
                    //plce where the QR Image will be shown
                    data: qrData,
                    size: range,
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                "New QR Link Generator",
                style: TextStyle(fontSize: 20.0),
              ),
              TextField(
                controller: qrdataFeed,
                decoration: InputDecoration(
                  hintText: "TutorId-Subject",
                  errorText: _validate
                      ? "Please enter in TutorId-Subject format!"
                      : null,
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
                  child: MaterialButton(
                    color: Colors.black87,
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () async {
                      temp = qrdataFeed.text;
                      qrdataFeed.text
                              .contains(RegExp(r'^[0-9a-zA-Z]+\-[a-zA-Z]+$'))
                          ? _validate = false
                          : _validate = true;
                      if (qrdataFeed.text.isEmpty) {
                        //a little validation for the textfield

                        setState(() {
                          qrData = "";
                        });
                      } else {
                        int index = qrdataFeed.text.indexOf('-');
                        subject = qrdataFeed.text
                            .substring(index + 1, qrdataFeed.text.length);
                        idd = qrdataFeed.text.substring(0, index);
                        tutorId =
                            await tutor_details.doc(uid).get().then((doc) {
                          return doc.data()['tutorid'];
                        });
                        //Map<String, String> idStore = {tutorId: subject};
                        if (tutorId != idd) {
                          showToast("Invalid Id", Colors.red, Colors.white,
                              Toast.LENGTH_SHORT);
                        } else {
                          print("Subject name is $subject");
                          await tutor_details.doc(uid).get().then((doc) async {
                            Map<String, dynamic> map = await doc.data();
                            print('${map.toString()} is the map');
                            if (!map.containsKey('Subjects')) {
                              await tutor_details.doc(uid).set({
                                'Subjects': {subject: initialValue},
                                'TotalClassesTook': initialValue
                              }, SetOptions(merge: true));
                            }
                          });

                          numberOfClasses = await tutor_details
                              .doc(uid)
                              .get()
                              .then((doc) async {
                            Map<String, dynamic> map = await doc.data();
                            if (map.containsKey('Subjects')) {
                              Map<String, dynamic> map2 =
                                  await doc.data()['Subjects'];
                              if (!map2.containsKey(subject)) {
                                await tutor_details.doc(uid).set({
                                  'Subjects': {subject: initialValue}
                                }, SetOptions(merge: true));
                              }
                            }
                            var val = await doc.data()['Subjects']['$subject'];
                            return val;
                          });

                          print('$numberOfClasses is printed doosribaar');

                          numberOfClasses = await numberOfClasses == null
                              ? 0
                              : numberOfClasses;
                          print('$numberOfClasses is printed teesri baar');

                          totalClassesTook = await tutor_details
                              .doc(uid)
                              .get()
                              .then((doc) async {
                            Map<String, dynamic> classesMap = await doc.data();
                            print('${classesMap.toString()} is the classesMap');
                            if (!classesMap.containsKey('TotalClassesTook')) {
                              await tutor_details.doc(uid).set(
                                  {'TotalClassesTook': initialValue},
                                  SetOptions(merge: true));
                            }
                            var val = await doc.data()['TotalClassesTook'];
                            return val;
                          });

                          totalClassesTook = await totalClassesTook == null
                              ? 1
                              : totalClassesTook;

                          if (!mounted) return;
                          setState(() {
                            qrData = qrdataFeed.text;
                            scanned = true;
                            print('done');
                            //if (temp != qrdataFeed.text)
                            numberOfClasses += 1;
                            totalClassesTook += 1; //idhar se dekhke
                            print('$numberOfClasses is printed');
                          });
                          await tutor_details.doc(uid).set({
                            'Subjects': {'$subject': numberOfClasses},
                            'TotalClassesTook': totalClassesTook
                          }, SetOptions(merge: true));
                          await CollectionAttendanceDetails.doc(formatted)
                              .collection("Today's Tutors")
                              .doc(idd)
                              .set({'TotalClassesTook': totalClassesTook},
                                  SetOptions(merge: true));
                        }
                      }
                    },
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.green,
                        ),
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Generate QR",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.lightGreen),
                    ),
                  )),
              FadeAnimation(
                2.1,
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.bottomLeft,
                            //padding: EdgeInsets.only(top: 0,left: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: setValidity()),
                        Container(
                            alignment: Alignment.bottomRight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: setRange()),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final qrdataFeed = TextEditingController();
  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      print(boundary);
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);
      print(tempDir.path.toString());
      Share.shareFiles(['${tempDir.path}/image.png']);
      // final channel = const MethodChannel('channel:me.alfian.share/share');
      // channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }
}
