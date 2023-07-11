// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:string_to_hex/string_to_hex.dart';
// import 'package:trafiqxpreports/components/globalData.dart';
// import 'package:trafiqxpreports/components/networkConnection.dart';
// import 'package:trafiqxpreports/model/menuDatas.dart';
// import 'package:trafiqxpreports/model/registrationModel.dart';
// import 'package:trafiqxpreports/screen/get_storage_util.dart';
// import 'package:trafiqxpreports/screen/loginScreen.dart';

// import '../components/customSnackbar.dart';
// import '../components/externalDir.dart';
// import '../model/loginModel.dart';
// import '../screen/homeScreen.dart';
// import '../services/dbHelper.dart';

// class Controller extends ChangeNotifier {
//   String clicked = "0";
//   List<dynamic> filteredData = [];
//   var jsonEncoded;
//   List<TextEditingController> listEditor = [];
//   String? fp;
//   String? cid;
//   ExternalDir externalDir = ExternalDir();
//   int? generatedColorInt;
//   String? cname;
//   String? sof;
//   int? qtyinc;
//   List<CD> c_d = [];
//   String? firstMenu;
//   bool isSearch = false;
//   String? tabId;
//   String? brId;
//   String? showGraph;
//   String? date_criteria;
//   String? customIndex;
//   bool isLoading = false;
//   bool isLoginLoad = false;
//   bool issearching = false;
//   bool isReportLoading = false;
//   bool isSubReportLoading = false;

//   String? _string;
//   Color? generatedColor;

//   String? idd;
//   String? menu_index;
//   String? tab_index;

//   bool? dateApplyClicked;
//   String? fromDate;
//   String id = "";
//   List<String> barColor = [];
//   String? selected;
//   String? todate;
//   var reportjson;
//   Map graphMap = {};

//   List<String> legends = [];
//   List<String> colorList = [];
//   List<Color> colorListCopy = [];

//   List<Map<String, dynamic>> listColor = [];

//   Color? colorDup;
//   bool menuClick = false;
//   List<Map<String, dynamic>> list = [];
//   List<Map<String, dynamic>> sublist = [];

//   List<TabsModel> customMenuList = [];
//   List<Map<String, dynamic>> branches = [];
//   List<Map<String, dynamic>> productHistory = [];
//   List<Map<String, dynamic>> productList = [];
//   List<Map<String, dynamic>> newList = [];

//   List<TabsModel> tabList = [];
//   List<Map<String, dynamic>> legendList = [];

//   List<bool> descTextShowFlag = [];
//   List<Map<String, dynamic>> menuList = [];
//   String urlgolabl = Globaldata.apiglobal;

// /////////////////////////////////////////////
//   Future<RegistrationData?> postRegistration(
//       String company_code,
//       String? fingerprints,
//       String phoneno,
//       String deviceinfo,
//       BuildContext context) async {
//     NetConnection.networkConnection(context).then((value) async {
//       print("Text fp...$fingerprints---$company_code---$phoneno---$deviceinfo");
//       print("company_code.........$company_code");
//       // String dsd="helloo";
//       String appType = company_code.substring(10, 12);
//       print("apptytpe----$appType");
//       if (value == true) {
//         try {
//           Uri url =
//               Uri.parse("https://trafiqerp.in/order/fj/get_registration.php");
//           Map body = {
//             'company_code': company_code,
//             'fcode': fingerprints,
//             'deviceinfo': deviceinfo,
//             'phoneno': phoneno
//           };
//           print("body----${body}");
//           isLoginLoad = true;
//           notifyListeners();
//           http.Response response = await http.post(
//             url,
//             body: body,
//           );
//           print("xx ${response.body}");

//           var map = jsonDecode(response.body);
//           print("map register ${map}");
//           RegistrationData regModel = RegistrationData.fromJson(map);

//           sof = regModel.sof;
//           fp = regModel.fp;
//           String? msg = regModel.msg;
//           print("fp----- $fp");
//           print("sof----${sof}");

//           if (sof == "1") {
//             print("apptype----$appType");
//             if (appType == 'LR') {
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               /////////////// insert into local db /////////////////////
//               late CD dataDetails;
//               String? fp1 = regModel.fp;
//               print("fingerprint......$fp1");
//               prefs.setString("fp", fp!);
//               String? os = regModel.os;
//               regModel.c_d![0].cid;
//               cid = regModel.cid;
//               prefs.setString("cid", cid!);

