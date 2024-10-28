import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  static final _auth = FirebaseAuth.instance;

  bool get isAuth {
    return _auth.currentUser != null;
  }

  String? get userId {
    return isAuth ? _auth.currentUser!.uid : null;
  }

  Future<void> _authenticate(
      String email, String password, bool isLogin) async {
    try {
      if (isLogin) {
        _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        _auth.createUserWithEmailAndPassword(email: email, password: password);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  static Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, false);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, true);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
