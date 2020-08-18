import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

/// Otherwise, <mark> indicates a portion of the document's content which
/// is likely to be relevant to the user's current activity. This might be used,
/// for example, to indicate the words that matched a search operation.
///
/// ref: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/mark
const MARK_TAG = 'mark';

class NoteContent extends StatefulWidget {
  final String content;

  NoteContent(this.content);

  @override
  _NoteContentState createState() => _NoteContentState();
}

class _NoteContentState extends State<NoteContent> {
  bool _edit = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _contentWidget(context),
        ),
      ),
    );
  }

  Widget _contentWidget(BuildContext context) {
    return _edit
        ? Text(widget.content ?? '')
        : MarkdownBody(
            data: widget.content ?? '',
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