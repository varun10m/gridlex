import 'package:flutter/material.dart';
import 'package:gridlex_assessment/Home/UI/HomeScreen.dart';
import 'package:gridlex_assessment/Utils/Utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    print(" Firebase init done ${value.name}");
  }, onError: onError);
  final appDocumentDirectory =
      await pathProvider.getApplicationDocumentsDirectory();

  Hive.init(appDocumentDirectory.path);
  await Hive.openBox("tempFormData");
  print("Box Opened");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gridlex',
      theme: buildThemeData(),
      home: HomeScreen(),
    );
  }
}

onError(e) {
  print("Error while init firebase $e");
}
