import "package:attendanceapp/constant.dart";
import "package:attendanceapp/pages/admin_pages/admin_home_page.dart";
import "package:attendanceapp/pages/admin_pages/students_pages/students_home_page.dart";
import "package:attendanceapp/pages/admin_pages/teachers_pages/teachers_home_page.dart";
import "package:attendanceapp/pages/auth_pages/login_page.dart";
import "package:attendanceapp/services/auth_services.dart";
import "package:flutter/material.dart";

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List pages = [
    const AdminHomePage(),
    const TeachersHomePage(),
    const StudentsHomePage(),
  ];

  List titlePage = ["Admin Portal", "Teacher Entry", "Student Entry"];

  int selected = 0;

  String title = "Admin Portal";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: pages[selected],
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              accountName: const Text("Admin"),
              accountEmail: const Text("admin@university.jpr"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 40.0, color: primaryColor),
                ),
              ),
            ),
            ListTile(
              selected: selected == 0 ? true : false,
              leading: const Icon(Icons.home_rounded),
              title: const Text('Admin Portal'),
              onTap: () {
                Navigator.pop(context); // Close the drawer

                setState(() {
                  selected = 0;
                  title = titlePage[selected];
                });
              },
            ),
            ListTile(
              selected: selected == 1 ? true : false,
              leading: const Icon(Icons.people),
              title: const Text('Teacher Entry'),
              onTap: () {
                Navigator.pop(context); // Close the drawer

                setState(() {
                  selected = 1;
                  title = titlePage[selected];
                });
              },
            ),
            ListTile(
              selected: selected == 2 ? true : false,
              leading: const Icon(Icons.people_rounded),
              title: const Text('Student Entry'),
              onTap: () {
                Navigator.pop(context); // Close the drawer

                setState(() {
                  selected = 2;
                  title = titlePage[selected];
                });
              },
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
    );
  }
}
