import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ViewPermissionLetterPage extends StatefulWidget {
  const ViewPermissionLetterPage(
      {super.key, required this.name, required this.rollno});

  final String name;
  final String rollno;

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
                  contentWidget(textContent: "10/10/2024"),
                  const SizedBox(
                    height: 5,
                  ),
                  titleWidget(text: "Sub: "),
                  contentWidget(
                      textContent: "Requesting permission for going to home"),
                  const SizedBox(
                    height: 5,
                  ),
                  titleWidget(text: "Respected Sir/Madam, "),
                  contentWidget(
                    textContent:
                        "I am requesting you to grant me permission for going out of hostel from 12/11/2024 - 11/11/2024 to meet our clients. Please kindly grant me the permission.\n\nYours Faithfully, \n     ${widget.name}",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: FilledButton(
                      onPressed: () {},
                      child: const Text(
                        "Accept & Forward to Dean",
                      ),
                    ),
                  ),
                  Center(
                    child: FilledButton(
                      onPressed: () {},
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
