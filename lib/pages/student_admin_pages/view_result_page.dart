import 'package:flutter/material.dart';

class ViewResultPage extends StatelessWidget {
  const ViewResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("No result found"),
      ),
      // body: ListView(
      //   children: const [
      //     ListTile(
      //       title: Text("CIA - 1"),
      //     ),
      //     ListTile(
      //       title: Text("CIA - 1"),
      //     )
      //   ],
      // ),
    );
  }
}
