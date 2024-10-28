import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  final auth = FirebaseAuth.instance;

  bool get isAuth {
    return auth.currentUser != null;
  }

  String? get userId {
    return isAuth ? auth.currentUser!.uid : null;
  }

  Future<void> _authenticate(
      String email, String password, bool isLogin) async {
    try {
      if (isLogin) {
        auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        auth.createUserWithEmailAndPassword(email: email, password: password);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, false);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, true);
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
