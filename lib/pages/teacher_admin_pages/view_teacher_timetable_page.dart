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
  Map<String, List<Map<String, String>>> teacherTimetable = {};

  Future<Map<String, List<Map<String, String>>>> fetchTeacherTimetable() async {
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

      return tempTimetable;
    } catch (e) {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, List<Map<String, String>>>>(
        future: fetchTeacherTimetable(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong."),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("There is no timetable available."),
            );
          }

          // Use snapshot.data directly
          final timetableData = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index].toLowerCase();
                final schedule = timetableData[day] ?? []; // Use snapshot data

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
                        if (schedule.isEmpty)
                          const Text("No schedule for this day."),
                        if (schedule.isNotEmpty)
                          Table(
                            border: TableBorder.all(),
                            columnWidths: const {
                              0: FractionColumnWidth(0.2), // Hour
                              1: FractionColumnWidth(0.4), // Course
                              2: FractionColumnWidth(0.4), // Subject
                            },
                            children: [
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
                              ...schedule.map((entry) {
                                return TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(entry['hour']!),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(entry['course']!),
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
          );
        },
      ),
    );
  }
}
