import 'package:test/test.dart';
import 'package:mknotes/bl/bookmark.dart';

const json1 = ''' {
        "href": "https:\/\/twitter.com\/benwood\/status\/1301217548831260673\/photo\/1",
        "description": "Twitter",
        "extended": "RT @benwood: Evolution... #Communicator to @SamsungMobile #GalaxyZFold2 \ud83d\udc49\ud83c\udffb HP OmniGo 700LX, Communicator 9000, 9110, 9210, 9500, E90, Galaxy Fold, Galaxy Z Fold2 5G ",
        "meta": "b545612ce85c7b984c862c9e2e2e1779",
        "hash": "a5ba2a5e828027eb3e4b1216a2cdfe82",
        "time": "2020-09-03T03:58:16Z",
        "shared": "no",
        "toread": "no",
        "tags": ""
    }
''';

const json2 = '''
    {
        "href": "http:\/\/maksimlin.com",
        "description": "my personal website",
        "extended": "",
        "meta": "9874354596a2603704dd4ec5eeb73ed7",
        "hash": "37b6526014440e6afc7ff771b4f4f451",
        "time": "2020-09-03T00:28:44Z",
        "shared": "no",
        "toread": "no",
        "tags": "this is my website"
    }
''';

void main() {
  test('bookmark from json string no tags', () async {
    final bookmark = Bookmark.fromJson(json1);

    expect(bookmark, isNotNull);
    expect(bookmark.url,
        "https://twitter.com/benwood/status/1301217548831260673/photo/1");
    expect(bookmark.title, "Twitter");
    expect(bookmark.content,
        "RT @benwood: Evolution... #Communicator to @SamsungMobile #GalaxyZFold2 \ud83d\udc49\ud83c\udffb HP OmniGo 700LX, Communicator 9000, 9110, 9210, 9500, E90, Galaxy Fold, Galaxy Z Fold2 5G ");
    expect(bookmark.timestamp.toIso8601String(), '2020-09-03T03:58:16.000Z');
    expect(bookmark.tags, isNull);
  });

  test('bookmark from json string with tags', () async {
    final bookmark = Bookmark.fromJson(json2);

    expect(bookmark, isNotNull);
    expect(bookmark.url, "http://maksimlin.com");
    expect(bookmark.tags.length, 4);
    expect(bookmark.tags.contains('this'), true);
    expect(bookmark.tags.contains('website'), true);
    expect(bookmark.tags.contains('foo'), false);
  });
}
