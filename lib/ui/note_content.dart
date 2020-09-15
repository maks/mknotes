import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mknotes/ui/tag_list.dart';
import 'package:provider/provider.dart';

import '../bl/app_state.dart';
import '../logging.dart';

/// Otherwise, <mark> indicates a portion of the document's content which
/// is likely to be relevant to the user's current activity. This might be used,
/// for example, to indicate the words that matched a search operation.
///
/// ref: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/mark
const MARK_TAG = 'mark';

class NoteContent extends StatefulWidget {
  NoteContent();

  @override
  _NoteContentState createState() => _NoteContentState();
}

class _NoteContentState extends State<NoteContent> {
  TextEditingController _editController;
  AppState _appState;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController();
    _editController.addListener(_update);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState = context.read<AppState>();
    _editController.text = context.read<AppState>().current?.content ?? '';
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TagList(
              tags: appState.current?.tags,
              editable: appState.edit,
              onAddTag: (tag) => appState.updateCurrentAddTag(tag),
              onDeleteTag: (tag) => appState.updateCurrentRemoveTag(tag),
            ),
            Divider(),
            _contentWidget(
                context,
                context.watch<AppState>().current?.content ?? '',
                _appState.edit,
                _appState.searchTerm),
          ],
        ),
      ),
    );
  }

  Widget _contentWidget(
      BuildContext context, String content, bool editing, String searchTerm) {
    return editing
        ? TextField(
            decoration: InputDecoration(border: InputBorder.none),
            controller: _editController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
          )
        : MarkdownBody(
            data: content,
            builders: {MARK_TAG: MarkBuilder(Theme.of(context).accentColor)},
            extensionSet: md.ExtensionSet(
              [const md.FencedCodeBlockSyntax()],
              [
                if (searchTerm != null && searchTerm.isNotEmpty)
                  SearchTermHighlight('$searchTerm'),
                md.StrikethroughSyntax(),
                md.EmojiSyntax(),
              ],
            ),
          );
  }

  void _update() {
    final currentContent = _editController.text;
    if (currentContent != _appState.current?.content) {
      _appState.updateCurrentContent(currentContent);
    }
  }
}

class SearchTermHighlight extends md.InlineSyntax {
  // we want to override the base classes regex to be case *IN*sensitive
  @override
  final RegExp pattern;

  SearchTermHighlight(String pattern, {int startCharacter})
      : pattern = RegExp(pattern, multiLine: true, caseSensitive: false),
        super(pattern, startCharacter: startCharacter);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    if (match[0] == null ||
        match[0].isEmpty ||
        (match.start > 0 &&
            match.input.substring(match.start - 1, match.start) == '/')) {
    } else {
      Log().debug("MARK FOUND: ${match[0]}");
      parser.addNode(md.Element.text(MARK_TAG, match[0]));
    }
    return true;
  }
}

class MarkBuilder extends MarkdownElementBuilder {
  String _text;
  final Color markColor;

  MarkBuilder(this.markColor);

  @override
  void visitElementBefore(md.Element element) {
    _text = element.textContent;
    super.visitElementBefore(element);
  }

  @override
  Widget visitElementAfter(md.Element element, TextStyle preferredStyle) {
    return RichText(
      text: TextSpan(
        text: _text,
        style: TextStyle(
          backgroundColor: markColor,
        ),
      ),
    );
  }
}
