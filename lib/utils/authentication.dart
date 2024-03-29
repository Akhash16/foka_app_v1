import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  // GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignIn _googleSignIn = GoogleSignIn();

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

  Future<bool> signOut() async {
    try {
      await _googleSignIn.isSignedIn().then((value) {
        if (value) {
          print(value);
          _googleSignIn.disconnect();
        }
      });
      _auth.signOut();
      return Future<bool>.value(true);
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      return Future<bool>.value(false);
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return Future<bool>.value(false);

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      return Future<bool>.value(true);
    } catch (error) {
      print('error' + error.toString());
      return Future<bool>.value(false);
    }
  }

  User getCurrentUser() {
    return _auth.currentUser!;
  }

  String getCurrentUserId() {
    return getCurrentUser().uid;
  }

  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  Future<void> deleteUserAccount() async {
    await _auth.currentUser!.delete();
  }
}
