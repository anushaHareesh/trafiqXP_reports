import 'package:flutter/material.dart';
import 'dart:collection';

class ScrollToEnd extends StatefulWidget {
  const ScrollToEnd({super.key});

  @override
  State<ScrollToEnd> createState() => _ScrollToEndState();
}

class _ScrollToEndState extends State<ScrollToEnd> {
  ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hsajsh"),
      ),

      // Floating action button. Functionality to be implemented
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (listScrollController.hasClients) {
            final position = listScrollController.position.maxScrollExtent;
            listScrollController.jumpTo(position);
          }
        },
        isExtended: true,
        tooltip: "Scroll to Bottom",
        child: Icon(Icons.arrow_downward),
      ),

      // Simple List of 100 items
      body: ListView.builder(
        controller: listScrollController,
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Item ${index + 1}"),
          );
        },
      ),
    );
  }
}
