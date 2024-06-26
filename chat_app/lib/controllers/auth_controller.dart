import 'dart:developer';

import 'package:chat_app/controllers/helper_controllers.dart';
import 'package:chat_app/services/databas_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth fAuth = FirebaseAuth.instance;
  final helperController = Get.find<HelperController>();

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
    update();
  }

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await fAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      update();
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await helperController.saveUserLoggedInStatus(false);
      await helperController.saveUserEmail("");
      await helperController.saveUserName("");
      await fAuth.signOut();
      update();
      return false;
    } catch (e) {
      log(e.toString());
    }
  }
}
