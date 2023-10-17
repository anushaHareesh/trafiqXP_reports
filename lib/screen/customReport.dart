import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:trafiqxpreports/bottomSheet/detail.dart';

import '../components/commonColor.dart';
import '../components/graphDataTable.dart';
import '../controller/controller.dart';

class CustomReport extends StatefulWidget {
  // String tabId;

  // CustomReport(
  //     {required this.tabId, });

  @override
  State<CustomReport> createState() => _CustomReportState();
}

class _CustomReportState extends State<CustomReport> {
  ScrollController listScrollController = ScrollController();
  DetailedInfoSheet info = DetailedInfoSheet();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<Controller>(context, listen: false).loadReportData(
    //       context, widget.tabId, widget.fromdate, widget.tilldate);
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // color: Colors.yellow,
      child: Consumer<Controller>(
        builder: (context, value, child) {
          if (value.isReportLoading) {
            return Container(
              height: size.height * 0.8,
              child: SpinKitCircle(
                color: P_Settings.purple,
              ),
            );
          } else {
            if (value.list == null || value.list.length == 0) {
              return Container(
                height: size.height * 0.8,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height * 0.06,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                String br;
                                if (value.brId == null) {
                                  br = "0";
                                } else {
                                  br = value.brId!;
                                }
                                Provider.of<Controller>(context, listen: false)
                                    .loadReportData(
                                  context,
                                  value.tabId.toString(),
                                  value.fromDate.toString(),
                                  value.todate.toString(),
                                  br,
                                );
                                Provider.of<Controller>(context, listen: false)
                                    .setMenuClick(false);

                                // Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.red,
                              ))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Lottie.asset(
                        'asset/nodata.json',
                        height: size.height * 0.25,
                        width: size.height * 0.25,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  Container(
                    height: size.height * 0.04,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              String br;
                              if (value.brId == null) {
                                br = "0";
                              } else {
                                br = value.brId!;
                              }
                              Provider.of<Controller>(context, listen: false)
                                  .loadReportData(
                                context,
                                value.tabId.toString(),
                                value.fromDate.toString(),
                                value.todate.toString(),
                                br,
                              );
                              Provider.of<Controller>(context, listen: false)
                                  .setMenuClick(false);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: listScrollController,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: value.list.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            // FloatingActionButton.small(
                            //   onPressed: () {
                            //     if (listScrollController.hasClients) {
                            //       final position = listScrollController
                            //           .position.maxScrollExtent;
                            //       listScrollController.jumpTo(position);
                            //     }
                            //   },
                            //   child: Icon(Icons.arrow_drop_down),
                            // ),
                            customCard(size, value.list[index], index),
                            // FloatingActionButton.small(
                            //   onPressed: () {
                            //     if (listScrollController.hasClients) {
                            //       final position = listScrollController
                            //           .position.minScrollExtent;
                            //       listScrollController.jumpTo(position);
                            //     }
                            //   },
                            //   child: Icon(Icons.arrow_drop_up),
                            // ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }

  //////////////////////////////////////////////////////////////
  Widget customCard(size, Map listMap, int parentIndex) {
    return Consumer<Controller>(builder: (context, value, child) {
      int sum = 0;
      if (listMap["data"] != null && listMap["data"].length > 0) {
        final w = listMap["width"].split(',');
        for (int i = 0; i < w.length; i++) {
          sum = sum + int.parse(w[i]);
        }
      }
      // w.sum();
      print("adsASdsd----${sum}");
      var jsonEncoded = json.encode(listMap);
      return Container(
        child: Card(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // transform: Matrix4.translationValues(0.0, -18.0, 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          listMap["title"],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (listScrollController.hasClients) {
                            final position =
                                listScrollController.position.maxScrollExtent;
                            listScrollController.jumpTo(position);
                          }
                        },
                        icon: Icon(Icons.arrow_drop_down,
                            color: Colors.blue, size: 37),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                // transform: Matrix4.translationValues(0.0, -11.0, 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        value.date_criteria == "1"
                            ? "(${value.fromDate})"
                            : "(${value.fromDate} - ${value.todate})",
                        style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                            color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                // transform: Matrix4.translationValues(0.0, -16.0, 0.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: listMap["data"] == null || listMap["data"].length == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: size.height * 0.25,
                              child: Lottie.asset(
                                'asset/nodata.json',
                                height: size.height * 0.2,
                                width: size.height * 0.2,
                              ),
                            ),
                          ],
                        )
                      : Container(
                          height: (35 * listMap["data"].length) + 80 + 44,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      right: sum > 100 ? 1.8 : 0,
                                      bottom: 0), // ***
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // boxShadow: [
                                    //   sum > 100
                                    //       ? BoxShadow(
                                    //           color: Colors.green,
                                    //           blurRadius: 20,
                                    //           spreadRadius: 1,
                                    //           offset: Offset(0, -15),
                                    //         )
                                    //       : BoxShadow(
                                    //           // color: Colors.white,

                                    //           )
                                    // ],
                                  ),
                                  child: GraphDataTable(
                                    decodd: jsonEncoded,
                                    index: parentIndex,
                                    keyVal: listMap["search"],
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (listScrollController.hasClients) {
                                        final position = listScrollController
                                            .position.minScrollExtent;
                                        listScrollController.jumpTo(position);
                                      }
                                    },
                                    icon: Icon(Icons.arrow_drop_up,
                                        color: Colors.blue, size: 37),
                                  ),
                                ],
                              ),
                            ],
                          )),
                ),
              ),
              //  Divider(thickness: 2,color: Colors.black,)
            ],
          ),
        ),
      );
    });
  }
}
