import 'dart:developer';
import 'dart:io';

import 'package:chat_app/helper_functions/helper_function_sf.dart';
import 'package:chat_app/services/databas_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static FirebaseAuth fAuth = FirebaseAuth.instance;
  // register
  Future registerWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User? user = (await fAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        await DatabaseServices(uid: user.uid).saveUserData(email, fullName);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await fAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try{
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmail("");
      await HelperFunctions.saveUserName("");
      await FirebaseAuth.instance.signOut();
    }
    catch(e){
      log(e.toString());
    }
  }
}
