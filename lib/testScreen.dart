import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/controller.dart';

class ScreenTest extends StatefulWidget {
  const ScreenTest({super.key});

  @override
  State<ScreenTest> createState() => _ScreenTestState();
}

class _ScreenTestState extends State<ScreenTest> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<Controller>(context, listen: false).getData();
    // Provider.of<Controller>(context, listen: false).getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<Controller>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              return Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Text("Date"), Text("Amt1"), Text("Amt2")],
                    ),
                    // Expanded(
                    //   child: ListView.builder(
                    //     itemCount: value.list[0]["barData"][0].length,
                    //     itemBuilder: (context, index) {
                    //       return Row(
                    //         children: [],
                    //       );
                    //     },
                    //   ),
                    // )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Widget listCustom(int count){
  //   return ListView.builder(
  //     itemCount:  value.list[0]["barData"][0],
  //     itemBuilder: (context, index) {

  //   },)
  // }
}
