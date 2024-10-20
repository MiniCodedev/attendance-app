import 'package:attendanceapp/constant.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewStudentAttendancewithdate extends StatefulWidget {
  final String studentUid;
  final String department;
  final String section;
  final int year;

  const ViewStudentAttendancewithdate({
    super.key,
    required this.studentUid,
    required this.department,
    required this.section,
    required this.year,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ViewStudentAttendancewithdateState createState() =>
      _ViewStudentAttendancewithdateState();
}

class _ViewStudentAttendancewithdateState
    extends State<ViewStudentAttendancewithdate> {
  DateTimeRange? dateRange;
  List<Map<String, dynamic>> attendanceData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Attendance"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    dateRange = picked;
                    fetchAttendanceData(picked);
                  });
                }
              },
              child: Text(
                dateRange == null
                    ? 'Select Date Range'
                    : '${DateFormat('yyyy-MM-dd').format(dateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(dateRange!.end)}',
              ),
            ),
          ),
          dateRange == null
              ? Container()
              : Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingTextStyle: const TextStyle(color: Colors.white),
                      headingRowColor: WidgetStatePropertyAll(primaryColor),
                      columns: const [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Hour 1')),
                        DataColumn(label: Text('Hour 2')),
                        DataColumn(label: Text('Hour 3')),
                        DataColumn(label: Text('Hour 4')),
                        DataColumn(label: Text('Hour 5')),
                        DataColumn(label: Text('Hour 6')),
                        DataColumn(label: Text('Overall')),
                      ],
                      rows: attendanceData.map((entry) {
                        return DataRow(
                          cells: [
                            DataCell(Text(entry['date'])),
                            DataCell(Text(
                              entry['hour_1'] ? 'Present' : 'Absent',
                              style: TextStyle(
                                  color: entry['hour_1']
                                      ? Colors.green
                                      : Colors.red),
                            )),
                            DataCell(Text(
                                entry['hour_2'] ? 'Present' : 'Absent',
                                style: TextStyle(
                                    color: entry['hour_2']
                                        ? Colors.green
                                        : Colors.red))),
                            DataCell(Text(
                                entry['hour_3'] ? 'Present' : 'Absent',
                                style: TextStyle(
                                    color: entry['hour_3']
                                        ? Colors.green
                                        : Colors.red))),
                            DataCell(Text(
                                entry['hour_4'] ? 'Present' : 'Absent',
                                style: TextStyle(
                                    color: entry['hour_4']
                                        ? Colors.green
                                        : Colors.red))),
                            DataCell(Text(
                                entry['hour_5'] ? 'Present' : 'Absent',
                                style: TextStyle(
                                    color: entry['hour_5']
                                        ? Colors.green
                                        : Colors.red))),
                            DataCell(Text(
                                entry['hour_6'] ? 'Present' : 'Absent',
                                style: TextStyle(
                                    color: entry['hour_6']
                                        ? Colors.green
                                        : Colors.red))),
                            DataCell(Text(
                                entry['overall'] ? "Present" : "Absent",
                                style: TextStyle(
                                    color: entry['overall']
                                        ? Colors.green
                                        : Colors.red))),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void fetchAttendanceData(DateTimeRange range) async {
    CollectionReference attendanceRef =
        FirebaseFirestore.instance.collection('attendances');

    QuerySnapshot snapshot = await attendanceRef
        .where('date',
            isGreaterThanOrEqualTo:
                DateFormat('dd-MM-yyyy').format(range.start))
        .where('date',
            isLessThanOrEqualTo: DateFormat('dd-MM-yyyy').format(range.end))
        .where('details',
            isEqualTo:
                'year_${widget.year}_${widget.department}_${widget.section}')
        .get();

    List<Map<String, dynamic>> tempData = [];
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data.containsKey("hour_1") &&
          data.containsKey("hour_2") &&
          data.containsKey("hour_3") &&
          data.containsKey("hour_4") &&
          data.containsKey("hour_5") &&
          data.containsKey("hour_6")) {
        String date = data['date'];

        bool hour1 = data['hour_1']?[widget.studentUid] ?? false;
        bool hour2 = data['hour_2']?[widget.studentUid] ?? false;
        bool hour3 = data['hour_3']?[widget.studentUid] ?? false;
        bool hour4 = data['hour_4']?[widget.studentUid] ?? false;
        bool hour5 = data['hour_5']?[widget.studentUid] ?? false;
        bool hour6 = data['hour_6']?[widget.studentUid] ?? false;

        tempData.add({
          'date': date,
          'hour_1': hour1,
          'hour_2': hour2,
          'hour_3': hour3,
          'hour_4': hour4,
          'hour_5': hour5,
          'hour_6': hour6,
          'overall': data['attendance'][widget.studentUid],
        });
      }
    }

    setState(() {
      attendanceData = tempData;
    });
  }
}
