import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trafiqxpreports/bottomSheet/detail.dart';
import 'package:trafiqxpreports/components/commonColor.dart';
import 'package:trafiqxpreports/controller/controller.dart';

class GraphDataTable extends StatefulWidget {
  var decodd;
  int index;
  String keyVal;
  GraphDataTable(
      {required this.decodd, required this.index, required this.keyVal});

  @override
  State<GraphDataTable> createState() => _GraphDataTableState();
}

class _GraphDataTableState extends State<GraphDataTable> {
  String? key;
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  DetailedInfoSheet info = DetailedInfoSheet();
  Map<String, dynamic> mapTabledata = {};
  List<String> tableColumn = [];
  Map<String, dynamic> valueMap = {};
  List<Map<dynamic, dynamic>> newMp = [];
  List<Map<dynamic, dynamic>> filteredList = [];
  List<dynamic> rowMap = [];
  double? datatbleWidth;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.decodd != null) {
      mapTabledata = json.decode(widget.decodd);
      print("shrinked   mapTabledata---${mapTabledata}");
    } else {
      print("null");
    }
    rowMap = mapTabledata["data"];
    mapTabledata["data"][0].forEach((key, value) {
      tableColumn.add(key);
    });
    newMp.clear();
    filteredList.clear();
    calculateSum(mapTabledata["data"], mapTabledata["data"][0].length,
        mapTabledata["sum"]);
    rowMap.forEach((element) {
      print("element-----$element");
      newMp.add(element);
      filteredList.add(element);
    });
    print("newMp---${newMp}");
    // key = newMp[0].keys.toList().first;
    if (widget.keyVal != "0") {
      int ele = int.parse(widget.keyVal) - 1;
      key = newMp[0].keys.elementAt(ele);
    }
  }

