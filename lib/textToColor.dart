import 'dart:math';

import 'package:flutter/material.dart';
import 'package:string_to_hex/string_to_hex.dart';

class TextToColor extends StatefulWidget {
  const TextToColor({super.key});

  @override
  State<TextToColor> createState() => _TextToColorState();
}

class _TextToColorState extends State<TextToColor> {
  int _counter = 5;
  String _string = '1tnuoma';
  String hexColor = 'The Hex String comes here';
  Color? generatedColor;
  int? generatedColorInt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(4278272051),
        title: Text(""),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // MaterialButton(
            //   child: Text('press to generate Color & HexString'),
            //   color: Color(generatedColorInt ?? 0xfff5f535),
            //   onPressed: () {
            //     setState(() {
            //       hexColor = getRandomString(_counter);
            //       _string = StringToHex.toHexString(_string);
            //       generatedColor = Color(StringToHex.toColor(_string));
            //       generatedColorInt = StringToHex.toColor(_string);
            //     });
            //   },
            // ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(generatedColorInt ?? 0xfff5f535),
                ),
                onPressed: () {
                  setState(() {
                    _string = StringToHex.toHexString(_string);
                    generatedColor = Color(StringToHex.toColor(_string));
                    generatedColorInt = StringToHex.toColor(_string);
                  });
                },
                child: Text("click")),
            // Text(
            //   '$_string',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
            Text(
              '$generatedColorInt',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
