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
      .map<Bookmark>(
          (dynamic jsonText) => Bookmark.fromJson(jsonText as String))
      .toSet());
}

/// Access to Pinboard Bookmarks with local caching
class PinboardBookmarks {
  final __bookmarksListStream = BehaviorSubject<Set<Bookmark>>();
  final File _bookmarksCache;
  pb.Pinboard pbClient;

  Future<bool> get haveLocalCache async => _bookmarksCache.exists();

  Stream<List<Bookmark>> get items =>
      __bookmarksListStream.stream.map((s) => s.toList());

  PinboardBookmarks(
      {@required String username,
      @required String token,
      @required Directory cacheDir})
      : _bookmarksCache = File(path.joinAll([cacheDir.path, '.bookmarks'])) {
    pbClient = pb.Pinboard(username: username, token: token);
  }

  void load() async {
    final lastBookmarkUpdate =
        File(path.join(_bookmarksCache.parent.path, '.update_ts'));
    if (await haveLocalCache) {
      await _loadBookmarksFromFile();
      final ts = await lastBookmarkUpdate.readAsString();
      final update = await pbClient.posts.update();
      final lastCacheUpdate =
          DateTime.fromMillisecondsSinceEpoch(int.parse(ts)).toUtc();
      print(
          'last bookmark update: ${update.update_time}, lastcache: ${lastCacheUpdate}');
      if (update.update_time.isAfter(lastCacheUpdate)) {
        await _cacheAllBookmarks(lastBookmarkUpdate);
      }
    } else {
      await _cacheAllBookmarks(lastBookmarkUpdate);
    }
  }

  Future<void> _cacheAllBookmarks(File lastUpdate) async {
    final bookmarks = await _fetchAllBookmarks();
    await _bookmarksCache.writeAsString(
      jsonEncode(bookmarks.toList()),
      flush: true,
    );
    await lastUpdate
        .writeAsString("${DateTime.now().toUtc().millisecondsSinceEpoch}");
  }

  Future<void> _loadBookmarksFromFile() async {
    Log().debug('loading bookmarks...');
    final stopwatch = Stopwatch()..start();
    final bookmarks = await compute(readBookmarksFile, _bookmarksCache);

    Log().debug(
        'loaded ${bookmarks.length} bookmarks in ${stopwatch.elapsed.inMilliseconds}ms');
    __bookmarksListStream.add(bookmarks);
  }

  Future<Set<Bookmark>> _fetchAllBookmarks() async {
    final posts = await pbClient.posts.all();
    final Set<Bookmark> fullBookmarkList = posts
        .map((p) => Bookmark(
              id: p.hash,
              title: p.description,
              url: p.href,
              content: p.extended,
              timestamp: DateTime.parse(p.time),
              tags: p.tags,
            ))
        .toSet();
    __bookmarksListStream.add(fullBookmarkList);
    return fullBookmarkList;
  }
}
