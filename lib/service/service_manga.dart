import 'package:flutter/material.dart';
import 'package:manga/model/model_manga_info.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;

class ServiceManga extends ChangeNotifier {
  final List<ModelMangaInfo> _mangaListInfo = [];
  List<ModelMangaInfo> get mangaListInfo => _mangaListInfo;

  int _pageNumber = 1;
  int get pageNumber => _pageNumber;

  bool _showMenu = false;
  bool get showMenu => _showMenu;

  String _searchedTitle = "";
  String get searchedTitle => _searchedTitle;

  updateMenuState() {
    _showMenu = !_showMenu;
    notifyListeners();
  }

  nextPageClicked() {
    if(_searchedTitle != ""){
      return;
    }
    _pageNumber++;
    notifyListeners();
    getMangaList();
  }

  backPageClicked() {
    if(_searchedTitle != ""){
      return;
    }
    
    if (_pageNumber == 1) {
      return;
    }

    _pageNumber--;
    notifyListeners();
    getMangaList();
  }

  searchManga(String title) {
    _pageNumber = 1;
    _searchedTitle = title;
    notifyListeners();
    getMangaList();
  }

  removeSearchedTitle() {
    _searchedTitle = "";
    notifyListeners();
    getMangaList();
  }

  getMangaList() async {
    try {
      _mangaListInfo.clear();
      notifyListeners();

      String link = "https://ww2.mangafreak.me/Mangalist/All/$_pageNumber";

      if (_searchedTitle != "") {
        link = "https://ww2.mangafreak.me/Find/$_searchedTitle";
      }

      var response = await http.get(Uri.parse(link));

      dom.Document parsedBody = htmlparser.parse(response.body);

      if (_searchedTitle != "") {
        for (var item in parsedBody.getElementsByClassName(
          "manga_search_item",
        )) {
          String mangaLink = item
              .getElementsByTagName("a")[0]
              .attributes["href"]
              .toString();
          String mangaImageLink = item
              .getElementsByTagName("img")[0]
              .attributes["src"]
              .toString();
          String mangaTitle = item
              .getElementsByTagName("h3")[0]
              .getElementsByTagName("a")[0]
              .text;
          _mangaListInfo.add(
            ModelMangaInfo(
              mangaImageLink: mangaImageLink,
              mangaTitle: mangaTitle,
              mangaStatus: "",
              mangaLink: "http://mangafreak.me${mangaLink}",
            ),
          );
          notifyListeners();
        }
        for (var manga in _mangaListInfo) {
          manga.getMangaImage();
        }
        return;
      }

      for (var item in parsedBody.getElementsByClassName("list_item")) {
        dom.Element image = item.getElementsByClassName("list_image")[0];
        dom.Element a = image.getElementsByTagName("a")[0];

        String mangaLink =
            "http://mangafreak.me${a.attributes["href"].toString()}";
        String mangaImageLink = a
            .getElementsByTagName("img")[0]
            .attributes["src"]
            .toString();

        dom.Element titleDiv = item.getElementsByClassName("list_item_info")[0];
        String mangaTitle = titleDiv.getElementsByTagName("a")[0].text;
        String mangaStatus = titleDiv
            .getElementsByTagName("div")[0]
            .text
            .split("\n")[2]
            .trim();

        _mangaListInfo.add(
          ModelMangaInfo(
            mangaImageLink: mangaImageLink,
            mangaTitle: mangaTitle,
            mangaStatus: mangaStatus,
            mangaLink: mangaLink,
          ),
        );
        notifyListeners();
      }

      for (var manga in _mangaListInfo) {
        manga.getMangaImage();
      }
    } catch (_) {
      getMangaList();
    }
  }
}