//               cname = regModel.c_d![0].cnme;
//               print("cname ${cname}");

//               prefs.setString("cn", cname!);
//               notifyListeners();

//               await externalDir.fileWrite(fp1!);

//               for (var item in regModel.c_d!) {
//                 c_d.add(item);
//                 print("ciddddddddd......$item");
//               }
//               print("bfore----");
//               await ReportDB.instance
//                   .deleteFromTableCommonQuery("companyRegistrationTable", "");
//               var res =
//                   await ReportDB.instance.insertRegistrationDetails(regModel);
//               print("response----$res");
//               // getInitializeApi(context);

//               isLoginLoad = false;
//               notifyListeners();
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => LoginScreen()),
//               );
//             } else {
//               CustomSnackbar snackbar = CustomSnackbar();
//               snackbar.showSnackbar(context, "Invalid Apk Key", "");
//             }
//           }
//           /////////////////////////////////////////////////////
//           if (sof == "0") {
//             CustomSnackbar snackbar = CustomSnackbar();
//             snackbar.showSnackbar(context, msg.toString(), "");
//           }

//           notifyListeners();
//         } catch (e) {
//           print(e);
//           return null;
//         }
//       }
//     });
//   }

//   //////////////////////////////////////////////////
//   getLogin(String userName, String password, BuildContext context) async {
//     var restaff;
//     try {
//       Uri url = Uri.parse("$urlgolabl/login.php");
//       Map body = {'user': userName, 'pass': password};

//       isLoginLoad = true;
//       notifyListeners();
//       http.Response response = await http.post(
//         url,
//         body: body,
//       );
//       print("login body ${body}");

//       var map = jsonDecode(response.body);
//       print("login map ${map}");

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       if (map == null || map.length == 0) {
//         isLoginLoad = false;
//         notifyListeners();
//         CustomSnackbar snackbar = CustomSnackbar();
//         snackbar.showSnackbar(context, "Incorrect Username or Password", "");
//       } else {
//         // isLoginLoad = false;
//         // notifyListeners();
//         prefs.setString("st_uname", userName);
//         prefs.setString("st_pwde", password);

//         prefs.setString("cid", map[0]["company_id"]);
//         prefs.setString("user_id", map[0]["user_id"]);
//         getInitializeApi(context);
//       }

//       // print("stafff-------${loginModel.staffName}");
//       notifyListeners();
//       // return staffModel;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   ///////////////////////////////////////////////////////////
//   getInitializeApi(BuildContext context) async {
//     var res;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? cid = prefs.getString("cid");
//     String? user_id = prefs.getString("user_id");

//     // print("cid----$cid");
//     NetConnection.networkConnection(context).then((value) async {
//       if (value == true) {
//         try {
//           Uri url = Uri.parse("$urlgolabl/initialize.php");
//           Map body = {'c_id': cid, 'user_id': user_id};

//           print("jkhdkj-----$body");
//           isLoading = true;
//           notifyListeners();
//           http.Response response = await http.post(
//             url,
//             body: body,
//           );

//           var map = jsonDecode(response.body);

//           print("init map --$map");
//           MenuModel menuModel = MenuModel.fromJson(map);

//           tabList.clear();
//           customMenuList.clear();
//           for (var item in menuModel.tabs!) {
//             if (item.menuType == "0") {
//               tabList.add(item);
//             } else {
//               customMenuList.add(item);
//             }
//           }
//           tabId = tabList[0].tabId.toString();
//           branches.clear();
//           if (map["branchs"] != null && map["branchs"].length > 0) {
//             print("haiiiii");
//             List sid = map["branchs"][0]["branch_ids"].split(',');
//             List sname = map["branchs"][0]["branch_names"].split(',');
//             selected = sname[0];
//             brId = sid[0];
//             print("brId----------$brId");
//             for (int i = 0; i < sid.length; i++) {
//               Map<String, dynamic> ma = {
//                 "branch_id": sid[i],
//                 "branch_name": sname[i]
//               };
//               print("ma----$ma");
//               branches.add(ma);
//             }
//             print("branches----------------$branches");
//             // for (var item in map["branchs"]) {
//             //   branches.add(item);
//             // }

//             // selected = branches[0]["branch_name"];
//             // brId = branches[0]["branch_id"];
//           }

//           print("branches--------$branches");
//           print("customMenuList---------------$customMenuList");
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => HomeScreen()),
//           );
//           isLoginLoad = false;
//           isLoading = false;
//           notifyListeners();
//         } catch (e) {
//           print(e);
//           return null;
//         }
//       }
//     });
//   }

