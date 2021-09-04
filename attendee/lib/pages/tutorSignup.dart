import 'package:attendee/animation/FadeAnimation.dart';
import 'package:attendee/utilities/formValidations.dart';

import 'package:attendee/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import 'login.dart';

TextEditingController _pass = TextEditingController();

class TutorSignup extends StatefulWidget {
  @override
  _TutorSignup createState() => _TutorSignup();
}

class _TutorSignup extends State<TutorSignup> {
  final AuthenticationService _auth = AuthenticationService();

  String _name, subj_name, subj_id, tutor_id, mobileno, email;
  bool _success;
  String _role = isTutor ? 'tutor' : 'student';

  final TextEditingController _confirmPass = TextEditingController();

  //FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }

    dynamic result = await _auth.registerWithEmailAndPassword(
        email, _pass.text, _name, mobileno, null, tutor_id, _role, context);
    if (emessage != "") {
      showError(emessage);
      emessage = "";
    }
    if (result == null) {
      setState(() {
        _success = false;
        var error = "Enter a valid email";
      });
    } else {
      setState(() {
        _success = true;
      });
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            _pass.clear();
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
            padding: EdgeInsets.symmetric(horizontal: 40),
            //height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                          1,
                          Text(
                            "Sign up",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          1.2,
                          Text(
                            "Create an account, it's free",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                            ),
                          ))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
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
                                fillColor: Colors.white,
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
                          // FadeAnimation(1.4, Padding(
                          //     padding: EdgeInsets.only(top: 10.0),
                          //   child: TextFormField(
                          //     textCapitalization: TextCapitalization.words,
                          //     decoration: InputDecoration(
                          //       border: UnderlineInputBorder(),
                          //       filled: true,
                          //       icon: Icon(Icons.book_rounded),
                          //       hintText: 'Enter subject name',
                          //       labelText: 'Subject Name',
                          //     ),
                          //     onSaved: (value) {
                          //       subj_name = value ;
                          //       //this._name = value;
                          //     },
                          //     validator: _validateName,
                          //   ),
                          // ),),
                          // FadeAnimation(1.5, Padding(
                          //   padding: EdgeInsets.only(top: 10.0),
                          //   child: TextFormField(
                          //     textCapitalization: TextCapitalization.words,
                          //     decoration: InputDecoration(
                          //       border: UnderlineInputBorder(),
                          //       filled: true,
                          //       icon: Icon(Icons.library_books),
                          //       hintText: 'Enter subject id',
                          //       labelText: 'Subject ID',
                          //     ),
                          //     onSaved: (value) {
                          //       subj_id = value ;
                          //       //this._name = value;
                          //     },
                          //     validator: _validateName,
                          //   ),
                          // ),),
                          FadeAnimation(
                            1.6,
                            Padding(
                              padding: EdgeInsets.only(top: 11.0),
                              child: TextFormField(
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  fillColor: Colors.white,
                                  filled: true,
                                  icon: Icon(Icons.perm_identity),
                                  hintText: 'Enter Tutor id',
                                  labelText: 'Tutor Id',
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
                              padding: EdgeInsets.only(top: 11.0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  fillColor: Colors.white,
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
                              padding: EdgeInsets.only(top: 11.0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  fillColor: Colors.white,
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
                          FadeAnimation(
                            1.9,
                            Padding(
                              padding: EdgeInsets.only(top: 11.0),
                              child: PasswordField(
                                fieldKey: _passwordFieldKey,
                                //helperText: 'No more than 8 characters.',
                                hintText: 'Enter Password',
                                labelText: 'Password *',
                                onSaved: (value) {
                                  _pass.text = value;
                                  //this._pass.text = value;
                                },
                                onFieldSubmitted: (String value) {
                                  setState(() {
                                    _pass.text = value;
                                    //this._password = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          FadeAnimation(
                            2.0,
                            Padding(
                              padding: EdgeInsets.only(top: 11.0),
                              child: TextFormField(
                                //enabled: this._password != null && this._password.isNotEmpty,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.security_outlined),
                                  border: UnderlineInputBorder(),
                                  fillColor: Colors.white,
                                  filled: true,
                                  labelText: 'Re-type password',
                                ),
                                onSaved: (value) {
                                  _confirmPass.text = value;
                                },
                                obscureText: true,
                                controller: _confirmPass,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please Re-Enter New Password";
                                  } else if (value.length < 8) {
                                    return "Password must be atleast 8 characters long";
                                  } else if (_pass.text != _confirmPass.text) {
                                    return "Password Mismatch";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    FadeAnimation(
                      2.1,
                      Container(
                        //padding: EdgeInsets.only(top: 0,left: 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border(
                              bottom: BorderSide(color: Colors.green),
                              top: BorderSide(color: Colors.green),
                              left: BorderSide(color: Colors.green),
                              right: BorderSide(color: Colors.green),
                            )),
                        child: MaterialButton(
                          minWidth: 150,
                          height: 60,
                          onPressed: signUp, //(){},
                          color: Colors.greenAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(_success == null
                          ? ''
                          : (_success
                              ? 'Successfully registered'
                              : 'Registration failed')),
                    )
                  ],
                ),
                FadeAnimation(
                    2.2,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    )),
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
      onSaved: (value) {
        _pass.text = value;
      },
      controller: _pass,
      validator: pwdValidator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        icon: Icon(Icons.security_outlined),
        border: const UnderlineInputBorder(),
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
