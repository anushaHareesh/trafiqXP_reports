import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';

import '../components/commonColor.dart';
import '../components/externalDir.dart';
import '../controller/controller.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  final _formKey = GlobalKey<FormState>();
  FocusNode? fieldFocusNode;
  TextEditingController codeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? manufacturer;
  String? model;
  String? fp;
  String? textFile;
  ExternalDir externalDir = ExternalDir();
  late String uniqId;

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        manufacturer = deviceData["manufacturer"];
        model = deviceData["model"];
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'manufacturer': build.manufacturer,
      'model': build.model,
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deletemenu();
    initPlatformState();
  }

  deletemenu() async {
    print("delete");
    // await OrderAppDB.instance.deleteFromTableCommonQuery('menuTable', "");
  }

  @override
  Widget build(BuildContext context) {
    // final textfile = externalDirtext.getPublicDirectoryPath("");
    // print("Textfile data....$textfile");
    double topInsets = MediaQuery.of(context).viewInsets.top;
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        backgroundColor: P_Settings.purple,
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        body: InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            reverse: true,
            child: Consumer<Controller>(
              builder: (context, value, child) {
                return Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              height: 500,
                              width: 300,
                              child: SvgPicture.asset(
                                "asset/signup.svg",
                                height: 300,
                              )),

                          customTextField("Company key", codeController,
                              "company key", context),
                          customTextField("Phone number", phoneController,
                              "phone", context),

                          SizedBox(
                            height: size.height * 0.04,
                          ),
                          Container(
                            width: size.width * 0.4,
                            height: size.height * 0.05,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  String deviceInfo =
                                      "$manufacturer" + '' + "$model";
                                  print("device info-----$deviceInfo");
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => LoginPage()),
                                  // );

                                  // await OrderAppDB.instance
                                  //     .deleteFromTableCommonQuery('menuTable', "");
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  if (_formKey.currentState!.validate()) {
                                    String tempFp1 =
                                        await externalDir.fileRead();
                                    // String? tempFp1=externalDir.tempFp;

                                    // if(externalDir.tempFp==null){
                                    //    tempFp="";
                                    // }
                                    print("tempFp---${tempFp1}");
                                    // textFile = await externalDir
                                    //     .getPublicDirectoryPath();
                                    // print("textfile........$textFile");

                                    Provider.of<Controller>(context,
                                            listen: false)
                                        .postRegistration(
                                            codeController.text,
                                            tempFp1,
                                            phoneController.text,
                                            deviceInfo,
                                            context);
                                
                                  }
                                },
                                label: Text(
                                  "REGISTER",
                                  style: GoogleFonts.aBeeZee(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: P_Settings.purple,
                                  ),
                                ),
                                icon: value.isLoginLoad
                                    ? Container(
                                        width: 24,
                                        height: 24,
                                        padding: const EdgeInsets.all(2.0),
                                        child: CircularProgressIndicator(
                                          color: P_Settings.purple,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : Icon(
                                        Icons.arrow_back,
                                        color: P_Settings.purple,
                                      ),
                                style: ElevatedButton.styleFrom(
                                  primary: P_Settings.whiteColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(15), // <-- Radius
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // SizedBox(
                          //   height: size.height * 0.09,
                          // ),

                          // Consumer<Controller>(
                          //   builder: (context, value, child) {
                          //     if (value.isLoading) {
                          //       return SpinKitCircle(
                          //           // backgroundColor:,
                          //           color: Colors.black

                          //           // valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                          //           // value: 0.25,
                          //           );
                          //     } else {
                          //       return Container();
                          //     }
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget customTextField(String hinttext, TextEditingController controllerValue,
      String type, BuildContext context) {
    double topInsets = MediaQuery.of(context).viewInsets.top;
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.09,
      child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
          child: TextFormField(
            keyboardType: type == "phone" ? TextInputType.number : null,
            style: TextStyle(color: P_Settings.purple),
            // scrollPadding:
            //     EdgeInsets.only(bottom: topInsets + size.height * 0.34),
            controller: controllerValue,
            decoration: InputDecoration(
                filled: true,
                fillColor: P_Settings.whiteColor,
                contentPadding: EdgeInsets.zero,
                prefixIcon: type == "company key"
                    ? Icon(
                        Icons.business,
                        color: P_Settings.purple,
                      )
                    : Icon(
                        Icons.phone,
                        color: P_Settings.purple,
                      ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: P_Settings.purple, width: 1.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: P_Settings.purple,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.red,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.red,
                    )),
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: P_Settings.purple,
                ),
                hintText: hinttext.toString()),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Please Enter ${hinttext}';
              } else if (type == "phone" && text.length != 10) {
                return 'Please Enter Valid Phone No ';
              }
              return null;
            },
          )),
    );
  }
}

Future<bool> _onBackPressed(BuildContext context) async {
  return await showDialog(context: context, builder: (context) => exit(0));
}
