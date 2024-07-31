import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localdir_note_store.dart';
import 'providers.dart';

class App extends ConsumerStatefulWidget {
  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  final String appName = 'MkNotes';

  @override
  Widget build(BuildContext context) {
    return ref.watch(prefsProvider).when(
          data: (prefs) {
            return MaterialApp(
              title: appName,
              home: PageScreen(localStore),
              theme: ThemeData(
                primarySwatch: Colors.blue,
                brightness: Brightness.dark,
                primaryColor: Colors.lightBlue[800],
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => const Center(child: Text("error loading")),
        );
  }
}

class PageScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
