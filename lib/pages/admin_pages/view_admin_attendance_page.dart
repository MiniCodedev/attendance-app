import 'package:attendanceapp/common/input_borders.dart';
import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/student_admin_pages/view_student_attendance_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewAdminAttendancePage extends StatefulWidget {
  const ViewAdminAttendancePage({
    super.key,
    required this.year,
    required this.dept,
    required this.section,
  });
  final int year;
  final String dept;
  final String section;

  @override
  State<ViewAdminAttendancePage> createState() =>
      _ViewAdminAttendancePageState();
}

class _ViewAdminAttendancePageState extends State<ViewAdminAttendancePage> {
  late TextEditingController _searchController;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Attendance"),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  hintText: "Search by date (e.g., 20-10-2024)",
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.primaryColor,
                  ),
                  errorBorder: errorBroder,
                  border: border,
                  enabledBorder: border,
                  enabled: true,
                  focusedBorder: focusborder),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('attendances')
                  .where('details',
                      isEqualTo:
                          'year_${widget.year}_${widget.dept}_${widget.section.toUpperCase()}')
                  .orderBy("date")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No attendance records found.'));
                }

                var filteredDocs = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  String date = data["date"];
                  return date.contains(searchQuery);
                }).toList();

                // Build the list of attendance records
                return ListView.builder(
                  itemCount: filteredDocs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var doc = filteredDocs[index];
                    var data = doc.data() as Map<String, dynamic>;

                    Map<dynamic, dynamic> originalMap = data["attendance"];

                    Map<String, bool> convertedMap = Map.fromEntries(
                      originalMap.entries.map(
                        (entry) =>
                            MapEntry(entry.key.toString(), entry.value as bool),
                      ),
                    );

                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewStudentAttendanceDetailPage(
                              docId: doc.id,
                              year: widget.year,
                              dept: widget.dept,
                              section: widget.section,
                              date: data["date"],
                              data: convertedMap),
                        ));
                      },
                      leading: const Icon(Icons.assignment),
                      title: Text(data["date"]),
                      subtitle: const Text("Odd Semester"),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
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
