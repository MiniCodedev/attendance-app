import 'package:attendanceapp/common/input_borders.dart';
import 'package:attendanceapp/pages/admin_page.dart';
import 'package:attendanceapp/pages/student_page.dart';
import 'package:attendanceapp/pages/teacher_page.dart';
import 'package:flutter/material.dart';
import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/services/auth_services.dart';
import 'package:attendanceapp/widgets/basic_snack_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool show = false;
  String email = "";
  String password = "";
  final formKey = GlobalKey<FormState>();

  submitButton() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      AuthServices().login(email, password).then((value) {
        if (value == true) {
          setState(() {
            isLoading = false;
          });
          if (email == "admin@university.jpr") {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) {
                return const AdminPage();
              },
            ));
          } else if (email.contains("@student")) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) {
                return const StudentPage();
              },
            ));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) {
                return const TeacherPage();
              },
            ));
          }
        } else {
          setState(() {
            isLoading = false;
          });
          Future.delayed(
            const Duration(seconds: 1),
            () {
              showSnackBar(context, value, Colors.red);
            },
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              backgroundColor: Colors.white,
              body: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: height / 30,
                        ),
                        Image.asset("assets/images/jpr.jpg"),
                        SizedBox(
                          height: height / 30,
                        ),
                        Center(
                          child: Text(
                            "Attendance Portal",
                            style: TextStyle(
                              fontSize: width / 20,
                              color: AppColors.primaryColor,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 12,
                        ),
                        TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please enter a valid email.";
                          },
                          onChanged: (val) {
                            email = val.replaceAll(" ", "");
                          },
                          decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: AppColors.primaryColor,
                              ),
                              errorBorder: errorBroder,
                              border: border,
                              enabledBorder: border,
                              enabled: true,
                              focusedBorder: focusborder),
                        ),
                        SizedBox(
                          height: height / 45,
                        ),
                        TextFormField(
                          validator: (val) {
                            return;
                          },
                          onChanged: (val) {
                            password = val;
                          },
                          obscureText: show ? false : true,
                          decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (show) {
                                      show = false;
                                    } else {
                                      show = true;
                                    }
                                  });
                                },
                                icon: show
                                    ? const Icon(Icons.visibility_rounded)
                                    : const Icon(Icons.visibility_off_rounded),
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.primaryColor,
                              ),
                              errorBorder: errorBroder,
                              border: border,
                              enabledBorder: border,
                              enabled: true,
                              focusedBorder: focusborder),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                width: 100,
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    submitButton();
                  },
                  child: const Text(
                    "Login",
                  ),
                ),
              ),
            ),
    );
  }
}
