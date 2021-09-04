import 'package:attendee/animation/FadeAnimation.dart';
import 'package:attendee/constants.dart';
import 'package:attendee/pages/profilePage.dart';
import 'package:attendee/utilities/formValidations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String _name, tutor_id, mobileno, email;
  bool _success;
  String _role = isTutor ? 'tutor' : 'student';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String uid = FirebaseAuth.instance.currentUser.uid;

  final CollectionReference student_details =
      FirebaseFirestore.instance.collection('students');
  final CollectionReference tutor_details =
      FirebaseFirestore.instance.collection("tutors");

  save() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    if (isTutor) {
      await tutor_details.doc(uid).set({
        'fullname': _name,
        'mobilenumber': mobileno,
        'email': email,
        'tutorid': tutor_id,
      }, SetOptions(merge: true));
    } else {
      await student_details.doc(uid).set({
        'fullname': _name,
        'mobilenumber': mobileno,
        'email': email,
        'rollno': tutor_id,
      }, SetOptions(merge: true));
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ProfileView()));
    showToast("Saved!", Colors.green, Colors.white, Toast.LENGTH_SHORT);
  }

  cancel() {
    showToast("Cancelled!", Colors.red, Colors.white, Toast.LENGTH_SHORT);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.lightGreen),
        ),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.black87,
        // leading: IconButton(
        //   onPressed: () {
        //     //Navigator.pop(context);
        //     Navigator.of(context)
        //         .push(MaterialPageRoute(builder: (context) => ProfileView()));
        //   },
        //   icon: Icon(
        //     Icons.arrow_back_ios,
        //     size: 20,
        //     color: Colors.black,
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            //height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    child: Form(
                      autovalidateMode: AutovalidateMode.always,
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(
                            1.3,
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                filled: true,
                                icon: Icon(Icons.person),
                                hintText: 'Enter your full name',
                                labelText: 'Name',
                              ),
                              onSaved: (value) {
                                _name = value;
                                //this._name = value;
                              },
                              validator: validateName,
                            ),
                          ),
                          FadeAnimation(
                            1.6,
                            Padding(
                              padding: EdgeInsets.only(top: 15.0),
                              child: TextFormField(
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  filled: true,
                                  icon: Icon(Icons.perm_identity),
                                  hintText: isTutor
                                      ? 'Enter Tutor id'
                                      : 'Roll number',
                                  labelText:
                                      isTutor ? 'Tutor Id' : 'Roll number',
                                ),
                                onSaved: (value) {
                                  tutor_id = value;
                                  //this._name = value;
                                },
                                validator: validateTutorId,
                              ),
                            ),
                          ),
                          FadeAnimation(
                            1.7,
                            Padding(
                              padding: EdgeInsets.only(top: 15.0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  filled: true,
                                  icon: Icon(Icons.phone),
                                  hintText: 'Phone Number',
                                  labelText: 'Phone Number ',
                                  prefixText: '+91',
                                ),
                                keyboardType: TextInputType.phone,
                                onSaved: (value) {
                                  mobileno = value;
                                  //this._mobileno = value;
                                },
                                validator: validateMobileNumber,
                                maxLength: 10,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ),
                          FadeAnimation(
                            1.8,
                            Padding(
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  filled: true,
                                  icon: Icon(Icons.email),
                                  hintText: 'Your email address',
                                  labelText: 'E-mail',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (value) {
                                  email = value;
                                  //this._email = value;
                                },
                                validator: emailValidator,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FadeAnimation(
                      1.9,
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.only(top: 0, left: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          // border: Border(
                          //   bottom: BorderSide(color: Colors.black),
                          //   top: BorderSide(color: Colors.black),
                          //   left: BorderSide(color: Colors.black),
                          //   right: BorderSide(color: Colors.black),
                          // )
                        ),
                        child: MaterialButton(
                          minWidth: 150,
                          height: 60,
                          onPressed: save, //(){},
                          color: Colors.greenAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: const Text(
                            "Save",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    FadeAnimation(
                      2.0,
                      Container(
                        alignment: Alignment.bottomRight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          // border: Border(
                          //   bottom: BorderSide(color: Colors.black),
                          //   top: BorderSide(color: Colors.black),
                          //   left: BorderSide(color: Colors.black),
                          //   right: BorderSide(color: Colors.black),
                          // )
                        ),
                        child: MaterialButton(
                          minWidth: 150,
                          height: 60,
                          onPressed: cancel, //(){},
                          color: Colors.redAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
