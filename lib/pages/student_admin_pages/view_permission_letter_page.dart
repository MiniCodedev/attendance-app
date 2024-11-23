import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ViewPermissionLetterPage extends StatefulWidget {
  const ViewPermissionLetterPage({
    super.key,
    required this.name,
    required this.rollno,
    required this.content,
    required this.sub,
    required this.date,
  });

  final String name;
  final String rollno;
  final String sub;
  final String content;
  final String date;

  @override
  State<ViewPermissionLetterPage> createState() =>
      _ViewPermissionLetterPageState();
}

class _ViewPermissionLetterPageState extends State<ViewPermissionLetterPage> {
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
              ],
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
