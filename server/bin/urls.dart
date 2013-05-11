library urls;

import 'packages/route/url_pattern.dart';

final homeUrl = new UrlPattern(r'/');
final articleUrl = new UrlPattern(r'/article/(\d+)');
final allUrls = [homeUrl, articleUrl];