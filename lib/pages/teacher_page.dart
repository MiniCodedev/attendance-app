import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/auth_pages/login_page.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/select_department.dart';
import 'package:attendanceapp/services/auth_services.dart';
import 'package:attendanceapp/services/helper.dart';
import 'package:flutter/material.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  String email = "";
  String name = "";
  int selected = 1;

  @override
  void initState() {
    super.initState();
    Helper().gettingUserName().then(
      (value) {
        setState(() {
          name = value;
        });
      },
    );
    Helper().gettingUserEmail().then(
      (value) {
        setState(() {
          email = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department'),
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
              selected: selected == 1 ? true : false,
              onTap: () {
                setState(() {
                  selected = 1;
                });
                Navigator.pop(context);
              },
              leading: const Icon(Icons.looks_one),
              title: const Text("First Year"),
            ),
            ListTile(
              selected: selected == 2 ? true : false,
              onTap: () {
                setState(() {
                  selected = 2;
                });
                Navigator.pop(context);
              },
              leading: const Icon(Icons.looks_two),
              title: const Text("Second Year"),
            ),
            ListTile(
              selected: selected == 3 ? true : false,
              onTap: () {
                setState(() {
                  selected = 3;
                });
                Navigator.pop(context);
              },
              leading: const Icon(Icons.looks_3),
              title: const Text("Third Year"),
            ),
            ListTile(
              selected: selected == 4 ? true : false,
              onTap: () {
                setState(() {
                  selected = 4;
                });
                Navigator.pop(context);
              },
              leading: const Icon(Icons.looks_4),
              title: const Text("Fourth Year"),
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
      body: SelectDepartmentPage(
        year: selected,
      ),
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
