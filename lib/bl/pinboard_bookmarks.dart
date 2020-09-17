import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:pinboard/pinboard.dart' as pb;
import 'package:rxdart/rxdart.dart';

import '../logging.dart';
import 'bookmark.dart';

Future<Set<Bookmark>> readBookmarksFile(File bookmarksfile) async {
  final bookmarksJson = await bookmarksfile.readAsString();
  return await parseBookmarksJson(bookmarksJson);
}

Future<Set<Bookmark>> parseBookmarksJson(String json) async {
  final List<dynamic> parsed = jsonDecode(json) as List<dynamic>;

  return Future.value(parsed
      .map<Bookmark>((dynamic jsonMap) =>
          Bookmark.fromMap(jsonMap as Map<String, dynamic>))
      .toSet());
}

/// Access to Pinboard Bookmarks with local caching
class PinboardBookmarks {
  final __bookmarksListStream = BehaviorSubject<Set<Bookmark>>();
  final File _bookmarksCache;
  pb.Pinboard pbClient;

  Future<bool> get haveLocalCache async => _bookmarksCache.exists();

  PinboardBookmarks(
      {@required String username,
      @required String token,
      @required Directory cacheDir})
      : _bookmarksCache = File(path.joinAll([cacheDir.path, '.bookmarks'])) {
    pbClient = pb.Pinboard(username: username, token: token);

    // call async function to load trigger loading bookmarks
    _load();
  }

  void _load() async {
    if (await haveLocalCache) {
      await _loadBookmarksFromFile();
      //TODO: then add any newer bookmarks from pinboard
    } else {
      _fetchAllBookmarks();
    }
  }

  Future<void> _loadBookmarksFromFile() async {
    Log().debug('loading bookmarks...');
    final stopwatch = Stopwatch()..start();
    final bookmarks = await compute(readBookmarksFile, _bookmarksCache);

    Log().debug(
        'loaded ${bookmarks.length} bookmarks in ${stopwatch.elapsed.inMilliseconds}ms');
    __bookmarksListStream.add(bookmarks);
  }

  void _fetchAllBookmarks() async {
    final posts = await pbClient.posts.all();
    final _fullBookmarkList = posts
        .map((p) => Bookmark(
              id: p.hash,
              title: p.description,
              content: p.extended,
              tags: p.tags,
            ))
        .toSet();
    __bookmarksListStream.add(_fullBookmarkList);
  }
}