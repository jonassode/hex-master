import "dart:io";
import "dart:json";
import "urls.dart";

import 'packages/route/server.dart';
import 'packages/route/pattern.dart';



void main() {
  HttpServer.bind('127.0.0.1', 8889).then((server) {
    var router = new Router(server)
    ..serve(articleUrl).listen(serveArticle)
    ..serve(homeUrl).listen(serveDefault);
  });

}


serveArticle(HttpRequest req) {
  var articleId = articleUrl.parse(req.uri.path)[0];
  print(articleId);
  req.response.close();
}


serveDefault(HttpRequest req) {
  req.response.write("hello");
  req.response.close();
}