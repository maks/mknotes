import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../extensions.dart';
import 'item.dart';

class Bookmark implements ReferenceItem {
  /// Parse a list of tags as space separated list, from a single  string
  static List<String> parseTags(String tags) =>
      tags.isNotNullOrEmpty ? tags.split(' ') : null;

  final String url;
  @override
  final String title;
  @override
  final String content;
  final DateTime timestamp;
  @override
  final List<String> tags;

  @override
  bool get isUntitled => title == UNTITLED;

  Bookmark({
    this.url,
    this.title,
    this.content,
    this.timestamp,
    this.tags,
  });

  Bookmark copyWith({
    String url,
    String title,
    String content,
    DateTime timestamp,
    List<String> tags,
  }) {
    return Bookmark(
      url: url ?? this.url,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'href': url,
      'description': title,
      'extended': content,
      'time': timestamp?.millisecondsSinceEpoch,
      'tags': tags,
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }
    return Bookmark(
      url: map['href'] as String,
      title: map['description'] as String,
      content: map['extended'] as String,
      timestamp: DateTime.parse(map['time'] as String ?? ''),
      tags: parseTags(map['tags'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Bookmark.fromJson(String source) =>
      Bookmark.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Bookmark(url: $url, title: $title, description: $content, timestamp: $timestamp, tags: $tags)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true;
    }

    return o is Bookmark &&
        o.url == url &&
        o.title == title &&
        o.content == content &&
        o.timestamp == timestamp &&
        listEquals(o.tags, tags);
  }

  @override
  int get hashCode {
    return url.hashCode ^
        title.hashCode ^
        content.hashCode ^
        timestamp.hashCode ^
        tags.hashCode;
  }
}
