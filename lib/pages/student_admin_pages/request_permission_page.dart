import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/student_admin_pages/view_student_attendance_detail_page.dart';
import 'package:attendanceapp/services/database_services.dart';
import 'package:flutter/material.dart';

class RequestPermissionPage extends StatefulWidget {
  const RequestPermissionPage({
    super.key,
    required this.name,
    required this.email,
    required this.rollno,
    required this.department,
    required this.section,
    required this.year,
  });
  final String name;
  final String email;
  final int year;
  final String section;
  final String department;
  final String rollno;

  @override
  State<RequestPermissionPage> createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<RequestPermissionPage> {
  String sub = "";
  String content = "";
  final formKey = GlobalKey<FormState>();

  Future<void> onApply() async {
    if (formKey.currentState!.validate()) {
      showLoadingDialog(context);
      DatabaseServices()
          .addOdandLeave(
        name: widget.name,
        email: widget.email,
        sub: sub,
        content: content,
        year: widget.year.toString(),
        dept: widget.department,
        section: widget.section,
        rollno: widget.rollno,
      )
          .then(
        (value) {
          Future.delayed(const Duration(seconds: 2));
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Permission"),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Subject: ",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter a subject';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    setState(() {
                      sub = val;
                    });
                  },
                  decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: AppColors.primaryColor, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: AppColors.primaryColor, width: 2),
                      ),
                      enabled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: AppColors.primaryColor, width: 2),
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Respected Sir/Madam, ",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 400,
                  child: TextFormField(
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter body content';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        content = val;
                      });
                    },
                    expands: true,
                    maxLines: null,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 10),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: AppColors.primaryColor, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: AppColors.primaryColor, width: 2),
                      ),
                      enabled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: AppColors.primaryColor, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FilledButton(
          onPressed: onApply,
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
              foregroundColor: const WidgetStatePropertyAll(Colors.white)),
          child: const Text("Apply"),
        ),
      ),
    );
  }
}
