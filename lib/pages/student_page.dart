import "package:attendanceapp/core/theme/app_colors.dart";
import "package:attendanceapp/pages/auth_pages/login_page.dart";
import "package:attendanceapp/pages/student_admin_pages/od_and_permission_page.dart";
import "package:attendanceapp/pages/student_admin_pages/student_home_page.dart";
import "package:attendanceapp/pages/student_admin_pages/view_result_page.dart";
import "package:attendanceapp/pages/student_admin_pages/view_student_attendance_page.dart";
import "package:attendanceapp/pages/student_admin_pages/view_timetable_page.dart";
import "package:attendanceapp/services/auth_services.dart";
import "package:attendanceapp/services/database_services.dart";
import "package:attendanceapp/services/helper.dart";
import "package:flutter/material.dart";

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
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

  List<Widget> pages = [];

  int selected = 0;
  List<String> titleList = [
    "Overview",
    "View result",
    "View attedance",
    "View timetable",
    "OD & Leave Permission",
  ];

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
    Helper().gettingUserEmail().then(
      (value) {
        DatabaseServices().getStudentInformation(value ?? "").then(
          (value) {
            name = value["name"];
            email = value["email"];
            year = value["year"];
            section = value["section"];
            department = value["department"];
            rollno = value["rollno"];
            password = value["password"];
            DatabaseServices()
                .getStudentAttendance(
                    'year_${year}_${department}_${section.toUpperCase()}',
                    value["uid"])
                .then(
              (value) {
                attendancePercentage = value[0];
                presentDays = value[1];
                absentDays = value[2];
                totalWorkingDays = value[3];
                setState(() {
                  pages = [
                    StudentHomePage(
                      name: name,
                      email: email,
                      department: department,
                      year: year,
                      presentDays: presentDays,
                      absentDays: absentDays,
                      attendancePercentage: attendancePercentage,
                      password: password,
                      rollno: rollno,
                      section: section,
                      totalWorkingDays: totalWorkingDays,
                    ),
                    const ViewResultPage(),
                    ViewStudentAttendancePage(
                        year: year, dept: department, section: section),
                    const ViewTimetablePage(),
                    const OdAndPermissionPage(),
                  ];
                  isLoading = false;
                });
              },
            );
          },
        );
      },
    );
    attendancePercentage = (presentDays / totalWorkingDays) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleList[selected]),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
              ),
              accountName: Text(name.toUpperCase()),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  name == "" ? " " : name[0],
                  style:
                      TextStyle(fontSize: 40.0, color: AppColors.primaryColor),
                ),
              ),
            ),
            ListTile(
              selected: selected == 0,
              onTap: () {
                setState(() {
                  selected = 0;
                });
                Navigator.of(context).pop();
              },
              title: const Text("Overview"),
              leading: const Icon(Icons.home_rounded),
            ),
            ListTile(
              selected: selected == 1,
              onTap: () {
                setState(() {
                  selected = 1;
                });
                Navigator.of(context).pop();
              },
              title: const Text("View result"),
              leading: const Icon(Icons.bar_chart),
            ),
            ListTile(
              selected: selected == 2,
              onTap: () {
                setState(() {
                  selected = 2;
                });
                Navigator.of(context).pop();
              },
              title: const Text("View attendance"),
              leading: const Icon(Icons.event_available),
            ),
            ListTile(
              selected: selected == 3,
              onTap: () {
                setState(() {
                  selected = 3;
                });
                Navigator.of(context).pop();
              },
              title: const Text("View timetable"),
              leading: const Icon(Icons.table_chart_rounded),
            ),
            ListTile(
              selected: selected == 4,
              onTap: () {
                setState(() {
                  selected = 4;
                });
                Navigator.of(context).pop();
              },
              title: const Text("OD & Leave Permission"),
              leading: const Icon(Icons.assignment),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    AuthServices().signOut();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : pages[selected],
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
