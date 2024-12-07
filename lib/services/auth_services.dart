// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:attendanceapp/services/database_services.dart';
import 'package:attendanceapp/services/helper.dart';

class AuthServices {
  Helper helperFunction = Helper();
  final authFirebase = FirebaseAuth.instance;
  DatabaseServices databaseServices = DatabaseServices();

  Future login(String email, String password) async {
    try {
      User user = (await authFirebase.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      dynamic data;

      if (email.contains("@student")) {
        data = await DatabaseServices().gettingStudentData(user.uid);
      } else {
        data = await DatabaseServices().gettingTeacherData(user.uid);
      }

      await helperFunction.saveUserLoggedInStatus(true);
      await helperFunction.saveUserEmailKey(email);
      if (email == "admin@university.jpr") {
        await helperFunction.saveUserNameKey("Admin");
      } else if (email.contains("@student")) {
        await helperFunction.saveUserNameKey(data["name"]);
        await helperFunction.saveUIDKey(data["rollno"]);
      } else {
        await helperFunction.saveUserNameKey(data["name"]);
        await helperFunction.saveUIDKey(data["uid"]);
      }

      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<bool> changePassword(
      String email, String password, String newPassword, bool isStudent) async {
    try {
      User user = (await authFirebase.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user == null) {
        throw Exception('No user is signed in.');
      }

      await user.updatePassword(newPassword);
      await databaseServices.changePasswordInDatabase(
          user.uid, newPassword, isStudent);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future deleteAcc(String email, String password) async {
    try {
      User user = (await authFirebase.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      user.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future registerTeacherAcc(
      String id, String name, String email, String password) async {
    try {
      User user = (await authFirebase.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        databaseServices.uploadTeacherdata(id, name, email, password, user.uid);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future registerStudentAcc(
      String rollno,
      String name,
      String email,
      String password,
      int year,
      String section,
      String department,
      String dob) async {
    try {
      User user = (await authFirebase.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        databaseServices.uploadStudentdata(rollno, name, email, password, year,
            section, department, dob, user.uid);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await helperFunction.saveUserLoggedInStatus(false);
      await helperFunction.saveUserEmailKey("USEREMAILKEY");
      await helperFunction.saveUserNameKey("USERNAMEKEY");
      await helperFunction.saveUIDKey("USERUIDKEY");
      await authFirebase.signOut();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
