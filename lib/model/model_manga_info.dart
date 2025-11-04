import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:manga/model/model_chapter_links.dart';

class ModelMangaInfo extends ChangeNotifier {
  final String mangaImageLink;
  final String mangaTitle;
  final String mangaStatus;
  final String mangaLink;

  ModelMangaInfo({
    required this.mangaImageLink,
    required this.mangaTitle,
    required this.mangaStatus,
    required this.mangaLink,
  });

  Uint8List? _mangaImage;
  Uint8List? get mangaImage => _mangaImage;
  String? _mangaDescription;
  String? get mangaDescription => _mangaDescription;

  final List<ModelChapterLinks> _chapters = [];
  List<ModelChapterLinks> get chapters => _chapters;

  getMangaImage() async {
    try {
      // var response = await http.get(Uri.parse(mangaImageLink));

      // print(response.bodyBytes);
      // _mangaImage = response.bodyBytes;

      var mangaClickedResponse = await http.get(Uri.parse(mangaLink));
      dom.Document mangaInfo = htmlparser.parse(mangaClickedResponse.body);

      for (dom.Element meta in mangaInfo.getElementsByTagName("meta")) {
        if (meta.attributes["property"] == "og:image") {
          var response = await http.get(
            Uri.parse(meta.attributes["content"].toString()),
          );
          _mangaImage = response.bodyBytes;
          notifyListeners();
          break;
        }
      }
    } catch (_) {
      getMangaImage();
    }
  }

  mangaClicked() async {
    try {
      _chapters.clear();
      notifyListeners();

      var mangaClickedResponse = await http.get(Uri.parse(mangaLink));
      dom.Document mangaInfo = htmlparser.parse(mangaClickedResponse.body);

      _mangaDescription = mangaInfo
          .getElementsByClassName("manga_series_description")[0]
          .getElementsByTagName("p")[0]
          .text
          .trim();

      notifyListeners();

      dom.Element mangaSeriesList = mangaInfo.getElementsByClassName(
        "manga_series_list",
      )[0];

      for (var chapter in mangaSeriesList.getElementsByTagName("tr")) {
        if (chapter.getElementsByTagName("td").isEmpty) {
          continue;
        }

        _chapters.add(
          ModelChapterLinks(
            chapter: chapter.getElementsByTagName("td")[0].text,
            link:
                "http://mangafreak.me${chapter.getElementsByTagName("td")[0].getElementsByTagName("a")[0].attributes["href"]}",
          ),
        );

        notifyListeners();
      }
    } catch (_) {
      mangaClicked();
    }
  }
}
