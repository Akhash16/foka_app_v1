import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  bool emailRegisterAuth(String email, String password) {
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      return false;
    }
  }

  bool emailSignInAuth(String email, String password) {
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      return false;
    }
  }

  bool emailForgotPassword(String email) {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      return false;
    }
  }

  bool signOut() {
    try {
      FirebaseAuth.instance.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      return false;
    }
  }

  String getCurrentUser() {
    return FirebaseAuth.instance.currentUser!.email as String;
  }
}
