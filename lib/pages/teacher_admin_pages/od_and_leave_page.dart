import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/view_permission_letter_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ODAndLeavePage extends StatefulWidget {
  const ODAndLeavePage({super.key, required this.classDetails});

  final String classDetails;

  @override
  State<ODAndLeavePage> createState() => _ODAndLeavePageState();
}

class _ODAndLeavePageState extends State<ODAndLeavePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("odAndLeave")
            .where("classdetails", isEqualTo: widget.classDetails)
            .where("status", isNull: true)
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No leave or OD permission applied."),
            );
          }

          var data = snapshot.data?.docs;
          return ListView.builder(
            itemCount: data!.length,
            itemBuilder: (context, index) {
              Map data_ = data[index].data() as Map;
              String sub = data_["sub"];
              Timestamp timestamp = data_['date'] ?? Timestamp(1, 1);
              DateTime dateTime = timestamp.toDate();
              String date =
                  "${dateTime.day}/${dateTime.month}/${dateTime.year}";
              String content = data_["content"];
              String name = data_["name"];
              String rollno = data_["rollno"];

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: permissionTileWidget(
                  id: data[index].id,
                  name: name,
                  rollno: rollno,
                  content: content,
                  sub: sub,
                  date: date,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget permissionTileWidget({
    required String name,
    required String rollno,
    required String content,
    required String sub,
    required String date,
    required String id,
  }) {
    return Card(
      color: AppColors.secondaryColor,
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewPermissionLetterPage(
                  id: id,
                  name: name,
                  rollno: rollno,
                  content: content,
                  date: date,
                  sub: sub,
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
