import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trafiqxpreports/components/customSnackbar.dart';
import 'package:trafiqxpreports/components/detailedGraph.dart';
import 'package:trafiqxpreports/controller/controller.dart';

import '../components/globalData.dart';


class DetailedInfoSheet {
  showInfoSheet(BuildContext context, String text) {
    // Size size = MediaQuery.of(context).size;
    // String? payment_mode;
    // CustomSnackbar snackbar = CustomSnackbar();
    // String imgGlobal = Globaldata.imageurl;

    var data = {
      "id": "6",
      "title": "Top 10 Sold Items",
      "graph": "1",
      "sum": "NY",
      "align": "LR",
      "width": "60,40",
      "data": [
        {"Itemname": "SHIRT", "Value": "20087733.00"},
        {"Itemname": "CHURIDHAR-UNSTICH", "Value": "14171079.00"},
        {"Itemname": "TOP", "Value": "13307524.00"},
        {"Itemname": "ARTSILK SAREE", "Value": "9315940.00"},
        {"Itemname": "SHIRTING", "Value": "9174190.39"},
        {"Itemname": "CHURIDAR (SS)", "Value": "7452024.00"},
        {"Itemname": "DHOTI DOUBLE", "Value": "7295473.00"},
        {"Itemname": "DRESS MATERIAL", "Value": "7173805.36"},
        {"Itemname": "TROUSER..", "Value": "6206084.00"},
        {"Itemname": "CHURIDHAR", "Value": "5882132.00"}
      ]
    };
    return showModalBottomSheet<void>(
      // isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Consumer<Controller>(
          builder: (context, value, child) {
            // return Text(text);
            var jsonEncoded = json.encode(data);
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                        ))
                  ],
                ),
                DetaildDataTable(
                  decodd: jsonEncoded,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
