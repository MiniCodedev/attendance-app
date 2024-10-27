import 'package:attendanceapp/common/input_borders.dart';
import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/admin_pages/students_pages/show_student_details.dart';
import 'package:attendanceapp/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({
    super.key,
    required this.year,
    required this.dept,
    required this.section,
  });

  final int year;
  final String dept;
  final String section;

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  late TextEditingController _searchController;
  bool isLoading = true;
  Map percentageMap = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    DatabaseServices()
        .calculateAttendance(
      'year_${widget.year}_${widget.dept}_${widget.section.toUpperCase()}',
    )
        .then(
      (value) {
        setState(() {
          percentageMap = value;
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student List"),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextField(
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
                        focusedBorder: focusborder),
                    onChanged: (value) {
                      setState(() {
                        // Trigger rebuild to update the filtered list
                      });
                    },
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (snapshot.data == null ||
                            snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text('No students found.'));
                        }

                        // Filter documents based on search query
                        var filteredDocs = snapshot.data!.docs.where((doc) {
                          String name = doc['name'].toString().toLowerCase();
                          String rollno =
                              doc['rollno'].toString().toLowerCase();
                          String searchQuery =
                              _searchController.text.toLowerCase();
                          return name.contains(searchQuery) ||
                              rollno.contains(searchQuery);
                        }).toList();

                        // Build the list of students
                        return ListView.builder(
                          itemCount: filteredDocs.length,
                          itemBuilder: (context, index) {
                            var doc = filteredDocs[index];
                            return ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => ShowStudentDetails(
                                      rollno: doc['rollno'],
                                      name: doc['name'],
                                      email: doc['email'],
                                      password: doc['password'],
                                      year: doc['year'],
                                      section: doc['section'],
                                      department: doc['department'],
                                      dob: doc['dob'],
                                      uid: doc['uid']),
                                ));
                              },
                              leading: CircleAvatar(
                                child: Text(doc['name'][0]),
                              ),
                              title: Text(doc['name']),
                              subtitle: Text("Rollno: ${doc['rollno']}"),
                              trailing:
                                  Text("${percentageMap[doc['uid']] ?? 0}%"),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
