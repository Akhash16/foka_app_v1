import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      // 'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  bool emailRegisterAuth(String email, String password) {
    try {
      _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      return false;
    }
  }

  bool emailSignInAuth(String email, String password) {
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      return false;
    }
  }

  bool emailForgotPassword(String email) {
    try {
      _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      return false;
    }
  }

  bool signOut() {
    try {
      _auth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      return false;
    }
  }

  // Future<bool> signInWithGoogle() async {
  //   try {
  //     await _googleSignIn.signIn();
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }

  // Future<String> signInWithGoogle() async {
  //   await _googleSignIn.signIn();
  //   return "success";
  // }

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  User getCurrentUser() {
    return FirebaseAuth.instance.currentUser!;
  }

  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }
}
