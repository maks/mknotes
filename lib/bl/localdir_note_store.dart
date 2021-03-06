import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:front_matter/front_matter.dart' as fm;
import 'package:meta/meta.dart';
import 'package:mknotes/bl/pinboard_bookmarks.dart';
import 'package:path/path.dart' as path;
import 'package:rxdart/rxdart.dart';
import 'package:yaml/yaml.dart' as yaml;

import '../extensions.dart';
import '../logging.dart';
import 'filters.dart';
import 'note.dart';
import 'note_store.dart';

/// Local file based store
class LocalDirNoteStore implements NoteStore {
  final Directory notesDir;
  final _notesListStream = BehaviorSubject<Set<Note>>();
  final Set<Note> _fullList = {};

  LocalDirNoteStore({@required this.notesDir, PinboardBookmarks bookmarks}) {
    final notesListStream = notesDir.list();

    notesListStream
        .where((f) => !path.basename(f.absolute.path).startsWith('.'))
        .asyncMap(
          (f) async => _parseNoteText(f as File),
        )
        .scan<List<Note>>(
            (accumulated, value, index) => accumulated..add(value), []).forEach(
      (notes) {
        _fullList.addAll(notes);
        _notesListStream.add(_fullList);
      },
    );
  }

  @override
  Stream<List<Note>> get items =>
      _notesListStream.stream.map((s) => s.toList());

  Future<String> _safeReadFile(File f) async {
    String result;
    try {
      result = await f?.readAsString();
    } catch (e) {
      Log().debug('error reading file $f: $e');
      result = '';
    }
    return result;
  }

  @override
  void saveNote(Note note) {
    String fileContent = '';
    if (note.tags.isNotEmpty) {
      fileContent = ('---\ntags: ${_listAsYamlString(note.tags)}\n---\n');
    }
    fileContent += note.content;
    File(path.join(notesDir.path, note.filename)).writeAsString(fileContent);
  }

  @override
  void filter(Filter filter) {
    if (filter == null) {
      _notesListStream.add(_fullList);
    } else {
      _notesListStream
          .add(_fullList.where((note) => filter.apply(note)).toSet());
    }
  }

  @override
  void dispose() {
    _notesListStream.close();
  }

  @override
  void addNote(Note note) {
    _fullList.add(note);
    // FIXME: need to change this as it will clear any filter being currently applied
    _notesListStream.add(_fullList);
  }

  @override
  void updateNote(Note old, Note nue) {
    _fullList.remove(old);
    _fullList.add(nue);
    _notesListStream.add(_fullList);
  }

  // parse contents of a file into a Note
  Future<Note> _parseNoteText(File f) async {
    final content = await _safeReadFile(f);
    final filename = path.basename(f.absolute.path);
    final title =
        path.basenameWithoutExtension(f.absolute.path).replaceAll('_', ' ');

    return parseNoteText(filename, title, content);
  }

  Future<Note> parseNoteText(
      String filename, String title, String content) async {
    if (content?.startsWith('---') ?? false) {
      final fmDoc = fm.parse(content);

      return Note(
        id: filename,
        title: fmDoc.getData('title') as String ?? title,
        content: fmDoc.content,
        tags: _asStringList(fmDoc.getData('tags')) ?? [],
      );
    } else {
      return Note(
        id: filename,
        title: title,
        content: content,
      );
    }
  }

  List<String> _asStringList(dynamic d) {
    if (d is yaml.YamlList) {
      return d.map((dynamic e) => e.toString()).toList();
    } else {
      return null;
    }
  }

  String _listAsYamlString(List<String> list) {
    return jsonEncode(list);
  }
}
