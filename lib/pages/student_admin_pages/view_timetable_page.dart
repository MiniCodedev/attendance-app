import 'package:flutter/material.dart';

class ViewTimetablePage extends StatefulWidget {
  const ViewTimetablePage({super.key});

  @override
  State<ViewTimetablePage> createState() => _ViewTimetablePageState();
}

class _ViewTimetablePageState extends State<ViewTimetablePage> {
  final List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];
  final List<String> hours = ["1", "2", "3", "4", "5", "6"];

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("No timetable found"),
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(10.0),
      //   child: ListView.builder(
      //     itemCount: days.length,
      //     itemBuilder: (context, index) {
      //       return Card(
      //         elevation: 3,
      //         margin: const EdgeInsets.symmetric(vertical: 8),
      //         child: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                 days[index],
      //                 style: const TextStyle(
      //                     fontSize: 18, fontWeight: FontWeight.bold),
      //               ),
      //               const SizedBox(height: 8),
      //               Table(
      //                 border: TableBorder.all(),
      //                 children: hours.map((hour) {
      //                   return TableRow(
      //                     children: [
      //                       Padding(
      //                         padding: const EdgeInsets.all(8.0),
      //                         child: Text('Hour $hour'),
      //                       ),
      //                       const Padding(
      //                         padding: EdgeInsets.all(8.0),
      //                         child: Text('Subject/Activity'),
      //                       ),
      //                     ],
      //                   );
      //                 }).toList(),
      //               ),
      //             ],
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
