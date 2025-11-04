import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:manga/model/model_manga_page.dart';

class ModelChapterLinks extends ChangeNotifier {
  final String chapter;
  final String link;

  ModelChapterLinks({required this.chapter, required this.link});

  final List<ModelMangaPage> _pages = [];
  List<ModelMangaPage> get pages => _pages;

  getPages() async {
    try {
      _pages.clear();
      notifyListeners();

      var chapterResponse = await http.get(Uri.parse(link));
      dom.Document chapterValue = htmlparser.parse(chapterResponse.body);
      dom.Element mangaReaderPart = chapterValue.getElementsByClassName(
        "slideshow-container",
      )[0];

      for (var imagePart in mangaReaderPart.getElementsByClassName(
        "image_orientation",
      )) {
        ModelMangaPage mmp = ModelMangaPage(
          imgLink: imagePart
              .getElementsByClassName("mySlides fade")[0]
              .getElementsByTagName("img")[0]
              .attributes["src"]
              .toString(),
        );

        _pages.add(mmp);
        notifyListeners();
      }

      for (var page in _pages) {
        page.loadImage();
      }
    } catch (_) {
      getPages();
    }
  }
}
