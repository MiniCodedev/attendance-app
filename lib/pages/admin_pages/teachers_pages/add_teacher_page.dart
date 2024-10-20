import 'package:attendanceapp/constant.dart';
import 'package:attendanceapp/services/auth_services.dart';
import 'package:attendanceapp/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AddTeacherPage extends StatefulWidget {
  const AddTeacherPage({super.key});

  @override
  State<AddTeacherPage> createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String id = "";
  String email = "";
  String paswd = "";
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text(
            "Add Teacher",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  validator: (val) {
                    if (val == "") {
                      return "Please provide an ID.";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    id = val.replaceAll(" ", "");
                  },
                  decoration: InputDecoration(
                      hintText: "Id",
                      prefixIcon: Icon(
                        Icons.assignment_ind,
                        color: primaryColor,
                      ),
                      errorBorder: errorBroder,
                      border: border,
                      enabledBorder: border,
                      enabled: true,
                      focusedBorder: focusborder),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (val) {
                    if (val == "") {
                      return "Please provide an name.";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    name = val;
                  },
                  decoration: InputDecoration(
                      hintText: "Name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: primaryColor,
                      ),
                      errorBorder: errorBroder,
                      border: border,
                      enabledBorder: border,
                      enabled: true,
                      focusedBorder: focusborder),
                ),
                const SizedBox(
                  height: 20,
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
                        color: primaryColor,
                      ),
                      errorBorder: errorBroder,
                      border: border,
                      enabledBorder: border,
                      enabled: true,
                      focusedBorder: focusborder),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (val) {
                    if (val == "") {
                      return "Please provide an password.";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    paswd = val.replaceAll(" ", "");
                  },
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: primaryColor,
                    ),
                    errorBorder: errorBroder,
                    border: border,
                    enabledBorder: border,
                    enabled: true,
                    focusedBorder: focusborder,
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, foregroundColor: Colors.white),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                showLoadingDialog(context);
                AuthServices().registerTeacherAcc(id, name, email, paswd).then(
                  (value) {
                    Navigator.pop(context);
                    if (value == true) {
                      Navigator.of(context).pop();
                      showSnackBar(context,
                          "Successfully added teacher's detail.", primaryColor);
                    } else {
                      showSnackBar(context, value, Colors.red);
                    }
                  },
                );
              }
            },
            child: const Text("Submit"),
          ),
        ));
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const LoadingDialog();
    },
  );
}

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 15),
            Text("Loading, please wait..."),
          ],
        ),
      ),
    );
  }
}
