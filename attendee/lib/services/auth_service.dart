import 'package:firebase_auth/firebase_auth.dart';
import 'package:attendee/constants.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  AuthService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signInWithEmailAndPassword(String email,  String password) async {
    try {
      await _firebaseAuth.
      signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "signedIn";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emessage = e.message;
      } else if (e.code == 'wrong-password') {
        emessage = e.message;
      }
    }
  }

  Future<String> registerWithEmailAndPassword(String email,String password) async {
    try {
      await _firebaseAuth.
      createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emessage = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        emessage = "The account already exists for that email.";
      }
    } catch (e) {
      print(e);
    }
  }
  Future signOut() async{
    try{
      return await _firebaseAuth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}

//}