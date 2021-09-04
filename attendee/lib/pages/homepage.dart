import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:attendee/animation/FadeAnimation.dart';
import 'package:attendee/constants.dart';

class Homepage extends StatefulWidget {
  _Homepage createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isLoggedIn = false;

  String _validateName(String value) {
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  checkAuthentication() async {
    //check whether user is logged in

    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.of(context).pushNamed('/homepage');
        // Navigator.push(context, MaterialPageRoute(
        //     builder: (context) => Homepage()));
      }
    });
  }

  getUser() async {
    //getUser if loggedin
    User firebaseUser = await _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isLoggedIn = true;
      });
    }
  }

  @override
  // void initState(){
  //   this.checkAuthentication();
  //  this.getUser();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: //!isLoggedIn?CircularProgressIndicator() :
            SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FadeAnimation(
                        1,
                        Text(
                          "Welcome",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        )),
                    // SizedBox(height: 20,),
                    // Text("Select the type of account",
                    // textAlign: TextAlign.center,
                    // style: TextStyle(
                    //   color: Colors.grey[700],
                    //   fontSize: 15,
                    // ),),
                  ],
                ),
                FadeAnimation(
                  1.1,
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 50,
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 5),
                        ]),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              //behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  isTutor = false;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "STUDENT",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: !isTutor
                                          ? Colors.black87
                                          : Colors.black54,
                                    ),
                                  ),
                                  if (!isTutor)
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: !isTutor
                                          ? Colors.green
                                          : Colors.lightGreen,
                                    ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              //behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  isTutor = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    "TUTOR",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isTutor
                                          ? Colors.black87
                                          : Colors.black54,
                                    ),
                                  ),
                                  if (isTutor)
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      height: 2,
                                      width: 55,
                                      color: isTutor
                                          ? Colors.green
                                          : Colors.lightGreen,
                                    )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                FadeAnimation(
                    1.2,
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/logo.png'))),
                    )),
                Column(
                  children: <Widget>[
                    FadeAnimation(
                        1.3,
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            print(isTutor);
                            Navigator.of(context).pushNamed('/login');
                            // Navigator.push(context, MaterialPageRoute(builder: (
                            //     context) => LoginPage()));
                          },
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                        1.4,
                        Container(
                          //padding: EdgeInsets.only(top: 0,left: 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border(
                                bottom: BorderSide(color: Colors.black),
                                top: BorderSide(color: Colors.black),
                                left: BorderSide(color: Colors.black),
                                right: BorderSide(color: Colors.black),
                              )),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () {
                              isTutor
                                  ? Navigator.of(context)
                                      .pushNamed('/tutorSignup')
                                  : Navigator.of(context)
                                      .pushNamed('/studentSignup');
                              // Navigator.push(context, MaterialPageRoute(
                              //     builder: isTutor? (context) => TutorSignup() : (context) => Signup() ));
                            },
                            color: Colors.lightGreen,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "Signup",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
