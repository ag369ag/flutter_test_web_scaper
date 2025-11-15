
import 'package:flutter/material.dart';

class ModelMangaHistory extends ChangeNotifier {
  final String mangaTitle;
  String? lastChapter;
  double? offSet;
  ModelMangaHistory({required this.mangaTitle, this.lastChapter, this.offSet});

  //ModelChapterLinks? get lastChapter => _chapter;

  setChapter(String chapter){
    lastChapter = chapter;
    notifyListeners();
  }

  factory ModelMangaHistory.fromJson(Map<String, dynamic> json){
    print(json);
    //var decodedJson = jsonDecode(json);
    return ModelMangaHistory(mangaTitle: json['manga'].toString(),
     lastChapter: json['lastChapter'].toString(), offSet: double.parse(json['offSet'].toString()));
  }

  Map<String, dynamic> toJson(){
    return {
      "manga" : mangaTitle,
      "lastChapter" : lastChapter,
      "offSet" : offSet
    };
  }

}