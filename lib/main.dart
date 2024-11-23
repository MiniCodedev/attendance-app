import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/core/theme/app_theme.dart';
import 'package:attendanceapp/pages/admin_page.dart';
import 'package:attendanceapp/pages/auth_pages/login_page.dart';
import 'package:attendanceapp/pages/student_page.dart';
import 'package:attendanceapp/pages/teacher_page.dart';
import 'package:attendanceapp/services/helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var loggedin = false;
  String? category;

  Future<bool> checkLogin() async {
    loggedin = (await Helper().getUserLoggedInStatus())!;
    category = await Helper().gettingUserEmail();
    return loggedin;
  }

  Widget nextScreen() {
    if (category == null) {
      return Container();
    } else if (category == "admin@university.jpr") {
      return const AdminPage();
    } else if (category?.contains("@student") == true) {
      return const StudentPage();
    } else {
      return const TeacherPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: FutureBuilder<bool>(
        future: checkLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          } else {
            return loggedin ? nextScreen() : const LoginPage();
          }
        },
      ),
    );
  }
}
