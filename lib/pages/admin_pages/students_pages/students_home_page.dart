import 'package:attendanceapp/constant.dart';
import 'package:attendanceapp/pages/admin_pages/students_pages/add_student_page.dart';
import 'package:attendanceapp/pages/admin_pages/students_pages/show_student_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentsHomePage extends StatefulWidget {
  const StudentsHomePage({super.key});

  @override
  State<StudentsHomePage> createState() => _StudentsHomePageState();
}

class _StudentsHomePageState extends State<StudentsHomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, right: 10, left: 10, bottom: 10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: "Search by roll number",
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: primaryColor,
                    ),
                    errorBorder: errorBroder,
                    border: border,
                    enabledBorder: border,
                    enabled: true,
                    focusedBorder: focusborder),
                onChanged: (value) {
                  setState(() {}); // Refresh UI based on search input
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('students')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('No data available'));
                  }

                  final data = snapshot.requireData;
                  List<DocumentSnapshot> filteredStudents =
                      data.docs.where((doc) {
                    // Filter based on roll number
                    String searchTerm = _searchController.text.toLowerCase();
                    String rollno = doc['rollno'].toLowerCase();
                    return rollno.contains(searchTerm);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      var doc = filteredStudents[index];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ShowStudentDetails(
                              rollno: doc["rollno"],
                              name: doc["name"],
                              department: doc["department"],
                              year: doc["year"],
                              email: doc["email"],
                              password: doc["password"],
                              dob: doc["dob"],
                              section: doc["section"],
                              uid: doc["uid"],
                            ),
                          ));
                        },
                        leading: const Icon(Icons.person),
                        title: Text(doc['name']),
                        subtitle: Text(doc['rollno']),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddStudentPage()),
              );
            },
            child: const Text("Add student"),
          ),
        ),
      ),
    );
  }
}