// ///////////////////////////////////////////////////////////////////
//   setDate(String date1, String date2) {
//     fromDate = date1;
//     todate = date2;
//     print("gtyy----$fromDate----$todate");
//     notifyListeners();
//   }

// ///////////////////////////////////////////////////////////////////
//   getData() {
//     List<Map<String, dynamic>> barListShow = [];
//     // list = [
//     //   {
//     //     "id": "0",
//     //     "title": "Sale1",
//     //     "sum": "NYY",
//     //     "align": "LRR",
//     //     "width": "60,20,20",
//     //     "data": [
//     //       {"date": "4-2022", "Qty": "61703110", "val(k)": "61703110.07"},
//     //       {"date": "5-2022", "Qty": "61703110", "val(k)": "61703110.07"},
//     //       {"date": "6-2022", "Qty": "61703110", "val(k)": "61703110.07"},
//     //     ]
//     //   }
//     // ];
//     list = [
//       {
//         "id": "0",
//         "title": "Sale Report1",
//         "sum": "NYY",
//         "align": "LRR",
//         "width": "60,20,20",
//         "data": [
//           {"date": "20/10/2022", "amount1": "100", "amount2": "327"},
//           {"date": "4/8/2022", "amount1": "200", "amount2": "190"},
//           {"date": "2/10/2022", "amount1": "300", "amount2": "206"},
//           {"date": "1/2/2022", "amount1": "400", "amount2": "100"},
//         ]
//       },
//       {
//         "id": "1",
//         "title": "anushak",
//         "sum": "NY",
//         "align": "LR",
//         "width": "60,40",
//         "data": [
//           {"date": "20/10/2022", "amount2": "100"},
//           {"date": "4/8/2022", "amount2": "200"},
//           {"date": "2/10/2022", "amount2": "300"},
//           {"date": "1/10/2022", "amount2": "100"},
//           {"date": "6/8/2022", "amount2": "1000"},
//           // {"date": "8/10/2022", "amount2": "400"},
//         ]
//       },
//       // {
//       //   "id": "2",
//       //   "title": "Sale Report3",
//       //   "data": [
//       //     {
//       //       "date": "20/10/2022",
//       //       "amount1": "10",
//       //     },
//       //     {
//       //       "date": "4/8/2022",
//       //       "amount1": "200",
//       //     },
//       //     {
//       //       "date": "2/10/2022",
//       //       "amount1": "300",
//       //     },
//       //     {
//       //       "date": "1/2/2022",
//       //       "amount1": "400",
//       //     },
//       //   ]
//       // },
//     ];

//     descTextShowFlag = List.generate(list.length, (index) => false);
//   }

//   //////////////////////////////////////////////////////////////////////////////
//   loadReportData(BuildContext context, String tab_id, String? fromdate,
//       String? tilldate, String b_id) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? cid = prefs.getString("cid");
//     String? user_id = prefs.getString("user_id");
//     var map;
//     NetConnection.networkConnection(context).then((value) async {
//       if (value == true) {
//         try {
//           print("pishkuu---$fromDate----$tilldate----$b_id");
//           Uri url = Uri.parse("$urlgolabl/load_report.php");
//           Map body = {
//             "c_id": cid,
//             "b_id": b_id,
//             'user_id': user_id,
//             "tab_id": tab_id,
//             "from_date": fromdate,
//             "till_date": tilldate
//           };
//           print("load report body----$body");
//           isReportLoading = true;
//           notifyListeners();
//           // var client = http.Client();
//           // try {
//           //   var response = await client.post(
//           //       Uri.https("trafiqerp.in", '/rapi_xp/load_report.php'),
//           //       body: body);
//           //   map = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
//           //   print("from map------$map");
//           //   // var uri = Uri.parse(map['uri'] as String);
//           //   // print(await client.get(uri));
//           // } finally {
//           //   client.close();
//           // }
//           // http.Response response = await http.post(
//           //   url,
//           //   body: body,
//           // );
//           // var map = jsonDecode(response.body);
//           // String encodeData = jsonEncode(map);
//           // print("json encoded data from gets storage------$encodeData");
//           // String key = tab_id.toString() + "key";
//           // print("key key-----$key");
//           // prefs.setString(key, encodeData);
//           // final rawJson = prefs.getString(key) ?? '';
//           // var map1 = jsonDecode(rawJson);
//           // print("decoded-----$map");
//           // list.clear();
//           // for (var item in map1) {
//           //   list.add(item);
//           // }
//           // isReportLoading = false;
//           // notifyListeners();

