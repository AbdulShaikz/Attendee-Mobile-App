import 'package:attendee/animation/FadeAnimation.dart';
import 'package:attendee/constants.dart';
import 'package:attendee/pages/homepage.dart';
import 'package:attendee/loading.dart';
import 'package:attendee/pages/studentDashboard.dart';
import 'package:attendee/pages/studentSignup.dart';
import 'package:attendee/pages/tutorDashboard.dart';
import 'package:attendee/pages/tutorSignup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:attendee/services/authentication_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage(); // creating _LoginState
}

class _LoginPage extends State<LoginPage> {
  // ProgressDialog progressDialog;
  // Create a reference to the users collection
  //var  user_details = FirebaseFirestore.instance.collection('/users/');
  //ar citiesRef = user_detail.;

// Create a query against the collection.
  //var query = citiesRef.where("state", "==", "CA");

  String user = isTutor ? 'tutors' : 'students';
  // Future readData() async {
  //   FirebaseFirestore.instance.collection('user').path[];
  // }

  final AuthenticationService _authenticate = AuthenticationService();

  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '', _password = '';
  bool loading = false; //loading
  SharedPreferences logindata;
  bool checkLogin;
  bool newUser;
  bool type;

  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  // checkAuthentication() async { //check whether user is logged in
  //
  //   _auth.authStateChanges().listen((user) {
  //
  //     if(user!=null){
  //
  //       Navigator.push(context, MaterialPageRoute(
  //           builder: (context)=>Homepage()));
  //     }
  //   });
  //
  //   @override
  //   void initState(){
  //     // super.initState();
  //     // this.checkAuthentication();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    //loginCheck();
  }

  login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      dynamic result = await _authenticate.signInWithEmailAndPassword(
          _email, _password, context);
      print('result value is $result');

      // try {
      //   UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(
      //       email: _email,
      //       password: _password
      //   );
      // } on FirebaseAuthException catch (e) {
      //   if (e.code == 'user-not-found') {
      //     showError(e.message);
      //   } else if (e.code == 'wrong-password') {
      //     showError(e.message);
      //   }
      // }
      if (emessage != "") {
        showError(emessage);
        emessage = "";
      }
      if (result == null) {
        setState(() {
          loading = false;
          var error;
          error = "Couldn't signin";
        });
      } else {
        // Navigator.of(context).pushReplacementNamed('/dashboard');
        // progressDialog.show();
        // if (mapIds.containsKey('$_email')) {
        //   userName = mapIds['$_email'].toString();
        // }
        // // _authenticate.getRole();
        // DatabaseService().getData('role');
        // print(checkRole);
        // if (checkRole == "tutor" && !isTutor ||
        //     checkRole == "student" && isTutor) {
        //   showToast("Please check your account type!", Colors.red, Colors.white,
        //       Toast.LENGTH_SHORT);
        //   Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(builder: (context) => Homepage()));
        // } else if (checkRole == "student" && !isTutor) {
        //   print("$checkRole in login else");
        //   print(!isTutor);
        //   print(checkRole == 'tutor' && !isTutor);
        //
        //   //GetUserName(FirebaseAuth.instance.currentUser.uid);
        //   Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(builder: (context) => StudentDashboard()));
        //   // checkRole="";
        // } else {
        //   print("$checkRole in login else");
        //   print(!isTutor);
        //   print(checkRole == 'tutor' && !isTutor);
        //
        //   //GetUserName(FirebaseAuth.instance.currentUser.uid);
        //   Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(builder: (context) => TutorDashboard()));
        //   // checkRole="";
        // }

        String userType = await FirebaseFirestore.instance
            .collection(user)
            .doc(FirebaseAuth.instance.currentUser.uid)
            .get()
            .then((value) {
          return value['role'];
        });
        print(userType);
        // if (userType == "tutor" && !isTutor ||
        //     userType == "student" && isTutor) {
        //   showToast("Please check your account type!", Colors.red, Colors.white,
        //       Toast.LENGTH_SHORT);
        //   Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(builder: (context) => Homepage()));
        // }
        try {
          if (userType == "student" && !isTutor) {
            print("$userType in login else");
            print(!isTutor);
            print(userType == 'tutor' && !isTutor);
            // logindata.setBool('checkLogin', false);
            // logindata.setBool('type', false);
            //logindata.setString('checkEmail', _email);
            setState(() => loading = true);
            //GetUserName(FirebaseAuth.instance.currentUser.uid);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => StudentDashboard()));
            // checkRole="";
          } else {
            if (userType == "tutor" && isTutor) {
              print("$userType in login else");
              print(!isTutor);
              print(userType == 'tutor' && isTutor);
              // logindata.setBool('checkLogin', false);
              // logindata.setBool('type', true);
              // logindata.setString('checkEmail', _email);
              setState(() => loading = true);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => TutorDashboard()));
              //GetUserName(FirebaseAuth.instance.currentUser.uid);
              // checkRole="";
            } else if (userType == "tutor" && !isTutor ||
                userType == "student" && isTutor) {
              showToast("Please check your account type!", Colors.red,
                  Colors.white, Toast.LENGTH_SHORT);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Homepage()));
            } else {
              showToast("Please check your account type!", Colors.red,
                  Colors.white, Toast.LENGTH_SHORT);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Homepage()));
            }
          }
        } catch (e) {
          showToast("Please check your account type!", Colors.red, Colors.white,
              Toast.LENGTH_SHORT);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Homepage()));
        }
      }
    }
  }

  loginCheck() async {
    // logindata = await SharedPreferences.getInstance();
    // newUser = (logindata.getBool('checkLogin') ?? true);
    // if (newUser == false) {
    //   type
    //       ? Navigator.pushReplacement(context,
    //           new MaterialPageRoute(builder: (context) => TutorDashboard()))
    //       : Navigator.pushReplacement(context,
    //           new MaterialPageRoute(builder: (context) => StudentDashboard()));
    // }
  }

  showError(String emsg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(emsg),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  @override
  void dispose() {
    _email = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // progressDialog =  ProgressDialog(context);   //method 1 of loading screen
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: AssetImage('assets/images/attendee.png')
                  // )),
                  // decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //         begin: Alignment.topCenter,
                  //         end: Alignment.bottomCenter,
                  //         colors: [
                  //       Colors.lightGreen,
                  //       Colors.greenAccent,
                  //       Colors.lightGreenAccent,
                  //       Colors.green,
                  //     ])),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: <Widget>[
                                FadeAnimation(
                                    1,
                                    Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                FadeAnimation(
                                    1.2,
                                    Text(
                                      "Login to your account",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700]),
                                    ))
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Container(
                                child: Form(
                                  key: _formKey,
                                  //autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    children: <Widget>[
                                      FadeAnimation(
                                        1.3,
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                            fillColor: Colors.white,
                                            filled: true,
                                            icon: Icon(Icons.email),
                                            hintText: 'Your email address',
                                            labelText: 'E-mail',
                                          ),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          onSaved: (value) {
                                            this._email = value;
                                          },
                                          onChanged: (value) {
                                            setState(() => _email = value);
                                          },
                                          validator: emailValidator,
                                        ),
                                      ),
                                      FadeAnimation(
                                        1.4,
                                        Padding(
                                          padding: EdgeInsets.only(top: 25.0),
                                          child: PasswordField(
                                            fieldKey: _passwordFieldKey,
                                            //helperText: 'No more than 8 characters.',
                                            hintText: 'Enter Password',
                                            labelText: 'Password',
                                            onSaved: (value) {
                                              this._password = value;
                                            },
                                            onFieldSubmitted: (String value) {
                                              setState(() {
                                                this._password = value;
                                                _password = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            FadeAnimation(
                                1.5,
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 0, left: 0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border(
                                          bottom:
                                              BorderSide(color: Colors.black),
                                          top: BorderSide(color: Colors.black),
                                          left: BorderSide(color: Colors.black),
                                          right:
                                              BorderSide(color: Colors.black),
                                        )),
                                    child: MaterialButton(
                                      minWidth: 150,
                                      height: 60,
                                      onPressed: login,
                                      // () async{
                                      //   log('$_email');
                                      //   log('$_password');
                                      // },
                                      color: Colors.greenAccent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                )),
                            FadeAnimation(
                                1.6,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Dont have an account?",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: !isTutor
                                                    ? (context) => Signup()
                                                    : (context) =>
                                                        TutorSignup()));
                                      },
                                      child: Text(
                                        "Sign up",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      //maxLength: 8,
      onSaved: widget.onSaved,
      validator: pwdValidator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        icon: Icon(Icons.security_outlined),
        border: UnderlineInputBorder(),
        fillColor: Colors.white,
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
