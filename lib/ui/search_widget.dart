import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: TextField(
        autofocus: true,
        maxLines: 1,
        decoration: InputDecoration(hintText: 'search'),
      ),
    );
  }
}
