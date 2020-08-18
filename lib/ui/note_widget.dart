import 'package:flutter/material.dart';
import 'package:maksnotes/bl/app_state.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

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
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _contentWidget(context,
              context.watch<AppState>().current?.content ?? '', _appState.edit),
        ),
      ),
    );
  }

  Widget _contentWidget(BuildContext context, String content, bool editing) {
    return editing
        ? TextField(
            decoration: InputDecoration(border: InputBorder.none),
            controller: _editController,
            maxLines: null,
          )
        : MarkdownBody(
            data: content,
            builders: {MARK_TAG: MarkBuilder(Theme.of(context).accentColor)},
            extensionSet: md.ExtensionSet(
              [const md.FencedCodeBlockSyntax()],
              [
                SearchTermHighlight('title', term: 'title'),
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
  final String term;

  SearchTermHighlight(String pattern, {this.term, int startCharacter})
      : super(pattern, startCharacter: startCharacter);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    if (term == null ||
        (match.start > 0 &&
            match.input.substring(match.start - 1, match.start) == '/')) {
      // Just use the original matched text.
      parser.advanceBy(match[0].length);
      return false;
    }

    print("FOUND: $term");
    parser.addNode(md.Element.text(MARK_TAG, term));
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
