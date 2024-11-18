import 'package:flutter/material.dart';

class ViewResultPage extends StatelessWidget {
  const ViewResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          ListTile(
            title: Text("CIA - 1"),
          ),
          ListTile(
            title: Text("CIA - 1"),
          )
        ],
      ),
    );
  }
}
