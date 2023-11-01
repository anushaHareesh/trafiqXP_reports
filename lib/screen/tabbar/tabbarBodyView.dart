import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trafiqxpreports/screen/tabbar/tabbarClickPage.dart';

import '../../controller/controller.dart';

class TabbarBodyView extends StatefulWidget {
  const TabbarBodyView({super.key});

  @override
  State<TabbarBodyView> createState() => _TabbarBodyViewState();
}

class _TabbarBodyViewState extends State<TabbarBodyView> {
  String? todaydate;
  DateTime now = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todaydate = DateFormat('dd-MM-yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Consumer<Controller>(
        builder: (context, value, child) {
          return AbsorbPointer(
            absorbing: value.isReportLoading ? true : false,
            child: Column(
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      DefaultTabController(
                        length: value.tabList.length, // length of tabs
                        initialIndex: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              // color: P_Settings.bodyTabColor,
                              child: TabBar(
                                  isScrollable: true,
                                  // physics: NeverScrollableScrollPhysics(),
                                  labelColor: Colors.red,
                                  indicatorWeight: 3,
                                  indicatorColor: Colors.red,
                                  unselectedLabelColor: Colors.black,
                                  // labelPadding:
                                  //     EdgeInsets.symmetric(horizontal: 12),
                                  labelStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  tabs: value.tabList
                                      .map(
                                        (e) => Tab(
                                          text: e.tabName.toString(),
                                        ),
                                      )
                                      .toList()),
                            ),
                            Container(
                              height:
                                  size.height * 0.85, //height of TabBarView
                              decoration: const BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey, width: 0.5))),
                              child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                children: value.tabList.map((e) {
                                  return customContainer(e.tabId.toString());
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
              ],
            ),
          );
        },
      ),
    );
  }

//////////////////////////////////////////////////////////////////////////////////////////
  Widget customContainer(String e) {
    return Consumer<Controller>(
      builder: (context, value, child) {
        return Container(
          child: TabbarClickPage(
            tabId: e,
            b_id: value.brId!,
          ),
        );
      },
    );
  }

  // checkShred(String br, String e) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String key = e + "key";
  //   final rawJson = prefs.getString(key) ?? '';
  //   print("rawjson----$br--$key---$rawJson");
  //   if (rawJson == null || rawJson.isEmpty) {
  //     Provider.of<Controller>(context, listen: false).loadReportData(
  //       context,
  //       e,
  //       todaydate,
  //       todaydate,
  //       br,
  //     );
  //   } else {
  //     List<Map<String, dynamic>> map = [];
  //     map = (jsonDecode(rawJson) as List)
  //         .map((dynamic e) => e as Map<String, dynamic>)
  //         .toList();
  //     // var map1 = jsonDecode(rawJson);
  //     // map.clear();
  //     // for (var item in map1) {
  //     //   map.add(item);
  //     // }
  //     await Provider.of<Controller>(context, listen: false)
  //         .loaclStorageData(map);
  //   }
  // }

  
}
