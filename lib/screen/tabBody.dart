// import "dart:convert";

// import "package:d_chart/d_chart.dart";
// import "package:flutter/material.dart";
// import "package:flutter_spinkit/flutter_spinkit.dart";
// import "package:intl/intl.dart";
// import "package:lottie/lottie.dart";
// import "package:provider/provider.dart";
// import "package:reportingapp1/components/graphDataTable.dart";
// import "package:reportingapp1/controller/controller.dart";
// import "package:string_to_hex/string_to_hex.dart";

// import "../components/commonColor.dart";

// class TabBody extends StatefulWidget {
//   String tabId;
//   String fromdate;
//   String tilldate;
//   TabBody(
//       {required this.tabId, required this.fromdate, required this.tilldate});

//   @override
//   State<TabBody> createState() => _TabBodyState();
// }

// class _TabBodyState extends State<TabBody> {
//   bool show = false;
//   bool showGraph = false;
//   String? _string;
//   Color? generatedColor;
//   int? generatedColorInt;
// //////////////////////////////////////////////////////////////
//   textToColor(String id, String title) {
//     DateTime date = DateTime.now();
//     print("date------$date");
//     String sdte = DateFormat('ddMMyy').format(date);
//     print("iso ----${sdte}");
//     // String sCon =title +id + sdte;
//     String sCon = sdte + id;
//     String reverseStr = sCon.split('').reversed.join('');
//     // print("str-----$reverseStr");
//     _string = StringToHex.toHexString(reverseStr);
//     generatedColor = Color(StringToHex.toColor(_string));
//     generatedColorInt = StringToHex.toColor(_string);

//     Provider.of<Controller>(context, listen: false)
//         .setColor(generatedColor!, id);
//     // Provider.of<Controller>(context, listen: false).setColor(generatedColor!);
//     return generatedColor;
//   }

// //////////////////////////////////////////////////////////////
//   String description = "djHDjhDjHDhjsddddddddddddddddd";
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print("adhjkdhkjs-------${widget.tabId}");
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<Controller>(context, listen: false).loadReportData(
//           context, widget.tabId, widget.fromdate, widget.tilldate);
//     });

//     // Provider.of<Controller>(context, listen: false).getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       // color: Colors.yellow,
//       child: Consumer<Controller>(
//         builder: (context, value, child) {
//           if (value.isReportLoading) {
//             return Container(
//               height: size.height * 0.7,
//               child: SpinKitCircle(
//                 color: P_Settings.purple,
//               ),
//             );
//           } else {
//             if (value.list == null || value.list.length == 0) {
//               return Container(
//                 height: size.height * 0.7,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Lottie.asset(
//                       'asset/nodata.json',
//                       height: size.height * 0.25,
//                       width: size.height * 0.25,
//                     ),
//                   ],
//                 ),
//               );
//             } else {
//               return ListView.builder(
//                 physics: ScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 itemCount: value.list.length,
//                 itemBuilder: (context, index) {
//                   return customCard(size, value.list[index], index);

//                   //  return Container(
//                   //   // height: 300,
//                   //   child: Column(
//                   //     children: [
//                   //       Container(height: 300, child: Text("sdhkjsdh")),
//                   //       Container(height: 200, child: Text("dsjkdh")),
//                   //     ],
//                   //   ),
//                   // );
//                 },
//               );
//             }
//           }
//         },
//       ),
//     );
//   }

//   Widget customCard(size, Map listMap, int parentIndex) {
//     return Consumer<Controller>(
//       builder: (context, value, child) {
//         print("vlll--------${listMap["data"]}");
//         var jsonEncoded = json.encode(listMap);
//         Provider.of<Controller>(context, listen: false)
//             .getBarData(listMap["data"]);
//         List<dynamic> listdata = listMap["data"];
//         Provider.of<Controller>(context, listen: false)
//             .getLegends(listdata, listMap["title"]);
//         // textToColor(value.id, listMap["title"]);
//         print("color------$generatedColor");
//         return Card(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 10.0),
//                 child: Center(
//                   child: Text(
//                     listMap["title"],
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),

//               AspectRatio(
//                   aspectRatio: 1.4,
//                   child: DChartBar(
//                       data: value.graphMap["barData"],
//                       minimumPaddingBetweenLabel: 2,
//                       domainLabelPaddingToAxisLine: 16,
//                       axisLineTick: 2,
//                       axisLinePointTick: 2,
//                       axisLinePointWidth: 10,
//                       axisLineColor: P_Settings.purple,
//                       measureLabelPaddingToAxisLine: 16,
//                       barColor: (barData, index, id) {
//                         print(
//                             "generatedColor-----$generatedColor----${value.id}----$id");
//                         return textToColor(id, listMap["title"]);
//                       })),

//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   alignment: Alignment.center,
//                   width: double.infinity,
//                   height: size.height * 0.03,
//                   child: Container(
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       scrollDirection: Axis.horizontal,
//                       itemCount: value.legends.length,
//                       itemBuilder: (context, index) {
//                         // print(
//                         //     'index------------$index-------${value.legends[index]}');
//                         if (index == 0) {
//                           return Container();
//                         } else {
//                           return Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: Row(
//                               // mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 CircleAvatar(
//                                     backgroundColor: value.colorList[index],
//                                     radius: 6),
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 8.0),
//                                   child: Text(value.legends[index]),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                   height: (35 * listMap["data"].length) + 80,
//                   // ? (35 * listMap["data"].length) + 80
//                   // : (35 * listMap["data"].length) + 80 + 20,
//                   // ? size.height * (listMap["data"].length / 16)
//                   // : size.height * 0.23,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       GraphDataTable(decodd: jsonEncoded),
//                       // listMap["data"].length > 4
//                       //     ? Container(
//                       //         height: 50,
//                       //         child: InkWell(
//                       //           onTap: () {
//                       //             show = !show;
//                       //             value.setShowHideText(show, parentIndex);
//                       //           },
//                       //           child: Padding(
//                       //             padding: const EdgeInsets.only(
//                       //                 right: 39.0, bottom: 20),
//                       //             child: Row(
//                       //               mainAxisAlignment: MainAxisAlignment.end,
//                       //               children: <Widget>[
//                       //                 value.descTextShowFlag[parentIndex]
//                       //                     ? Text(
//                       //                         "Show Less",
//                       //                         style: TextStyle(
//                       //                             color: P_Settings
//                       //                                 .selectedTextColor,
//                       //                             fontWeight: FontWeight.bold),
//                       //                       )
//                       //                     : Text("Show More",
//                       //                         style: TextStyle(
//                       //                             color: P_Settings
//                       //                                 .selectedTextColor,
//                       //                             fontWeight: FontWeight.bold))
//                       //               ],
//                       //             ),
//                       //           ),
//                       //         ),
//                       //       )
//                       //     : Container()
//                     ],
//                   )),
//               //  Divider(thickness: 2,color: Colors.black,)
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
