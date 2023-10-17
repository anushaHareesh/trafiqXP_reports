import 'dart:convert';

import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:string_to_hex/string_to_hex.dart';
import 'package:trafiqxpreports/components/commonColor.dart';
import 'package:trafiqxpreports/screen/get_storage_util.dart';

import '../../components/graphDataTable.dart';
import '../../controller/controller.dart';

class TabbarClickPage extends StatefulWidget {
  String tabId;
  String b_id;
  TabbarClickPage({required this.tabId, required this.b_id});

  @override
  State<TabbarClickPage> createState() => _TabbarClickPageState();
}

class _TabbarClickPageState extends State<TabbarClickPage> {
  DateTime now = DateTime.now();
  // var jsonEncoded;
  String? todaydate;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool show = false;
  bool showGraph = false;
  String? _string;
  Color? generatedColor;
  int? generatedColorInt;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  // final searchController = TextEditingController();
//////////////////////////////////////////////////////////////
  List<dynamic> filteredData = [];
  Color parseColor(String color) {
    print("Colorrrrr...$color");
    String hex = color.replaceAll("#", "");
    if (hex.isEmpty) hex = "ffffff";
    if (hex.length == 3) {
      hex =
          '${hex.substring(0, 1)}${hex.substring(0, 1)}${hex.substring(1, 2)}${hex.substring(1, 2)}${hex.substring(2, 3)}${hex.substring(2, 3)}';
    }
    Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
    return col;
  }

  ///////////////////////////////////////
  // textToColor(String id, String title, String index) {
  //   DateTime date = DateTime.now();
  //   print("date------$date");
  //   String sdte = DateFormat('ddMM').format(date);
  //   print("iso ----${sdte}");
  //   print(
  //       "dgdh---${Provider.of<Controller>(context, listen: false).tab_index.toString()} ----------$index");
  //   String reverseId = id.split('').reversed.join('');
  //   String sCon = reverseId + sdte + title;
  //   // String reverseStr = sCon.split('').reversed.join('');
  //   try {
  //     _string = StringToHex.toHexString(sCon);
  //     generatedColor = Color(StringToHex.toColor(_string));
  //     print("str-----$generatedColor");
  //   } catch (e) {
  //     String sCon2 = id + "1002";
  //     _string = StringToHex.toHexString(sCon2);
  //     generatedColor = Color(StringToHex.toColor(_string));
  //     print("str-----$generatedColor");
  //   }

  //   // Provider.of<Controller>(context, listen: false)
  //   //     .setColor(generatedColor!, id);
  //   return generatedColor;
  // }