//           http.Response response = await http.post(
//             url,
//             body: body,
//           );
//           var map = jsonDecode(response.body);
//           print("load report data------${map}");
//           // String jsone = jsonEncode(map);
//           // _write(jsone);
//           // String readVal = await _read();
//           // var haa = jsonDecode(readVal);
//           // print("nnsnbsn----$haa");
//           list.clear();
//           if (map != null) {
//             for (var item in map) {
//               list.add(item);
//             }
//           }
//           listEditor =
//               List.generate(list.length, (index) => TextEditingController());
//           isReportLoading = false;
//           notifyListeners();
//         } catch (e) {
//           print(e);
//           return null;
//         }
//       }
//     });
//     notifyListeners();
//   }
//   // loadReportData(BuildContext context, String tab_id, String? fromdate,
//   //     String? tilldate, String b_id) async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String? cid = prefs.getString("cid");
//   //   String? user_id = prefs.getString("user_id");
//   //   var map;
//   //   NetConnection.networkConnection(context).then((value) async {
//   //     if (value == true) {
//   //       try {
//   //         print("pishkuu---$fromDate----$tilldate----$b_id");
//   //         Uri url = Uri.parse("$urlgolabl/load_report.php");
//   //         Map body = {
//   //           "c_id": cid,
//   //           "b_id": b_id,
//   //           'user_id': user_id,
//   //           "tab_id": tab_id,
//   //           "from_date": fromdate,
//   //           "till_date": tilldate
//   //         };
//   //         print("load report body----$body");
//   //         isReportLoading = true;
//   //         notifyListeners();
//   //         var client = http.Client();
//   //         try {
//   //           var response = await client.post(
//   //               Uri.https("trafiqerp.in", '/rapi_xp/load_report.php'),
//   //               body: body);
//   //           var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
//   //           print("decodedResponse---$decodedResponse");
//   //           // var uri = Uri.parse(decodedResponse['uri'] as String);
//   //           // print(await client.get(uri));
//   //           list.clear();
//   //           if (decodedResponse != null) {
//   //             for (var item in decodedResponse) {
//   //               list.add(item);
//   //             }
//   //           }
//   //           isReportLoading = false;
//   //           notifyListeners();
//   //         } finally {
//   //           client.close();
//   //         }
//   //       } catch (e) {
//   //         print(e);
//   //         return null;
//   //       }
//   //     }
//   //   });
//   //   notifyListeners();
//   // }

//   /////////////////////////////////////////////////////////
//   loaclStorageData(List<Map<String, dynamic>> list1) async {
//     print("listtt---------$list");
//     list.clear();

//     for (var item in list1) {
//       list.add(item);
//     }
//     notifyListeners();
//     // list = list1;
//     print("listtt-cccc--------$list");
//     notifyListeners();
//   }

// ////////////////////////////////////////////////////////////////
//   setShowHideText(bool value, int index) {
//     print("bbdsbd-----$value");
//     descTextShowFlag[index] = value;
//     notifyListeners();
//   }

