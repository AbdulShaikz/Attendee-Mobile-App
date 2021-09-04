import 'package:attendee/constants.dart';
import 'package:attendee/pages/generateQRcode.dart';
import 'package:attendee/pages/helloWorld.dart';
import 'package:attendee/pages/login.dart';
import 'package:attendee/models/user.dart';
import 'package:attendee/pages/scanQRcode.dart';
import 'package:attendee/services/authentication_service.dart';
import 'package:attendee/pages/studentSignup.dart';
import 'package:attendee/pages/tutorSignup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:attendee/Screens/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users>.value(
      value: AuthenticationService().userstream,
      //child:
      //MultiProvider(
      //providers: [
      //Provider<AuthService>
      //(create: (_) => AuthService((FirebaseAuth.instance)),
      //),
      //StreamProvider(
      //  create: (context) => context.read<AuthService>().authStateChanges,
      //)
      //],
      //initialData: null,

      initialData: null,
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.lightGreen,
            primaryIconTheme: IconThemeData(color: Colors.green)),
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        routes: <String, WidgetBuilder>{
          '/homepage': (BuildContext context) => new Homepage(),
          '/login': (BuildContext context) => new LoginPage(),
          '/studentSignup': (BuildContext context) => new Signup(),
          '/tutorSignup': (BuildContext context) => new TutorSignup(),
          //'/dashboard': (BuildContext context) => new Dashboard(),
        },
      ),
    );
    //);
  }
}
