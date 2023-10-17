import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:trafiqxpreports/components/commonColor.dart';
import 'package:trafiqxpreports/controller/controller.dart';
import 'package:trafiqxpreports/screen/customReport.dart';
import 'package:trafiqxpreports/screen/product_search_history.dart';
import 'package:trafiqxpreports/screen/tabbar/tabbarBodyView.dart';

import '../components/dateFind.dart';
import 'loginScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  String? selected;
  int _selectedIndex = 0;
  List<Widget> drawerOpts = [];
  int tbindex = 0;
  String? todaydate;
  DateTime now = DateTime.now();

  DateFind dateFind = DateFind();
  String? cname;
  List<bool> tabClick = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  getCname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cname = prefs.getString("cn");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCname();
    todaydate = DateFormat('dd-MM-yyyy').format(now);
    Provider.of<Controller>(context, listen: false).fromDate = todaydate;
    Provider.of<Controller>(context, listen: false).todate = todaydate;
  }

  void _onRefresh() async {
    String tabId;
    await Future.delayed(Duration(milliseconds: 1000));
    if (Provider.of<Controller>(context, listen: false).menuClick == true) {
      tabId = Provider.of<Controller>(context, listen: false).customIndex!;
    } else {
      tabId = Provider.of<Controller>(context, listen: false).tab_index!;
    }
    Provider.of<Controller>(context, listen: false).loadReportData(
      context,
      tabId,
      Provider.of<Controller>(context, listen: false).fromDate.toString(),
      Provider.of<Controller>(context, listen: false).todate,
      Provider.of<Controller>(context, listen: false).brId!,
    );
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Consumer<Controller>(
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  cname == null
                      ? SpinKitCircle(
                          color: P_Settings.purple,
                        )
                      : Flexible(
                          child: Text(
                            cname.toString(),
                            style: TextStyle(fontSize: 13,color: Colors.white),
                          ),
                        ),
                  InkWell(
                    onTap: value.isReportLoading
                        ? null
                        : () {
                            if (value.branches.length > 0 &&
                                value.branches != null) {
                              buildPopupDialog(context, size);
                            }
                          },
                    child: value.branches.length == 0 || value.branches == null
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                // "dvjhsdjhdhjbsdjhbsdjsbdjhsdhs",
                                "${value.selected.toString()}",
                                style: TextStyle(fontSize: 14,color: Colors.white),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 17,
                              )
                            ],
                          ),
                  )
                ],
              );
            },
          ),
          elevation: 0,
          backgroundColor: P_Settings.purple,
          leading: Builder(
            builder: (context) => Consumer<Controller>(
              builder: (context, value, child) {
                return AbsorbPointer(
                  absorbing: value.isReportLoading ? true : false,
                  child: IconButton(
                      icon: new Icon(
                        Icons.menu,
                        color: P_Settings.whiteColor,
                      ),
                      onPressed: () async {
                        drawerOpts.clear();
                        for (var i = 0;
                            i <
                                Provider.of<Controller>(context, listen: false)
                                    .customMenuList
                                    .length;
                            i++) {
                          // var d =Provider.of<Controller>(context, listen: false).drawerItems[i];

                          drawerOpts.add(Consumer<Controller>(
                            builder: (context, value, child) {
                              // print(
                              //     "menulist[menu]-------${value.menuList[i]["menu_name"]}");
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8, top: 10, bottom: 8),
                                child: InkWell(
                                  onTap: () async {
                                    Provider.of<Controller>(context,
                                            listen: false)
                                        .setCustomReportIndex(value
                                            .customMenuList[i].tabId
                                            .toString());
                                    Provider.of<Controller>(context,
                                            listen: false)
                                        .setDateCriteria(value
                                            .customMenuList[i].date_criteria!);
                                    alertDialoge(
                                        context,
                                        size,
                                        value.customMenuList[i].date_criteria!,
                                        value.customMenuList[i].tabName!);

                                    _key.currentState!.closeDrawer();
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        value.customMenuList[i].tabName!
                                            .toUpperCase(),
                                        style: GoogleFonts.aBeeZee(
                                          fontWeight: FontWeight.w500,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ));
                        }
                        _key.currentState!.openDrawer();
                      }),
                );
              },
            ),
          ),
        ),
        drawer: Consumer<Controller>(
          builder: (context, value, child) {
            return Drawer(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.045,
                        ),
                        Container(
                          height: size.height * 0.1,
                          width: size.width * 1,
                          color: P_Settings.purple,
                          child: Row(
                            children: [
                              SizedBox(
                                height: size.height * 0.07,
                                width: size.width * 0.03,
                              ),
                              Icon(
                                Icons.list_outlined,
                                color: Colors.white,
                              ),
                              SizedBox(width: size.width * 0.01),
                              Text(
                                "Custom Reports",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 13,
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 8.0, right: 8, top: 13, bottom: 8),
                        //   child: InkWell(
                        //     onTap: () {
                        //       String br;
                        //       if (value.brId == null) {
                        //         br = "0";
                        //       } else {
                        //         br = value.brId!;
                        //       }
                        //       Provider.of<Controller>(context, listen: false)
                        //           .loadReportData(
                        //               context,
                        //               value.tabId.toString(),
                        //               value.fromDate.toString(),
                        //               value.todate.toString(),
                        //               br);
                        //       Provider.of<Controller>(context, listen: false)
                        //           .setMenuClick(false);
                        //       Navigator.pop(_key.currentContext!);
                        //     },
                        //     child: Row(
                        //       children: [
                        //         Text(
                        //           "DASHBOARD",
                        //           style: TextStyle(fontSize: 17),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Column(children: drawerOpts),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       left: 8.0, right: 8, top: 10, bottom: 8),
                        //   child: InkWell(
                        //     onTap: () async {
                        //       // _key.currentState!.closeDrawer();
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => ProductHistory()));
                        //     },
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text(
                        //           "PRODUCT SEARCH",
                        //           style: GoogleFonts.aBeeZee(
                        //             fontWeight: FontWeight.w500,
                        //             textStyle:
                        //                 Theme.of(context).textTheme.bodyText2,
                        //             fontSize: 14,
                        //           ),
                        //         ),
                        //         Icon(Icons.search)
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, top: 10, bottom: 8),
                          child: InkWell(
                            onTap: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove('st_uname');
                              await prefs.remove('st_pwde');
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "LOGOUT",
                                  style: GoogleFonts.aBeeZee(
                                    fontWeight: FontWeight.w500,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    fontSize: 14,
                                  ),
                                ),
                                Icon(Icons.logout)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _onRefresh,
          child: Consumer<Controller>(
            builder: (context, value, child) {
              return customContainer();
            },
          ),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////
  Widget customContainer() {
    return Consumer<Controller>(
      builder: (context, value, child) {
        if (value.menuClick) {
          return CustomReport();
        } else {
          return SingleChildScrollView(child: TabbarBodyView());
        }
        // return SingleChildScrollView(
        //   // physics: NeverScrollableScrollPhysics(),
        //   child: Container(
        //     child: value.menuClick ? CustomReport() : TabbarBodyView(),
        //   ),
        // );
      },
    );
  }

////////////////////////////////////////////////////////////////////
  alertDialoge(BuildContext context, Size size, String dateCriteria,
      String rpName) async {
    print("jhfjdf");
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "$rpName",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                )
              ],
            ),
            content: Container(
              width: double.infinity,
              height:
                  dateCriteria == "1" ? size.height * 0.15 : size.height * 0.25,
              child: Consumer<Controller>(
                builder: (context, value, child) {
                  return Column(
                    children: [
                      dateCriteria == "1"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      dateFind.selectDateFind(
                                          context, "from date");
                                    },
                                    icon: Icon(
                                      Icons.calendar_month,
                                    )),
                                Text(
                                  value.fromDate == null
                                      ? todaydate.toString()
                                      : value.fromDate.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("From : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]))
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          dateFind.selectDateFind(
                                              context, "from date");
                                        },
                                        icon: Icon(
                                          Icons.calendar_month,
                                        )),
                                    Text(
                                      value.fromDate == null
                                          ? todaydate.toString()
                                          : value.fromDate.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "To      :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          dateFind.selectDateFind(
                                              context, "to date");
                                        },
                                        icon: Icon(Icons.calendar_month)),
                                    Text(
                                      value.todate == null
                                          ? todaydate.toString()
                                          : value.todate.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.25,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: P_Settings.purple),
                                  onPressed: () {
                                    Provider.of<Controller>(context,
                                            listen: false)
                                        .setMenuClick(true);
                                    String br;
                                    if (value.brId == null) {
                                      br = "0";
                                    } else {
                                      br = value.brId!;
                                    }
                                    Provider.of<Controller>(context,
                                            listen: false)
                                        .loadReportData(
                                      context,
                                      value.customIndex.toString(),
                                      value.fromDate!,
                                      value.todate!,
                                      br,
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "VIEW",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            // actions: <Widget>[
            //   TextButton(
            //     child: const Text('cancel'),
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //   ),
            //   TextButton(
            //     child: const Text('Ok'),
            //     onPressed: () {
            //       exit(0);
            //     },
            //   ),
            // ],
          );
          // return SimpleDialog(
          //   title: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         'Select Date',
          //         style: TextStyle(
          //             fontSize: 17,
          //             color: P_Settings.purple,
          //             fontWeight: FontWeight.bold),
          //       ),
          //     ],
          //   ),
          //   children: <Widget>[
          //     Container(
          //       // height: 20,
          //       child: Consumer<Controller>(
          //         builder: (context, value, child) {
          //           return Column(
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: dateCriteria == "1"
          //                     ? Row(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         children: [
          //                           IconButton(
          //                               onPressed: () {
          //                                 dateFind.selectDateFind(
          //                                     context, "from date");
          //                               },
          //                               icon: Icon(
          //                                 Icons.calendar_month,
          //                               )),
          //                           Text(
          //                             value.fromDate == null
          //                                 ? todaydate.toString()
          //                                 : value.fromDate.toString(),
          //                             style: TextStyle(
          //                               fontWeight: FontWeight.bold,
          //                               color: Colors.grey[700],
          //                             ),
          //                           ),
          //                         ],
          //                       )
          //                     : Row(
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Row(
          //                             children: [
          //                               IconButton(
          //                                   onPressed: () {
          //                                     dateFind.selectDateFind(
          //                                         context, "from date");
          //                                   },
          //                                   icon: Icon(
          //                                     Icons.calendar_month,
          //                                   )),
          //                               Text(
          //                                 value.fromDate == null
          //                                     ? todaydate.toString()
          //                                     : value.fromDate.toString(),
          //                                 style: TextStyle(
          //                                   fontWeight: FontWeight.bold,
          //                                   color: Colors.grey[700],
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                           Row(
          //                             children: [
          //                               IconButton(
          //                                   onPressed: () {
          //                                     dateFind.selectDateFind(
          //                                         context, "to date");
          //                                   },
          //                                   icon: Icon(Icons.calendar_month)),
          //                               Text(
          //                                 value.todate == null
          //                                     ? todaydate.toString()
          //                                     : value.todate.toString(),
          //                                 style: TextStyle(
          //                                   fontWeight: FontWeight.bold,
          //                                   color: Colors.grey[700],
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ],
          //                       ),
          //               ),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Container(
          //                     width: size.width * 0.25,
          //                     child: ElevatedButton(
          //                         style: ElevatedButton.styleFrom(
          //                             primary: P_Settings.purple),
          //                         onPressed: () {
          //                           Provider.of<Controller>(context,
          //                                   listen: false)
          //                               .setMenuClick(true);
          //                           Provider.of<Controller>(context,
          //                                   listen: false)
          //                               .loadReportData(
          //                                   context,
          //                                   value.customIndex.toString(),
          //                                   value.fromDate!,
          //                                   value.todate!,
          //                                   value.brId.toString());
          //                           Navigator.pop(context);
          //                         },
          //                         child: Text(
          //                           "APPLY",
          //                           style:
          //                               TextStyle(fontWeight: FontWeight.bold),
          //                         )),
          //                   )
          //                 ],
          //               )
          //             ],
          //           );
          //         },
          //       ),
          //     ),
          //   ],
          // );
        });
  }

  // alertDialoge(BuildContext context, Size size, String dateCriteria) async {
  //   String? d;
  //   return await showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (BuildContext context) {
  //         return SimpleDialog(
  //           title: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 'Select Date',
  //                 style: TextStyle(
  //                     fontSize: 17,
  //                     color: P_Settings.purple,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //             ],
  //           ),
  //           children: <Widget>[
  //             Container(
  //               child: Consumer<Controller>(
  //                 builder: (context, value, child) {
  //                   return Column(
  //                     children: [
  //                       Row(
  //                         children: [
  //                           IconButton(
  //                               onPressed: () async {

  //                                 d = DateFormat('dd-MM-yyyy')
  //                                     .format(datePicked!);

  //                                 Provider.of<Controller>(context,
  //                                         listen: false)
  //                                     .setDate(d!, date2);
  //                               },
  //                               icon: Icon(Icons.calendar_month)),
  //                           Text(d.toString())
  //                         ],
  //                       ),
  //                       Row(
  //                         children: [],
  //                       ),
  //                       ElevatedButton(
  //                           onPressed: () {
  //                             Provider.of<Controller>(context, listen: false)
  //                                 .setMenuClick(true);
  //                             Provider.of<Controller>(context, listen: false)
  //                                 .loadReportData(
  //                                     context,
  //                                     value.customIndex.toString(),
  //                                     d,
  //                                     d,
  //                                     value.brId.toString());
  //                           },
  //                           child: Text("View"))
  //                     ],
  //                   );
  //                 },
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

/////////////////////////////////////////////////////////////////////////
  buildPopupDialog(BuildContext context, Size size) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: Consumer<Controller>(builder: (context, value, child) {
                // if (value.isLoading) {
                //   return CircularProgressIndicator();
                // } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.grey[200],
                      height: size.height * 0.04,
                      child: DropdownButton<String>(
                        value: selected,
                        // isDense: true,
                        hint: Text(value.selected.toString()),
                        // isExpanded: true,
                        autofocus: false,
                        underline: SizedBox(),
                        elevation: 0,
                        items: value.branches
                            .map((item) => DropdownMenuItem<String>(
                                value: item["branch_id"].toString(),
                                child: Container(
                                  width: size.width * 0.4,
                                  child: Text(
                                    item["branch_name"].toString(),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                )))
                            .toList(),
                        onChanged: (item) {
                          print("clicked");

                          if (item != null) {
                            setState(() {
                              selected = item;
                            });
                            print("se;ected---$item");
                          }
                        },
                      ),
                    ),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: P_Settings.purple),
                      onPressed: () async {
                        String tabId;
                        if (selected == null) {
                          selected = value.brId;
                        }
                        Provider.of<Controller>(context, listen: false)
                            .setDropdowndata(selected!);
                        if (value.menuClick == true) {
                          tabId = value.customIndex!;
                        } else {
                          tabId = value.tab_index!;
                        }
                        print("gahghgd------${value.customIndex}");
                        Provider.of<Controller>(context, listen: false)
                            .loadReportData(context, tabId, value.fromDate!,
                                value.todate!, value.brId!);

                        Navigator.pop(context);
                      },
                      child: Text("VIEW"),
                    )
                  ],
                );
                // }
              }),
            );
          });
        });
  }

  ////////////////////////////////////////////////////////////
  Future<bool> _onBackPressed(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to exit from this app'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                exit(0);
              },
            ),
          ],
        );
      },
    );
  }
}