//   /////////////////////////////////////////////////////////////////
//   getBarData(List<dynamic> listTest) {
//     print("listTest----$listTest");
//     List<Map<String, dynamic>> listMap = [];
//     Map<String, dynamic> finalList = {};
//     List<Map<String, dynamic>> barDataList = [];
//     Map<String, dynamic> barDataMap = {};
//     // List listTest = [
//     //   {"date": "20/10/2022", "amount1": "100", "amount2": "327"},
//     //   {"date": "4/8/2022", "amount1": "200", "amount2": "190"},
//     //   {"date": "2/10/2022", "amount1": "300", "amount2": "206"},
//     //   {"date": "1/2/2022", "amount1": "400", "amount2": "100"},
//     // ];
//     int c = listTest[0].length;
//     Map tempMap = {};
//     List<Map<String, dynamic>> data = [];
//     for (int j = 1; j < c; j++) {
//       data = [];
//       barColor = [];
//       for (int i = 0; i < listTest.length; i++) {
//         // data.add(listTest[i]);
//         tempMap = listTest[i];
//         String domain = tempMap.values.elementAt(0);
//         double measure = double.parse(tempMap.values.elementAt(j));
//         id = tempMap.keys.elementAt(j);
//         barColor.add(id);
//         // String _string = StringToHex.toHexString(sCon);
//         Map<String, dynamic> mapTest = {"domain": domain, "measure": measure};
//         data.add(
//             {"domain": domain, "measure": measure, "colorId": colorList[j]});
//       }

//       barDataList.add({
//         "id": id,
//         "data": data,
//       });
//     }

//     print("dnzsndsm-------$barDataList");
//     graphMap = {"barData": barDataList};
//     print("graphMap----$graphMap");

//     return barDataList;
//     // reportjson = jsonEncode(graphMap);
//   }

//   //////////////////////////////////////////////////////////////
//   getLegends(List<dynamic> l, String title) {
//     Map<String, dynamic> c = {};
//     colorList.clear();

//     print("from-----$l---");
//     listColor.clear();
//     legends = [];
//     int keyIndex = 0;
//     l[0].keys.forEach((key) {
//       print("key----$key");
//       int key1 = keyIndex * 1215;
//       // textToColor(key, title);
//       Color color1 = textToColor(key1.toString(), title, key);
//       c = {
//         key: color1,
//       };
//       // listColor.add(c);
//       legends.add(key);
//       keyIndex = keyIndex + 1;
//     });

//     print("color and id----$listColor");
//   }

// /////////////////////////////////////////////////////////////////
//   // setColor(Color color, String id) {
//   //   print("idd---------$color----$id");
//   //   // if (idd != id) {
//   //   //   print("cdfk-----$color");
//   //   //   legendList.add({'id': id, 'color': color});
//   //   //   idd = id;
//   //   // }
//   //   if (colorDup != color) {
//   //     colorList.add(color);
//   //     colorDup = color;
//   //   }

//   //   // notifyListeners();
//   // }

// /////////////////////////////////////////////////////////////////
//   textToColor(String id, String title, String key) {
//     DateTime date = DateTime.now();
//     print("date---$id---$date");
//     String sdte = DateFormat('ddMM').format(date);
//     print("iso ----${sdte}");
//     String reverseId = id.split('').reversed.join('');
//     String sCon = reverseId + sdte + title;
//     try {
//       generatedColor = Color((Random().nextDouble() * 0xFF4d47c).toInt() << 0)
//           .withOpacity(1);
//       // _string = StringToHex.toHexString(sCon);
//       // generatedColor = Color(StringToHex.toColor(_string));
//       // generatedColorInt = StringToHex.toColor(_string);
//       print("_string---$generatedColorInt--$_string----$generatedColor");
//     } catch (e) {
//       print("exception-----$e");
//       String sCon2 = id + "1994";
//       String reversed = sCon2.split('').reversed.join('');
//       _string = StringToHex.toHexString(reversed);
//       generatedColor = Color(StringToHex.toColor(_string));
//       // generatedColorInt = StringToHex.toColor(_string);
//     }
//     var hex = '#${generatedColor!.value.toRadixString(16)}';
//     colorList.add(hex);
//     // listColor.add(generatedColor!);
//     print("colorList--------$colorList");
//     return generatedColor;
//   }

// /////////////////////////////////////////////////////////////////
//   setDropdowndata(String s) {
//     brId = s;
//     for (int i = 0; i < branches.length; i++) {
//       if (branches[i]["branch_id"] == s) {
//         selected = branches[i]["branch_name"];
//       }
//     }
//     print("s------$s");
//     notifyListeners();
//   }

