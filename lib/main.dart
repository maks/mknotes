import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

void main() {
  runApp(const ProviderScope(
    child: App(),
  ));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final currentNote = ref.watch(currentNoteModelProvider);
    return MaterialApp(
      title: 'MkNotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(title: currentNote.title),
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final _controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) => ref.read(currentNoteModelProvider.notifier).updateContent(value),
            ),
          ],
        ),
      ),
    );
  }
}