//////////////////////////////////////////////////////////////////////////////
  Widget build(BuildContext context) {
    // FocusScope.of(context).requestFocus(FocusNode());

    Size size = MediaQuery.of(context).size;
    datatbleWidth = size.width * 0.95;
    print(
        "screen width-----${size.width}------datatble width-----$datatbleWidth");
    return Center(
      child: Container(
        // alignment: Alignment.center,
        width: datatbleWidth,
        child: Scrollbar(
          controller: _scrollController,
          child: Consumer<Controller>(
            builder: (context, value, child) => Column(
              children: [
                widget.keyVal == "0"
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Container(
                          height: size.height * 0.05,
                          // width: 200,
                          // margin: EdgeInsets.only(left: 3, right:3),
                          child: TextFormField(
                            controller: value.listEditor[widget.index],
                            //   decoration: const InputDecoration(,
                            onChanged: (value) {
                              setState(() {
                                // String key = newMp[0].keys.toList().first;
                                // print(newMp[0].keys.toList().first);
                                print("nw----${newMp[0].keys.toList().first}");
                                filteredList = value.isEmpty ||
                                        value == null ||
                                        value == " "
                                    ? newMp
                                    : newMp
                                        .where((item) => item[key]
                                                .toLowerCase()
                                                .startsWith(value.toLowerCase())
                                            //     ||
                                            // item['VALUE']
                                            //     .toLowerCase()
                                            //     .contains(text.toLowerCase())

                                            )
                                        .toList();
                                print("after filter-------$newMp");
                              });
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.blue,
                                ),
                                // suffixIcon: IconButton(
                                //   icon: new Icon(Icons.cancel),
                                //   onPressed: () {
                                //     // Provider.of<QuotationController>(context,
                                //     //         listen: false)
                                //     //     .setQuotSearch(false);
                                //     value.listEditor[widget.index].text=" ";
                                //     value.listEditor[widget.index].clear();
                                //   },
                                // ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 128, 125, 125),
                                      width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 128, 125, 125),
                                      width: 0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 128, 125, 125),
                                      width: 0.0),
                                ),
                                filled: true,
                                hintStyle:
                                    TextStyle(color: Colors.blue, fontSize: 13),
                                hintText: "Search $key here.. ",
                                fillColor: Colors.grey[100]),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(bottom: (8.0)),
                  child: DataTable(
                    showCheckboxColumn: false,
                    columnSpacing: 7,
                    headingRowHeight: 40,
                    dataRowHeight: 35,
                    horizontalMargin: 5,
                    // sortColumnIndex: _currentSortColumn,
                    // sortAscending: _isSortAsc,
                    // decoration: BoxDecoration(color: P_Settings.bar1Color),
                    // border: TableBorder.all(
                    //   color: P_Settings.bar1Color,
                    // ),
                    // headingRowColor:MaterialStateProperty.all(Color.fromARGB(255, 238, 236, 236)) ,
                    columns: getColumns(tableColumn, mapTabledata["align"],
                        mapTabledata["width"], mapTabledata["sum"]),
                    rows: getRowss(
                        filteredList,
                        mapTabledata["align"],
                        mapTabledata["width"],
                        mapTabledata["sum"],
                        value.listEditor[widget.index]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////
  List<DataColumn> getColumns(
      List<String> columns, String alignment, String width, String sum) {
    String behv;
    String colsName;
    double colwidth = 0.0;
    List<DataColumn> datacolumnList = [];
    print("alignment --------${rowMap}");
    List<String> ws = width.split(',');

    for (int i = 0; i < columns.length; i++) {
      if (ws.length == 0) {
        colwidth = (datatbleWidth! / columns.length);
      } else {
        colwidth = (datatbleWidth! * double.parse(ws[i]) / 100);
      }
      colwidth = colwidth * 0.94;
      datacolumnList.add(DataColumn(
        // onSort: (columnIndex, _) {
        //   setState(() {
        //     _currentSortColumn = columnIndex;
        //     if (_isSortAsc) {
        //       newMp.sort((a, b) => b[columns[0]].compareTo(a[columns[0]]));
        //     } else {
        //       newMp.sort((a, b) => a[columns[0]].compareTo(b[columns[0]]));
        //     }
        //     _isSortAsc = !_isSortAsc;
        //   });
        // },
        label: ConstrainedBox(
          constraints: BoxConstraints(minWidth: colwidth, maxWidth: colwidth),
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Text(columns[i].toUpperCase(),
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                textAlign:
                    alignment[i] == "L" ? TextAlign.left : TextAlign.right),
          ),
        ),
      ));
    }
    return datacolumnList;
    // return columns.map((String column) {
    //   return DataColumn(
    //     label: ConstrainedBox(
    //       constraints: BoxConstraints(minWidth: 90, maxWidth: 90),
    //       child: Padding(
    //         padding: EdgeInsets.all(0.0),
    //         child: Text(column.toUpperCase(),
    //             style: TextStyle(fontSize: 12), textAlign: TextAlign.right),
    //       ),
    //     ),
    //   );
    // }).toList();
  }

  ////////////////////////////////////////////////////////////////
  List<DataRow> getRowss(List<Map<dynamic, dynamic>> row, String align,
      String width, String sum, TextEditingController controller) {
    print("rowjsjfkd-----$row");
    List<DataRow> items = [];

    var itemList = filteredList;
    for (var r = 0; r < itemList.length; r++) {
      items.add(DataRow(
          // onSelectChanged: (selected) {
          //   print("selected------$selected");
          //   if (selected!) {
          //     showModalSheet(itemList[r]);
          //   }
          // },
          color: r == itemList.length - 1
              ? controller.text == ""
                  ? MaterialStateProperty.all(P_Settings.sumColor)
                  : MaterialStateProperty.all(P_Settings.rowColor)
              : MaterialStateProperty.all(P_Settings.rowColor),
          cells: getCelle(itemList[r], align, width, sum)));
    }
    return items;

    // return newMp.map((row) {
    //   return DataRow(
    //     cells: getCelle(row),
    //   );
    // }).toList();
  }

  //////////////////////////////////////////////////////////////
  List<DataCell> getCelle(
      Map<dynamic, dynamic> data, String alignment, String width, String sum) {
    String behv;
    String colsName;

    String? dval;
    double colwidth = 0.0;
    print("data--$data");
    List<DataCell> datacell = [];
    List<String> ws = width.split(',');

    print("data-------$data");
    String text = data.values.elementAt(0);
    for (var i = 0; i < tableColumn.length; i++) {
      if (ws.length == 0) {
        colwidth = (datatbleWidth! / tableColumn.length);
      } else {
        colwidth = (datatbleWidth! * double.parse(ws[i]) / 100);
      }
      colwidth = colwidth * 0.94;
      data.forEach((key, value) {
        if (tableColumn[i] == key) {
          if (sum[i] == "Y") {
            print("fbfb------${value.runtimeType}");
            double d = double.parse(value);
            dval = d.toStringAsFixed(2);
          } else {
            print("ghdhjd---$value");
            if (value == null || value.isEmpty || value == " ") {
              dval = value;
            } else {
              RegExp _numeric = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
              bool isnum = _numeric.hasMatch(value);
              print("isnum ----$isnum-----$_numeric");
              if (isnum) {
                double d = double.parse(value);
                dval = d.toStringAsFixed(2);
              } else {
                dval = value;
              }
            }
            // double d = double.parse(value);
            // dval = d.toStringAsFixed(2);
          }
          datacell.add(
            DataCell(
              // onTap: () {

              //   info.showInfoSheet(context, text);
              // },
              Container(
                constraints:
                    BoxConstraints(minWidth: colwidth, maxWidth: colwidth),
                // width: 70,
                alignment: alignment[i] == "L"
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                // alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                  // padding: behv[1] == "L"? EdgeInsets.only(left:0.3):EdgeInsets.only(right:0.3),
                  child: Text(
                    dval.toString(),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          );
        }
      });
    }
    print(datacell.length);
    return datacell;
  }

  /////////////////////////////////////////////////////////////////////
  calculateSum(List<dynamic> element, int c, String isSum) {
    Map map = {};
    Map finalmap = {};
    print("dynamic elemnt-----$element--$isSum");
    double sum = 0.0;
    String? key;
    for (int i = 0; i < c; i++) {
      if (isSum[i] == "Y") {
        for (int j = 0; j < element.length; j++) {
          key = element[j].keys.elementAt(i);
          double d = double.parse(element[j].values.elementAt(i));
          print("zjsnjzsnd-----${d}");
          sum = sum + d;
        }
        map[key] = sum.toStringAsFixed(2);
        sum = 0.0;
      } else {
        map[element[i].keys.elementAt(i)] = "";
      }
    }
    element.add(map);
    print("sum-----$element");
  }

  showModalSheet(Map map) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                      ))
                ],
              ),
            ),
            Text(
              map["Supplier"].toString().toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}