//   setMenuClick(bool value) {
//     menuClick = value;
//     print("menu click------$menuClick");

//     notifyListeners();
//   }

//   setMenuindex(String ind) {
//     menu_index = ind;
//     tab_index = ind;
//     print("mnadmn------$tab_index");
//     notifyListeners();
//   }

//   setCustomReportIndex(String inde) {
//     customIndex = inde;
//     print("customIndex------$customIndex");
//     notifyListeners();
//   }

//   setDateCriteria(String inde) {
//     date_criteria = inde;
//     print("date_criteria------$date_criteria");
//     notifyListeners();
//   }

//   setClicked(String clik) {
//     clicked = clik;
//     notifyListeners();
//   }

//   getProducts(
//     BuildContext context,
//   ) {
//     NetConnection.networkConnection(context).then((value) async {
//       if (value == true) {
//         try {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           String? branchId = prefs.getString("branch_id");
//           String? userId = prefs.getString("user_id");
//           Uri url = Uri.parse("$urlgolabl/load_report.php");
//           Map body = {
//             'staff_id': userId,
//             'branch_id': branchId,
//           };
//           // ignore: avoid_print
//           print("menu body--$body");
//           isLoading = true;
//           notifyListeners();

//           productList = [
//             {"id": "1", "item": "cool cake", "stock": "200"},
//             {"id": "2", "item": "groundnut", "stock": "200"},
//             {"id": "3", "item": "sugar", "stock": "200"},
//             {"id": "4", "item": "tool dall organic", "stock": "200"},
//             {"id": "5", "item": "garlic luduva", "stock": "200"},
//             {"id": "6", "item": "moong dall", "stock": "200"}
//           ];
//           // http.Response response = await http.post(url, body: body);
//           // var map = jsonDecode(response.body);
//           // // ignore: avoid_print
//           // print("map----$map");
//           // productList.clear();
//           // for (var item in map) {
//           //   productList.add(item);
//           // }
//           isLoading = false;
//           notifyListeners();
//         } catch (e) {
//           // return null;
//           return [];
//         }
//       }
//     });
//   }

//   productSearchHistory(BuildContext context, String text) {
//     NetConnection.networkConnection(context).then((value) async {
//       if (value == true) {
//         try {
//           issearching = true;
//           notifyListeners();
//           if (text.isNotEmpty) {
//             isSearch = true;
//             notifyListeners();
//             newList = productList
//                 .where((e) =>
//                     e["item"].contains(text) || e["item"].startsWith(text))
//                 .toList();
//           } else
//             newList = productList;
//           issearching = false;
//           notifyListeners();
//           print("new list----$newList");
//         } catch (e) {
//           // return null;
//           return [];
//         }
//       }
//     });
//   }

//   _write(String text) async {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final File file = File('${directory.path}/my_file.txt');
//     print("textbbb----$text");
//     await file.writeAsString(text);
//   }

//   Future<String> _read() async {
//     String? text;
//     try {
//       final Directory directory = await getApplicationDocumentsDirectory();
//       final File file = File('${directory.path}/my_file.txt');
//       text = await file.readAsString();
//       print(" read file ---- $text");
//     } catch (e) {
//       text = "";
//       print("Couldn't read file");
//     }
//     return text;
//   }

//   setIssearch(bool val) {
//     isSearch = val;
//     notifyListeners();
//   }

//   void onSearchTextChanged(String text, Map list) {
//     print("text --- $text");
//     filteredData = text.isEmpty
//         ? list["data"]
//         : list["data"]
//             .where((item) =>
//                 item['DESCRIPTION']
//                     .toLowerCase()
//                     .contains(text.toLowerCase()) ||
//                 item['VALUE'].toLowerCase().contains(text.toLowerCase()))
//             .toList();
//     // notifyListeners();
//     list["data"] = filteredData;
//     jsonEncoded = json.encode(list);
//     notifyListeners();
//     print("filtered data----$jsonEncoded");
//   }

//   setjsonEncode(var jsonE) {
//     jsonEncoded = jsonE;
//     // notifyListeners();
//   }
// }
