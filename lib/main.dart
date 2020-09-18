import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

import 'bl/preferences.dart';
import 'ui/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PrefService.init(prefix: 'pref_');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String appName = 'MkNotes';

  @override
  Widget build(BuildContext context) {
    final page = MainPage(title: appName);
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Provider(
        create: (_) => Preferences(),
        builder: (_, _2) => page,
      ),
    );
  }
}
