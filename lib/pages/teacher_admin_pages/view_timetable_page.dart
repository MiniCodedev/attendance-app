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

  final List<String> exampleClasses = [
    "B.Tech - C.S.E - A (Year 1)",
    "B.Tech - C.S.E - B (Year 2)",
    "B.Tech - C.S.E - A (Year 3)",
    "B.Tech - C.S.E - B (Year 1)",
    "B.Tech - C.S.E - A (Year 2)",
    "B.Tech - C.S.E - B (Year 3)"
  ];

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
      //                 children: hours.asMap().entries.map((entry) {
      //                   int hourIndex = entry.key;
      //                   String hour = entry.value;
      //                   return TableRow(
      //                     children: [
      //                       Padding(
      //                         padding: const EdgeInsets.all(8.0),
      //                         child: Text('Hour $hour'),
      //                       ),
      //                       Padding(
      //                         padding: const EdgeInsets.all(8.0),
      //                         child: Text(
      //                           exampleClasses[
      //                               hourIndex % exampleClasses.length],
      //                           textAlign: TextAlign.center,
      //                         ),
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
