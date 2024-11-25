import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/select_dept_page.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(16.0),
              splashColor: Colors.grey[300],
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SelectDepartmentPage(year: 1),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Icon(Icons.looks_one_rounded,
                          size: 75, color: Colors.white),
                      Spacer(),
                      Text(
                        "First Year",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(16.0),
              splashColor: Colors.grey[300],
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SelectDepartmentPage(year: 2),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Icon(Icons.looks_two_rounded,
                          size: 75, color: Colors.white),
                      Spacer(),
                      Text(
                        "Second Year",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(16.0),
              splashColor: Colors.grey[300],
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SelectDepartmentPage(year: 3),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Icon(Icons.looks_3_rounded,
                          size: 75, color: Colors.white),
                      Spacer(),
                      Text(
                        "Third Year",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(16.0),
              splashColor: Colors.grey[300],
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SelectDepartmentPage(year: 4),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4.0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Icon(Icons.looks_4_rounded,
                          size: 75, color: Colors.white),
                      Spacer(),
                      Text(
                        "Fourth Year",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
