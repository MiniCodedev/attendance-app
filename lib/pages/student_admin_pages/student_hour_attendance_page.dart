import 'package:attendanceapp/common/input_borders.dart';
import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentHourAttendancePage extends StatefulWidget {
  const StudentHourAttendancePage({
    super.key,
    required this.hour,
    required this.dept,
    required this.section,
    required this.year,
    required this.date,
  });

  final int hour;
  final String dept;
  final String section;
  final int year;
  final String date;

  @override
  State<StudentHourAttendancePage> createState() =>
      _StudentHourAttendancePageState();
}

class _StudentHourAttendancePageState extends State<StudentHourAttendancePage> {
  List<String> hours = [
    "First",
    "Second",
    "Third",
    "Fourth",
    "Fifth",
    "Sixth",
  ];
  String docId = "";

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  bool isNew = false;
  List<String> studentUids = [];
  bool isLoading = true;
  Map<String, bool> attendance = {};
  List<String> teacher = [];

  @override
  void initState() {
    super.initState();
    fetchInitialStudentUids();
  }

  void updateAttendanceStatus(Map<String, bool> value) {
    attendance.addAll(value);
  }

  Future<void> fetchInitialStudentUids() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('department', isEqualTo: widget.dept)
          .where('section', isEqualTo: widget.section)
          .where("year", isEqualTo: widget.year)
          .get();
      QuerySnapshot checkAttendance = await FirebaseFirestore.instance
          .collection('attendances')
          .where('details',
              isEqualTo:
                  'year_${widget.year}_${widget.dept}_${widget.section.toUpperCase()}')
          .where("hour_${widget.hour}")
          .where("date", isEqualTo: widget.date)
          .get();

      if (checkAttendance.docs.isNotEmpty) {
        Map checkData = checkAttendance.docs.first.data() as Map;
        if (checkData.containsKey("hour_${widget.hour}")) {
          var data = checkAttendance.docs.first.data() as Map<String, dynamic>;
          Map<dynamic, dynamic> originalMap =
              data["hour_${widget.hour}"] as Map;

          Map<String, bool> convertedMap = Map.fromEntries(
            originalMap.entries.map(
              (entry) => MapEntry(entry.key.toString(), entry.value as bool),
            ),
          );

          attendance.addAll(convertedMap);
        } else {
          studentUids =
              snapshot.docs.map((doc) => doc['uid'] as String).toList();
          for (String i in studentUids) {
            attendance.addAll({i: true});
          }
        }
        docId = checkAttendance.docs.first.id;
      } else {
        studentUids = snapshot.docs.map((doc) => doc['uid'] as String).toList();
        for (String i in studentUids) {
          attendance.addAll({i: true});
        }
        isNew = true;
      }

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${hours[widget.hour - 1]} Hour Attendance"),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search by name or roll number",
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppColors.primaryColor,
                      ),
                      errorBorder: errorBroder,
                      border: border,
                      enabledBorder: border,
                      enabled: true,
                      focusedBorder: focusborder,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('students')
                        .where('department', isEqualTo: widget.dept)
                        .where('section', isEqualTo: widget.section)
                        .where("year", isEqualTo: widget.year)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No students found.'));
                      }

                      var filteredDocs = snapshot.data!.docs.where((doc) {
                        var data = doc.data() as Map<String, dynamic>;
                        var name = data['name'].toString().toLowerCase();
                        var rollno = data['rollno'].toString().toLowerCase();
                        return name.contains(_searchQuery) ||
                            rollno.contains(_searchQuery);
                      }).toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          var doc = filteredDocs[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            child: StudentTile(
                              dept: doc["department"],
                              name: doc["name"],
                              rollno: doc["rollno"],
                              section: doc["section"],
                              uid: doc["uid"],
                              year: doc["year"],
                              status: attendance[doc["uid"]] ?? false,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const LoadingDialog();
    },
  );
}

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 15),
            Text("Loading, please wait..."),
          ],
        ),
      ),
    );
  }
}

class StudentTile extends StatefulWidget {
  const StudentTile({
    super.key,
    required this.dept,
    required this.section,
    required this.uid,
    required this.year,
    required this.name,
    required this.rollno,
    required this.status,
  });

  final int year;
  final String dept;
  final String section;
  final String uid;
  final String name;
  final String rollno;
  final bool status;

  @override
  State<StudentTile> createState() => _StudentTileState();
}

class _StudentTileState extends State<StudentTile> {
  bool isPresent = true;
  bool status = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      isPresent = widget.status;
      status = widget.status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: ShapeBorder.lerp(
          const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          10),
      tileColor: isPresent ? Colors.green : Colors.red,
      onTap: null,
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          widget.name[0],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(widget.name),
      subtitle: Text("Rollno: ${widget.rollno}"),
      trailing: Text(isPresent ? "Present" : "Absent"),
    );
  }
}
