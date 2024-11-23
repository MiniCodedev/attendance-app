import 'package:attendanceapp/services/database_services.dart';
import 'package:attendanceapp/services/helper.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String name = "Username";
  String email = "user@example.com";
  String uid = "useruid";
  String year = "";
  String section = "";
  String department = "";
  String rollno = "";
  String password = "";
  Helper helper = Helper();
  DatabaseServices databaseServices = DatabaseServices();

  Future loadUserdata() async {
    name = await helper.gettingUserName();
    email = (await helper.gettingUserEmail()) ?? "user@example.com";
    uid = await helper.gettingUserUid();
    await databaseServices.getStudentInformation(email).then(
      (value) {
        name = value["name"];
        email = value["email"];
        year = value["year"];
        section = value["section"];
        department = value["department"];
        rollno = value["rollno"];
        password = value["password"];
      },
    );
    notifyListeners();
  }
}
