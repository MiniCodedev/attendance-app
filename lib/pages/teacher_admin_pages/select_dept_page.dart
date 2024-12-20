import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/admin_pages/students_pages/add_student_page.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/attendance_page.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/student_list_page.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/view_attendance_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectDepartmentPage extends StatefulWidget {
  const SelectDepartmentPage({super.key, required this.year});

  final int year;

  @override
  State<SelectDepartmentPage> createState() => _SelectDepartmentPageState();
}

class _SelectDepartmentPageState extends State<SelectDepartmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Department"),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('students')
              .where("year", isEqualTo: widget.year)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            }
            final data = snapshot.requireData;

            Set<String> seenDepartments = {};
            List<QueryDocumentSnapshot> uniqueDepartments = [];

            for (var doc in data.docs) {
              String department = "${doc["department"]}${doc["section"]}";
              if (!seenDepartments.contains(department)) {
                seenDepartments.add(department);
                uniqueDepartments.add(doc);
              }
            }

            if (uniqueDepartments.isEmpty) {
              return const Center(
                child: Text("No department found"),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.builder(
                itemCount: uniqueDepartments.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var doc = uniqueDepartments[index];
                  return Column(
                    children: [
                      Department(
                        dept: doc["department"],
                        section: doc["section"],
                        icon: Icons.school_rounded,
                        color: AppColors.secondaryColor,
                        year: doc["year"],
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => const AddStudentPage()),
              );
            },
            child: const Text("Add student"),
          ),
        ));
  }
}

class OptionWidget extends StatelessWidget {
  const OptionWidget({
    super.key,
    required this.optionName,
    required this.icon,
    required this.onTap,
  });
  final String optionName;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      splashColor: Colors.grey[400],
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: Container(
          width: width / 1.3,
          margin: const EdgeInsets.symmetric(vertical: 2.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(81, 101, 58, 1),
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
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 16.0),
              SizedBox(
                child: Text(
                  optionName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Department extends StatefulWidget {
  final String dept;
  final IconData icon;
  final Color color;
  final String section;
  final int year;

  const Department({
    super.key,
    required this.dept,
    required this.icon,
    required this.color,
    required this.section,
    required this.year,
  });

  @override
  State<Department> createState() => _DepartmentState();
}

class _DepartmentState extends State<Department> {
  bool hide = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16.0),
          splashColor: Colors.grey[300],
          onTap: () {
            setState(() {
              if (hide) {
                hide = false;
              } else {
                hide = true;
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 5, left: 5),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: widget.color,
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
                  Icon(widget.icon, size: 25, color: Colors.white),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width / 1.8,
                        child: Text(
                          widget.dept,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "Section ${widget.section}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Icon(
                    hide
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_up_rounded,
                    size: 35,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
        hide
            ? Container()
            : SizedBox(
                width: width / 1.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    OptionWidget(
                        optionName: "Register attendance",
                        icon: Icons.assignment_add,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AttendancePage(
                                year: widget.year,
                                dept: widget.dept,
                                section: widget.section),
                          ));
                        }),
                    OptionWidget(
                        optionName: "View student ",
                        icon: Icons.people_alt_rounded,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => StudentListPage(
                                year: widget.year,
                                dept: widget.dept,
                                section: widget.section),
                          ));
                        }),
                    OptionWidget(
                        optionName: "View attendance ",
                        icon: Icons.assignment_turned_in,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewAttendancePage(
                              year: widget.year,
                              dept: widget.dept,
                              section: widget.section,
                            ),
                          ));
                        }),
                  ],
                ),
              )
      ],
    );
  }
}
