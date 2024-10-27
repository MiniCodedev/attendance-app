import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:attendanceapp/core/theme/app_colors.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({
    super.key,
    required this.name,
    required this.email,
    required this.department,
    required this.year,
    required this.presentDays,
    required this.absentDays,
    required this.attendancePercentage,
    required this.password,
    required this.rollno,
    required this.section,
    required this.totalWorkingDays,
  });

  final String email;
  final String name;

  final String department;
  final int year;
  final int presentDays;
  final int absentDays;
  final int totalWorkingDays;
  final double attendancePercentage;
  final String section;
  final String rollno;
  final String password;

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  String email = "";
  String name = "";
  bool isLoading = true;
  String department = "";
  int year = 0;
  int presentDays = 0;
  int absentDays = 0;
  int totalWorkingDays = 0;
  double attendancePercentage = 0;
  String section = "A";
  String rollno = "";
  String password = "";

  List<String> years = [
    "First Year",
    "Second Year",
    "Third Year",
    "Fourth Year"
  ];

  List<IconData> icons_ = [
    Icons.looks_one_rounded,
    Icons.looks_two_rounded,
    Icons.looks_3_rounded,
    Icons.looks_4_rounded
  ];

  @override
  void initState() {
    super.initState();
    email = widget.email;
    name = widget.name;
    department = widget.department;
    year = widget.year;
    presentDays = widget.presentDays;
    absentDays = widget.absentDays;
    totalWorkingDays = widget.totalWorkingDays;
    attendancePercentage = widget.attendancePercentage;
    section = widget.section;
    rollno = widget.rollno;
    password = widget.password;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    attendancePercentage = (presentDays / totalWorkingDays) * 100;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            "Attendance Summary",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildAttendanceCard(
                                "Present Days",
                                presentDays.toString(),
                                Colors.green,
                              ),
                              buildAttendanceCard(
                                "Absent Days",
                                absentDays.toString(),
                                Colors.red,
                              ),
                              buildAttendanceCard(
                                "Total Days",
                                totalWorkingDays.toString(),
                                Colors.blue,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Attendance Percentage",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 100,
                            child: CircularPercentIndicator(
                              radius: 50.0,
                              lineWidth: 10.0,
                              animation: true,
                              circularStrokeCap: CircularStrokeCap.round,
                              percent: presentDays / totalWorkingDays,
                              center: Text(
                                "${attendancePercentage.toStringAsFixed(2)}%",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              progressColor: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      cardTile(Icons.assignment_ind_rounded, rollno, width),
                      const SizedBox(height: 10),
                      cardTile(Icons.person, name, width),
                      const SizedBox(height: 10),
                      cardTile(Icons.email_rounded, email, width),
                      const SizedBox(height: 10),
                      cardTile(Icons.password_rounded, password, width),
                      const SizedBox(height: 10),
                      cardTile(Icons.group, "Section $section", width),
                      const SizedBox(height: 10),
                      cardTile(Icons.school_rounded, department, width),
                      const SizedBox(height: 10),
                      cardTile(icons_[year - 1], years[year - 1], width),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}

Widget cardTile(IconData icon, String text, double width) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(20))),
    child: Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: width / 1.5,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(color: Colors.white),
          ),
        )
      ],
    ),
  );
}

Widget buildAttendanceCard(String title, String value, Color color) {
  return Column(
    children: [
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}
