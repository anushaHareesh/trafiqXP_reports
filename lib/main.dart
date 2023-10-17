import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:trafiqxpreports/components/commonColor.dart';
import 'package:trafiqxpreports/controller/controller.dart';
import 'package:trafiqxpreports/screen/splashScreen.dart';

// andra -----company key ---RPF23TYXLRLR
//  user-----shameem,, pwd---123

// pk holdings-----RHVZT0N9LRLR
// user------user,pwd---123
void requestPermission() async {
  var status = await Permission.storage.status;
  // var statusbl= await Permission.bluetooth.status;

  var status1 = await Permission.manageExternalStorage.status;

  if (!status1.isGranted) {
    await Permission.storage.request();
  }
  if (!status1.isGranted) {
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      await Permission.bluetooth.request();
    } else {
      openAppSettings();
    }
    // await Permission.app
  }
  if (!status1.isRestricted) {
    await Permission.manageExternalStorage.request();
  }
  if (!status1.isPermanentlyDenied) {
    await Permission.manageExternalStorage.request();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  requestPermission();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Controller()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: P_Settings.purple,
        fontFamily: GoogleFonts.aBeeZee().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
