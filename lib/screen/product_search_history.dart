import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../components/commonColor.dart';
import '../controller/controller.dart';

class ProductHistory extends StatefulWidget {
  const ProductHistory({super.key});

  @override
  State<ProductHistory> createState() => _ProductHistoryState();
}

class _ProductHistoryState extends State<ProductHistory> {
  final String url = 'https://jsonplaceholder.typicode.com/users';
  TextEditingController controller = new TextEditingController();

  // // Get json result and convert it to model. Then add
  // Future<Null> getUserDetails() async {
  //   final response = await http.get(url);
  //   final responseJson = json.decode(response.body);

  //   setState(() {
  //     for (Map user in responseJson) {
  //       _userDetails.add(UserDetails.fromJson(user));
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();

    Provider.of<Controller>(context, listen: false).getProducts(
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: P_Settings.purple,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus!.unfocus();
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Consumer<Controller>(
        builder: (context, value, child) => Column(
          children: [
            new Container(
              color: P_Settings.purple,
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Card(
                  child: new ListTile(
                    leading: new Icon(Icons.search),
                    title: new TextField(
                      controller: controller,
                      decoration: new InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                      onChanged: (val) {
                        print("vaaaaa----$val");
                        Provider.of<Controller>(context, listen: false)
                            .productSearchHistory(context, val);
                      },
                    ),
                    trailing: new IconButton(
                      icon: new Icon(Icons.cancel),
                      onPressed: () {
                        value.setIssearch(false);
                        controller.clear();
                        // onSearchTextChanged('');
                      },
                    ),
                  ),
                ),
              ),
            ),
            value.issearching
                ? SpinKitCircle(
                    color: P_Settings.purple,
                  )
                : value.isSearch && value.newList.length > 0
                    ? searchCard()
                    : value.isSearch && value.newList.length == 0
                        ? Padding(
                            padding: const EdgeInsets.only(top: 14, left: 13),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "No data Found !!!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          )
                        : productCard()

            // value.productList.length == 0
            //     ? Expanded(
            //         child: Lottie.asset(
            //           'asset/nodata.json',
            //           height: size.height * 0.25,
            //           width: size.height * 0.25,
            //         ),
            //       )
            //     :
          ],
        ),
      ),
    );
  }

  Widget searchCard() {
    return Consumer<Controller>(
      builder: (context, value, child) => Expanded(
          child: ListView.builder(
        itemCount: value.newList.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: ListTile(
                  onTap: () {
                    showModalSheet(value.newList[index]);
                  },
                  leading: CircleAvatar(),
                  title: Text(
                      value.newList[index]["item"].toString().toUpperCase()),
                  subtitle: Text("Stock : ${value.newList[index]["stock"]}"),
                )),
          );
        },
      )),
    );
  }

  Widget productCard() {
    return Consumer<Controller>(
      builder: (context, value, child) => Expanded(
          child: ListView.builder(
        itemCount: value.productList.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: ListTile(
                  onTap: () {
                    showModalSheet(value.productList[index]);
                  },
                  leading: CircleAvatar(),
                  title: Text(value.productList[index]["item"]
                      .toString()
                      .toUpperCase()),
                  subtitle: Text("Stock : ${value.productList[index]["stock"]}"),
                )),
          );
        },
      )),
    );
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
              map["item"].toString().toUpperCase(),
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
