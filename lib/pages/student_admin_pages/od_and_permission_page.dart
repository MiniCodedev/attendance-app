import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/student_admin_pages/request_permission_page.dart';
import 'package:attendanceapp/pages/student_admin_pages/view_permission_letter_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OdAndPermissionPage extends StatefulWidget {
  const OdAndPermissionPage({
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
  State<OdAndPermissionPage> createState() => _OdAndPermissionPageState();
}

class _OdAndPermissionPageState extends State<OdAndPermissionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("odAndLeave")
            .where("email", isEqualTo: widget.email)
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No leave or OD permission applied."),
            );
          }

          var data = snapshot.data?.docs;
          return ListView.builder(
            itemCount: data?.length,
            itemBuilder: (context, index) {
              Map data_ = data![index].data() as Map;
              String sub = data_["sub"];

              Timestamp timestamp = data_['date'] ?? Timestamp(1, 1);
              DateTime dateTime = timestamp.toDate();
              String date =
                  "${dateTime.day}/${dateTime.month}/${dateTime.year}";
              String content = data_["content"];
              String name = data_["name"];
              String rollno = data_["rollno"];
              String status = data_["status"] == null
                  ? "Pending"
                  : data_["status"] == "rejected"
                      ? "Rejected"
                      : data_["status"] == "teacher"
                          ? "Approved by teacher"
                          : "Approved by Dean";
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewPermissionLetterPage(
                      date: date,
                      content: content,
                      name: name,
                      rollno: rollno,
                      sub: sub,
                    ),
                  ));
                },
                leading: const Icon(Icons.assignment_rounded),
                title: Text(sub),
                subtitle: Text(status),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FilledButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RequestPermissionPage(
                  name: widget.name,
                  email: widget.email,
                  rollno: widget.rollno,
                  department: widget.department,
                  section: widget.section,
                  year: widget.year),
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
