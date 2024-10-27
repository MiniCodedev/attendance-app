import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/core/theme/app_theme.dart';
import 'package:attendanceapp/pages/admin_page.dart';
import 'package:attendanceapp/pages/auth_pages/login_page.dart';
import 'package:attendanceapp/pages/student_page.dart';
import 'package:attendanceapp/pages/teacher_page.dart';
import 'package:attendanceapp/services/helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loggedin = false;
  String? category;
  bool isloading = true;

  @override
  void initState() {
    super.initState();

    Helper().getUserLoggedInStatus().then(
      (value) {
        setState(() {
          loggedin = value == null ? false : true;
        });
      },
    );
    Helper().gettingUserEmail().then(
      (value) {
        setState(() {
          category = value;
          isloading = false;
        });
      },
    );
  }

  Future<bool> checkLogin() async {
    loggedin = await Helper().getUserLoggedInStatus() == null ? false : true;
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
    return FutureBuilder<bool>(
      future: checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: loggedin ? nextScreen() : const LoginPage(),
            theme: AppTheme.lightTheme,
          );
        }
      },
    );
  }
}
