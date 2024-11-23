import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/auth_pages/login_page.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/od_and_leave_page.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/select_class_page.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/view_timetable_page.dart';
import 'package:attendanceapp/services/auth_services.dart';
import 'package:attendanceapp/services/database_services.dart';
import 'package:attendanceapp/services/helper.dart';
import 'package:flutter/material.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  String email = "";
  String name = "Unknown";
  int selected = 0;
  List pages = [
    const SelectClassPage(),
    const ViewTimetablePage(),
  ];
  List<String> appbarTitle = [
    "Overview",
    "Timetable",
    "OD & Leave Permission",
  ];

  Future<bool> _initializeUserData() async {
    final userName = await Helper().gettingUserName();
    final userEmail = await Helper().gettingUserEmail();
    final userUid = await Helper().gettingUserUid();

    setState(() {
      name = userName;
      email = userEmail ?? "";
    });

    if (userUid != null) {
      var data = await DatabaseServices().gettingTeacherData(userUid);
      pages = [
        const SelectClassPage(),
        const ViewTimetablePage(),
        ODAndLeavePage(
          classDetails: data!.data()!["assignedClass"],
        ),
      ];
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appbarTitle[selected]),
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
              accountName: Text(
                  "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}"),
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
              selected: selected == 0 ? true : false,
              onTap: () {
                setState(() {
                  selected = 0;
                });
                Navigator.pop(context);
              },
              leading: const Icon(Icons.home),
              title: const Text("Overview"),
            ),
            ListTile(
              selected: selected == 1 ? true : false,
              onTap: () {
                setState(() {
                  selected = 1;
                });
                Navigator.pop(context);
              },
              leading: const Icon(Icons.table_chart_rounded),
              title: const Text("TimeTable"),
            ),
            ListTile(
              selected: selected == 2 ? true : false,
              onTap: () {
                setState(() {
                  selected = 2;
                });
                Navigator.pop(context);
              },
              leading: const Icon(Icons.assignment),
              title: const Text("OD & Leave Permission"),
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
      body: pages[selected],
    );
  }
}

class YearCard extends StatelessWidget {
  final String year;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const YearCard({
    super.key,
    required this.year,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(width: 16.0),
            Text(
              year,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
