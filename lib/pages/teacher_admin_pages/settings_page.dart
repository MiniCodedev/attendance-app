import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/change_password_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.id,
  });

  final String name;
  final String email;
  final String password;
  final String id;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              radius: width / 4,
              child: Icon(
                Icons.person,
                size: width / 4,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  cardTile(
                    Icons.assignment_ind_rounded,
                    widget.id,
                    false,
                  ),
                  const SizedBox(height: 10),
                  cardTile(Icons.person, widget.name, false),
                  const SizedBox(height: 10),
                  cardTile(Icons.email_rounded, widget.email, false),
                  const SizedBox(height: 10),
                  cardTile(Icons.password_rounded, widget.password, true),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cardTile(IconData icon, String text, bool edit) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
        trailing: edit
            ? InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(
                        email: widget.email, password: widget.password),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Change password",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
