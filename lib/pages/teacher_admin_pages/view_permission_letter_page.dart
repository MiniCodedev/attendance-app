import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/student_admin_pages/view_student_attendance_detail_page.dart';
import 'package:attendanceapp/services/database_services.dart';
import 'package:flutter/material.dart';

class ViewPermissionLetterPage extends StatefulWidget {
  const ViewPermissionLetterPage({
    super.key,
    required this.name,
    required this.rollno,
    required this.content,
    required this.sub,
    required this.date,
    required this.id,
  });

  final String name;
  final String rollno;
  final String sub;
  final String content;
  final String date;
  final String id;

  @override
  State<ViewPermissionLetterPage> createState() =>
      _ViewPermissionLetterPageState();
}

class _ViewPermissionLetterPageState extends State<ViewPermissionLetterPage> {
  DatabaseServices databaseServices = DatabaseServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        title: const Text("Permission Letter"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleWidget(text: "Form:"),
                  contentWidget(
                      textContent:
                          "${widget.name},\n${widget.rollno},\nJeppiaar University,\nChennai"),
                  const SizedBox(
                    height: 5,
                  ),
                  titleWidget(text: "Date: "),
                  contentWidget(textContent: widget.date),
                  const SizedBox(
                    height: 5,
                  ),
                  titleWidget(text: "Sub: "),
                  contentWidget(textContent: widget.sub),
                  const SizedBox(
                    height: 5,
                  ),
                  titleWidget(text: "Respected Sir/Madam, "),
                  contentWidget(
                    textContent: widget.content,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: FilledButton(
                      onPressed: () {
                        showLoadingDialog(context);
                        databaseServices
                            .updatePermission(id: widget.id, status: "admin")
                            .then(
                          (value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: const Text(
                        "Accept & Forward to Dean",
                      ),
                    ),
                  ),
                  Center(
                    child: FilledButton(
                      onPressed: () {
                        showLoadingDialog(context);
                        databaseServices
                            .updatePermission(id: widget.id, status: false)
                            .then(
                          (value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        );
                      },
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.red)),
                      child: const Text(
                        "Reject",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget titleWidget({required String text}) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget contentWidget({required String textContent}) {
    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 2, bottom: 10, right: 10, left: 10),
            child: Text(
              textContent,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
