library linkcheck.uri_glob;

import 'package:glob/glob.dart';
import 'package:path/path.dart';

class UriGlob {
  static final _urlContext = new Context(style: Style.url);

  /// Matches the 'authority' portion of the URI, e.g. localhost:4000.
  final String authority;

  /// Matches everything that comes after host.
  final Glob _glob;

  factory UriGlob(String glob) {
    var uri = Uri.parse(glob);
    var authority = uri.authority;
    if (authority.endsWith('**')) {
      authority = authority.substring(0, authority.length - 2);
    }

    var path = uri.path;
    if (path.isEmpty) path = "/**";

    return new UriGlob._(
        authority, new Glob(path, context: _urlContext, caseSensitive: true));
  }

  UriGlob._(this.authority, this._glob);

  bool matches(Uri uri) {
    if (uri.authority != authority) return false;
    var path = uri.path;
    // Fix http://example.com into http://example.com/.
    if (path.isEmpty) path = "/";
    return _glob.matches(path);
  }
}
