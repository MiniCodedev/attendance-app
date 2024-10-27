import 'package:attendanceapp/common/input_borders.dart';
import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/admin_pages/teachers_pages/add_teacher_page.dart';
import 'package:attendanceapp/pages/admin_pages/teachers_pages/show_teacher_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeachersHomePage extends StatefulWidget {
  const TeachersHomePage({
    super.key,
  });

  @override
  State<TeachersHomePage> createState() => _TeachersHomePageState();
}

class _TeachersHomePageState extends State<TeachersHomePage> {
  late TextEditingController _searchController;

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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    hintText: "Search by id",
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
                  setState(() {}); // Refresh UI based on search input
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('teachers')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('No data available'));
                  }
                  final data = snapshot.requireData;

                  // Filter the data based on search text
                  List<DocumentSnapshot> filteredData = data.docs.where((doc) {
                    String searchTerm = _searchController.text.toLowerCase();
                    String teacherId = doc['id'].toString().toLowerCase();
                    return teacherId.contains(searchTerm);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      var doc = filteredData[index];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ShowTeacherDetails(
                              id: doc["id"],
                              name: doc["name"],
                              email: doc["email"],
                              paswd: doc["password"],
                              uid: doc["uid"],
                            ),
                          ));
                        },
                        leading: const Icon(Icons.person),
                        title: Text(doc['name']),
                        subtitle: Text(doc['id']),
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
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTeacherPage()),
              );
            },
            child: const Text("Add teacher"),
          ),
        ),
      ),
    );
  }
}
