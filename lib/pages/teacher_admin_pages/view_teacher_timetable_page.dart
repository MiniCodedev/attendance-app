import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewTeacherTimetablePage extends StatefulWidget {
  final String teacherUid;

  const ViewTeacherTimetablePage({super.key, required this.teacherUid});

  @override
  State<ViewTeacherTimetablePage> createState() =>
      _ViewTeacherTimetablePageState();
}

class _ViewTeacherTimetablePageState extends State<ViewTeacherTimetablePage> {
  final List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];
  Map<String, List<Map<String, String>>> teacherTimetable =
      {}; // day -> [{hour, course, subject}]

  @override
  void initState() {
    super.initState();
    fetchTeacherTimetable();
  }

  Future<void> fetchTeacherTimetable() async {
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

      setState(() {
        teacherTimetable = tempTimetable;
      });
    } catch (e) {
      print("Error fetching teacher timetable: $e");
    }
  }

  String formatCourseName(String course) {
    final parts = course.split('_');
    if (parts.length < 3) return course;

    final year = parts[0];
    final program = parts[1];
    final section = parts[2];

    final yearNumber = year[0]; // First character (e.g., 3 from "3_B.Tech")
    var formattedProgram = program; // Ensure proper format
    final sectionName = section.substring(0, 1); // Get section letter (e.g., A)

    return "$formattedProgram - ${sectionName.toUpperCase()} \n (year $yearNumber)";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: teacherTimetable.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index].toLowerCase();
                  final schedule = teacherTimetable[day] ?? [];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            days[index],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Table(
                            border: TableBorder.all(),
                            columnWidths: const {
                              0: FractionColumnWidth(0.2), // Hour
                              1: FractionColumnWidth(0.4), // Course
                              2: FractionColumnWidth(0.4), // Subject
                            },
                            children: [
                              // Header Row
                              const TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Hour',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Course',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Subject',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              // Data Rows
                              ...schedule.map((entry) {
                                return TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(entry['hour']!),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        formatCourseName(entry['course']!),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(entry['subject']!),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
