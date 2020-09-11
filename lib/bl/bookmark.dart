import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mknotes/bl/item.dart';

class Bookmark implements ReferenceItem {
  final String url;
  @override
  final String title;
  final String description;
  final DateTime timestamp;
  @override
  final List<String> tags;

  Bookmark({
    this.url,
    this.title,
    this.description,
    this.timestamp,
    this.tags,
  });

  Bookmark copyWith({
    String url,
    String title,
    String description,
    DateTime timestamp,
    List<String> tags,
  }) {
    return Bookmark(
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'title': title,
      'description': description,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'tags': tags,
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return Bookmark(
      url: map['url'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      tags: List<String>.from(map['tags'] as List<String>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Bookmark.fromJson(String source) =>
      Bookmark.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Bookmark(url: $url, title: $title, description: $description, timestamp: $timestamp, tags: $tags)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true;
    }

    return o is Bookmark &&
        o.url == url &&
        o.title == title &&
        o.description == description &&
        o.timestamp == timestamp &&
        listEquals(o.tags, tags);
  }

  @override
  int get hashCode {
    return url.hashCode ^
        title.hashCode ^
        description.hashCode ^
        timestamp.hashCode ^
        tags.hashCode;
  }
}
