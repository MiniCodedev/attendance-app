import 'package:attendanceapp/core/theme/app_colors.dart';
import 'package:attendanceapp/pages/teacher_admin_pages/hour_attendance_page.dart';
import 'package:attendanceapp/services/database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewAttendanceDetailPage extends StatefulWidget {
  const ViewAttendanceDetailPage({
    super.key,
    required this.year,
    required this.dept,
    required this.section,
    required this.date,
    required this.data,
    required this.docId,
  });

  final int year;
  final String dept;
  final String section;
  final String date;
  final Map<String, bool> data;
  final String docId;

  @override
  State<ViewAttendanceDetailPage> createState() =>
      _ViewAttendanceDetailPageState();
}

class _ViewAttendanceDetailPageState extends State<ViewAttendanceDetailPage> {
  late TextEditingController _searchController;
  String date = "Select Date";

  Map<String, bool> attendance = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    attendance = widget.data;
    date = widget.date;
  }

  Stream<List<String>> checkRegisteredStream() async* {
    try {
      yield* FirebaseFirestore.instance
          .collection('attendances')
          .where('details',
              isEqualTo:
                  'year_${widget.year}_${widget.dept}_${widget.section.toUpperCase()}')
          .where("date", isEqualTo: date)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          Map data = snapshot.docs.first.data() as Map;
          return [
            data.containsKey("hour_1")
                ? "${data["teacher_1"][0]},${data["teacher_1"][1]}"
                : "Not Registered",
            data.containsKey("hour_2")
                ? "${data["teacher_2"][0]},${data["teacher_2"][1]}"
                : "Not Registered",
            data.containsKey("hour_3")
                ? "${data["teacher_3"][0]},${data["teacher_3"][1]}"
                : "Not Registered",
            data.containsKey("hour_4")
                ? "${data["teacher_4"][0]},${data["teacher_4"][1]}"
                : "Not Registered",
            data.containsKey("hour_5")
                ? "${data["teacher_5"][0]},${data["teacher_5"][1]}"
                : "Not Registered",
            data.containsKey("hour_6")
                ? "${data["teacher_6"][0]},${data["teacher_6"][1]}"
                : "Not Registered",
          ];
        } else {
          return [
            "Not Registered",
            "Not Registered",
            "Not Registered",
            "Not Registered",
            "Not Registered",
            "Not Registered"
          ];
        }
      });
    } catch (error) {
      yield [
        "Not Registered",
        "Not Registered",
        "Not Registered",
        "Not Registered",
        "Not Registered",
        "Not Registered"
      ];
    }
  }

  void updateAttendanceStatus(Map<String, bool> value) {
    attendance.addAll(value);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Attendance Record'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                                'Are you sure you want to delete ${widget.date} attendance record?'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Dismiss the dialog
                          },
                        ),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            DatabaseServices()
                                .deleteAttendanceRecord(widget.docId);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: GestureDetector(
              onTap: date != "Select Date"
                  ? null
                  : () async {
                      DateTime? dateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now());
                      if (dateTime != null) {
                        setState(() {
                          date =
                              "${dateTime.day.toString().length == 1 ? "0${dateTime.day}" : dateTime.day.toString()}-${dateTime.month.toString().length == 1 ? "0${dateTime.month}" : dateTime.month.toString()}-${dateTime.year}";
                        });
                      }
                    },
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 55,
                width: width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    border: Border.fromBorderSide(
                        BorderSide(color: AppColors.primaryColor, width: 2))),
                child: Row(
                  children: [
                    const Spacer(),
                    const Icon(
                      Icons.date_range_rounded,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: date == "Select Date"
                            ? Colors.black
                            : AppColors.primaryColor,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
          date == "Select Date"
              ? Container()
              : Expanded(
                  child: StreamBuilder<List<String>>(
                    stream: checkRegisteredStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No attendance records found.'));
                      }

                      List<String> isRecord = snapshot.data!;

                      return ListView.builder(
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          int hour = index + 1;

                          return HourTileWidget(
                            index: index,
                            subtext: isRecord[index],
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => HourAttendancePage(
                                  hour: hour,
                                  dept: widget.dept,
                                  section: widget.section,
                                  year: widget.year,
                                  date: date,
                                ),
                              ));
                            },
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class HourTileWidget extends StatefulWidget {
  const HourTileWidget({
    super.key,
    required this.index,
    required this.onTap,
    required this.subtext,
  });

  final int index;
  final Function() onTap;
  final String subtext;

  @override
  State<HourTileWidget> createState() => _HourTileWidgetState();
}

class _HourTileWidgetState extends State<HourTileWidget> {
  List<String> hours = [
    "First",
    "Second",
    "Third",
    "Fourth",
    "Fifth",
    "Sixth",
  ];

  List<IconData> icons = [
    Icons.looks_one_rounded,
    Icons.looks_two_rounded,
    Icons.looks_3_rounded,
    Icons.looks_4_rounded,
    Icons.looks_5_rounded,
    Icons.looks_6_rounded
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Card(
            color: AppColors.primaryColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Icon(
                    icons[widget.index],
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${hours[widget.index]} hour",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      Text(
                        "Teacher: ${widget.subtext != "Not Registered" ? widget.subtext.split(",")[0] : "Not Registered"}",
                        style: TextStyle(
                            fontSize: 10,
                            color: widget.subtext != "Not Registered"
                                ? Colors.green
                                : Colors.red),
                      ),
                      Text(
                        "ID: ${widget.subtext != "Not Registered" ? widget.subtext.split(",")[1] : "Not Registered"}",
                        style: TextStyle(
                            fontSize: 10,
                            color: widget.subtext != "Not Registered"
                                ? Colors.green
                                : Colors.red),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
          ),
        ));
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
