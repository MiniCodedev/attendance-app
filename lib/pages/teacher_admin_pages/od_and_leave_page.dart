import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/view_permission_letter_page.dart';
import 'package:flutter/material.dart';

class ODAndLeavePage extends StatefulWidget {
  const ODAndLeavePage({super.key});

  @override
  State<ODAndLeavePage> createState() => _ODAndLeavePageState();
}

class _ODAndLeavePageState extends State<ODAndLeavePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            permissionTileWidget(name: "Lalith", rollno: "2352525"),
            permissionTileWidget(name: "Pardha", rollno: "238528")
          ],
        ),
      ),
    );
  }

  Widget permissionTileWidget({required String name, required String rollno}) {
    return Card(
      color: AppColors.secondaryColor,
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewPermissionLetterPage(
                  name: name,
                  rollno: rollno,
                ),
              ));
        },
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(name[0],
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
        ),
        title: Text(
          name,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Rollno: $rollno",
            style: const TextStyle(color: Colors.white, fontSize: 13)),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
