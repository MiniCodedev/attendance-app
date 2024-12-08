import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/attendance_page.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/hour_attendance_page.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/student_list_page.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/view_attendance_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage(
      {super.key, required this.teacherUid, required this.assignedClass});
  final String teacherUid;
  final List assignedClass;

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  List hourIcon = [
    Icons.looks_one_rounded,
    Icons.looks_two_rounded,
    Icons.looks_3_rounded,
    Icons.looks_4_rounded,
    Icons.looks_5_rounded,
    Icons.looks_6_rounded,
  ];

  Future<List<Map<String, String>>> fetchTeacherTimetable() async {
    List<Map<String, String>>? timetable;
    try {
      final firestore = FirebaseFirestore.instance;

      // Fetch all classes
      final facultiesSnapshot =
          await firestore.collection('facultiesForSubjects').get();

      Map<String, List<Map<String, String>>> tempTimetable = {};

      for (var classDoc in facultiesSnapshot.docs) {
        final course = classDoc.id;
        final selectedFaculty =
            Map<String, dynamic>.from(classDoc.data()['selectedFaculty'] ?? {});

        // Find subjects handled by the given teacher
        final subjectsForTeacher = selectedFaculty.entries
            .where((entry) => entry.value == widget.teacherUid)
            .map((entry) => entry.key)
            .toList();

        if (subjectsForTeacher.isNotEmpty) {
          // Fetch timetable for this course
          final timetableDoc =
              await firestore.collection('timetable').doc(course).get();
          final formattedTimetable = Map<String, List<dynamic>>.from(
              timetableDoc.data()?['formattedTimetable'] ?? {});

          // Map hour, course, and subject for each day
          formattedTimetable.forEach((day, subjects) {
            for (int hourIndex = 0; hourIndex < subjects.length; hourIndex++) {
              final subject = subjects[hourIndex];

              if (subjectsForTeacher.contains(subject)) {
                tempTimetable.update(
                  day.toLowerCase(),
                  (existingEntries) => [
                    ...existingEntries,
                    {
                      'hour': (hourIndex + 1).toString(),
                      'course': course,
                      'subject': subject,
                    },
                  ],
                  ifAbsent: () => [
                    {
                      'hour': (hourIndex + 1).toString(),
                      'course': course,
                      'subject': subject,
                    },
                  ],
                );
              }
            }
          });
        }
      }
      final todayIndex = DateTime.now().weekday - 1;
      final today =
          ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'][todayIndex];
      timetable = tempTimetable[today];
    } catch (e) {
      print("Error fetching teacher timetable: $e");
    }

    return timetable ?? [];
  }

  @override
  void initState() {
    super.initState();
    fetchTeacherTimetable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListView.builder(
                itemCount: widget.assignedClass.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String classDetails = widget.assignedClass[index];
                  return AssignedClass(
                    dept: classDetails.split("_")[2],
                    section: classDetails.split("_").last,
                    icon: Icons.school_rounded,
                    color: AppColors.secondaryColor,
                    year: int.tryParse(classDetails.split("_")[1])!,
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Today's Attendance",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<List<Map<String, String>>>(
                future: fetchTeacherTimetable(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No classes for today.'));
                  } else {
                    final timetable = snapshot.data!;

                    return ListView.builder(
                      itemCount: timetable.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final entry = timetable[index];
                        return Department(
                          hour: index + 1,
                          dept: "${entry["course"]?.split("_")[1]}",
                          section: entry["course"]!.split("_")[2],
                          icon: hourIcon[(int.tryParse(entry["hour"]!)! - 1)],
                          color: AppColors.secondaryColor,
                          year: int.tryParse(
                                  entry["course"]?.split("_")[0] ?? "1") ??
                              1,
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
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

class AssignedClass extends StatefulWidget {
  final String dept;
  final IconData icon;
  final Color color;
  final String section;
  final int year;

  const AssignedClass({
    super.key,
    required this.dept,
    required this.icon,
    required this.color,
    required this.section,
    required this.year,
  });

  @override
  State<AssignedClass> createState() => _AssignedClassState();
}

class _AssignedClassState extends State<AssignedClass> {
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
                          "${widget.dept} - (${widget.year} Year)",
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

class Department extends StatefulWidget {
  final String dept;
  final IconData icon;
  final Color color;
  final String section;
  final int year;
  final int hour;

  const Department({
    super.key,
    required this.dept,
    required this.icon,
    required this.color,
    required this.section,
    required this.year,
    required this.hour,
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
                          "${widget.dept} - (${widget.year} Year)",
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
                          var dateTime = DateTime.now();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HourAttendancePage(
                              hour: widget.hour,
                              dept: widget.dept,
                              section: widget.section,
                              year: widget.year,
                              date:
                                  "${dateTime.day.toString().length == 1 ? "0${dateTime.day}" : dateTime.day.toString()}-${dateTime.month.toString().length == 1 ? "0${dateTime.month}" : dateTime.month.toString()}-${dateTime.year}",
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
