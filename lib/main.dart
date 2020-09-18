import 'dart:io';

import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'bl/preferences.dart';
import 'logging.dart';
import 'ui/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PrefService.init(prefix: 'pref_');
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('mknotes');
    setWindowFrame(Rect.fromLTRB(1139.0, 517.0, 1861.0, 1125.0));
    _windowInfo();
  }
  runApp(MyApp());
}

void _windowInfo() async {
  final window = await getWindowInfo();
  Log().debug("initial window size: ${window.frame}");
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