  colorGeneration(Map map) {
    print("from bar----$map");
  }

//////////////////////////////////////////////////////////////
  String description = "djHDjhDjHDhjsddddddddddddddddd";
  void initState() {
    // TODO: implement initState
    super.initState();

    todaydate = DateFormat('dd-MM-yyyy').format(now);

    String br;
    if (widget.b_id == null) {
      br = "0";
    } else {
      br = widget.b_id;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Controller>(context, listen: false)
          .setMenuindex(widget.tabId.toString());
      // checkShred(br);
      Provider.of<Controller>(context, listen: false).loadReportData(
        context,
        widget.tabId,
        todaydate,
        todaydate,
        br,
      );
    });
  }

  checkShred(String br) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = widget.tabId + "key";
    final rawJson = prefs.getString(key) ?? '';
    print("rawjson----$br--$key---$rawJson");
    if (rawJson == null || rawJson.isEmpty) {
      Provider.of<Controller>(context, listen: false).loadReportData(
        context,
        widget.tabId,
        todaydate,
        todaydate,
        br,
      );
    } else {
      List<Map<String, dynamic>> map = [];
      map = (jsonDecode(rawJson) as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
      // var map1 = jsonDecode(rawJson);
      // map.clear();
      // for (var item in map1) {
      //   map.add(item);
      // }
      await Provider.of<Controller>(context, listen: false)
          .loaclStorageData(map);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final ScrollController _firstController = ScrollController();
    return SingleChildScrollView(
      key: _keyLoader,
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
                height: size.height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'asset/nodata.json',
                      height: size.height * 0.25,
                      width: size.height * 0.25,
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: value.list.length,
                itemBuilder: (context, index) {
                  return customCard(size, value.list[index], index);
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget customCard(size, Map listMap, int parentIndex) {
    return Consumer<Controller>(
      builder: (context, value, child) {
        print("listMap[] =------${listMap["data"]}");
        if (listMap["data"] == null || listMap["data"].length == 0) {
          return Card(
            // elevation: 4,
            child: Container(
              height: size.height * 0.4,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(
                        listMap["title"].toString().toUpperCase(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Lottie.asset(
                      'asset/nodata.json',
                      height: size.height * 0.25,
                      width: size.height * 0.25,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          var jsonEncoded = json.encode(listMap);
          // Provider.of<Controller>(context, listen: false)
          //     .setjsonEncode(jsonEncoded);
          // print("suishuisfhuidh-----------------${jsonEncoded}");
          List<dynamic> listdata = listMap["data"];
          Provider.of<Controller>(context, listen: false)
              .getLegends(listdata, listMap["title"]);
          Provider.of<Controller>(context, listen: false)
              .getBarData(listMap["data"]);

          // textToColor(value.id, listMap["title"]);
          print("color------$generatedColor");
          return Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                listMap["title"] == null ||
                        listMap["title"].isEmpty ||
                        listMap["title"] == " "
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Center(
                          child: Text(
                            listMap["title"].toString().toUpperCase(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                // Divider(),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     // height: 40,
                //     child: TextField(
                //       controller: value.listEditor[parentIndex],
                //       decoration: const InputDecoration(
                //         hintText: 'Search...',
                //         border: OutlineInputBorder(),
                //       ),
                //       onChanged: (value) async {
                //         Provider.of<Controller>(context, listen: false)
                //             .onSearchTextChanged(value, listMap);
                //       },
                //     ),
                //   ),
                // ),
                // Center(
                //   child: listMap["title"] == null || listMap["title"].isEmpty
                //       ? Container()
                //       : Text(
                //           listMap["title"],
                //           style: TextStyle(
                //               fontSize: 20, fontWeight: FontWeight.bold),
                //         ),
                // ),
                // Padding(
                //     padding: const EdgeInsets.only(top: 10.0, left: 10),
                //     child: Text(
                //       "header",
                //       style:
                //           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                //     )),
                listMap["graph"] == "0"
                    ? Container()
                    // : AspectRatio(
                    //     aspectRatio: 1.4,
                    //     child: DChartLine(
                    //       data: [
                    //         {
                    //           'id': 'Line',
                    //           'data': [
                    //             {'domain': 0, 'measure': 4.1},
                    //             {'domain': 2, 'measure': 4},
                    //             {'domain': 3, 'measure': 6},
                    //             {'domain': 4, 'measure': 1},
                    //           ],
                    //         },
                    //       ],
                    //       lineColor: (lineData, index, id) => Colors.amber,
                    //     ),
                    //   ),

                    : AspectRatio(
                        aspectRatio: 1.4,
                        child: DChartBar(
                            data: value.graphMap["barData"],
                            minimumPaddingBetweenLabel: 2,
                            domainLabelPaddingToAxisLine: 16,
                            axisLineTick: 2,
                            axisLinePointTick: 2,
                            axisLinePointWidth: 10,
                            axisLineColor: P_Settings.purple,
                            measureLabelPaddingToAxisLine: 16,
                            domainLabelRotation:
                                value.graphMap["barData"][0]["data"].length > 6
                                    ? 45
                                    : 0,
                            barColor: (barData, index, id) {
                              return parseColor(barData["colorId"]);
                            })),

                listMap["graph"] == "0"
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: size.height * 0.03,
                          child: Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: value.legends.length,
                              itemBuilder: (context, index) {
                                // print(
                                //     'index------------$index-------${value.legends[index]}');
                                if (index == 0) {
                                  return Container();
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                            backgroundColor: parseColor(
                                                value.colorList[index]),
                                            radius: 6),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(value.legends[index]),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                Container(
                    // height: (35 * listMap["data"].length) + 80,
                    // ? (35 * listMap["data"].length) + 80
                    // : (35 * listMap["data"].length) + 80 + 20,
                    // ? size.height * (listMap["data"].length / 16)
                    // : size.height * 0.23,
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GraphDataTable(
                        decodd: jsonEncoded,
                        index: parentIndex,
                        keyVal: listMap["search"]),
                    // listMap["data"].length > 4
                    //     ? Container(
                    //         height: 50,
                    //         child: InkWell(
                    //           onTap: () {
                    //             show = !show;
                    //             value.setShowHideText(show, parentIndex);
                    //           },
                    //           child: Padding(
                    //             padding: const EdgeInsets.only(
                    //                 right: 39.0, bottom: 20),
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.end,
                    //               children: <Widget>[
                    //                 value.descTextShowFlag[parentIndex]
                    //                     ? Text(
                    //                         "Show Less",
                    //                         style: TextStyle(
                    //                             color: P_Settings
                    //                                 .selectedTextColor,
                    //                             fontWeight: FontWeight.bold),
                    //                       )
                    //                     : Text("Show More",
                    //                         style: TextStyle(
                    //                             color: P_Settings
                    //                                 .selectedTextColor,
                    //                             fontWeight: FontWeight.bold))
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     : Container()
                  ],
                )),
                //  Divider(thickness: 2,color: Colors.black,)
                // Padding(
                //     padding:
                //         const EdgeInsets.only(top: 10.0, left: 10, bottom: 10),
                //     child: Text(
                //       "footer",
                //       style:
                //           TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                //     )),
              ],
            ),
          );
        }
      },
    );
  }

  // void _onSearchTextChanged(String text, List list) {
  //   setState(() {
  //     filteredData = text.isEmpty
  //         ? list
  //         : list
  //             .where((item) =>
  //                 item['DESCRIPTION']
  //                     .toLowerCase()
  //                     .contains(text.toLowerCase()) ||
  //                 item['VALUE'].toLowerCase().contains(text.toLowerCase()))
  //             .toList();
  //     jsonEncoded = json.encode(filteredData);
  //     print("filtered data----$jsonEncoded");
  //   });
  // }
}
