import 'package:flutter/material.dart';
import '../bl/app_state.dart';
import 'package:provider/provider.dart';

class SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        autofocus: true,
        maxLines: 1,
        decoration: InputDecoration(hintText: 'search'),
        onSubmitted: (text) => context.read<AppState>().search(text),
      ),
    );
  }
}
