import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/student_admin_pages/request_permission_page.dart';
import 'package:flutter/material.dart';

class OdAndPermissionPage extends StatefulWidget {
  const OdAndPermissionPage({super.key});

  @override
  State<OdAndPermissionPage> createState() => _OdAndPermissionPageState();
}

class _OdAndPermissionPageState extends State<OdAndPermissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FilledButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const RequestPermissionPage(),
            ));
          },
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor)),
          child: const Text("Request Permission"),
        ),
      ),
    );
  }
}
