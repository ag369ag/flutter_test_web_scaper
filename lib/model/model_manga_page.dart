import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ModelMangaPage extends ChangeNotifier {
  final String imgLink;

  ModelMangaPage({required this.imgLink});

  Uint8List? imageData;

  loadImage() async {
    try {
      var response = await http.get(Uri.parse(imgLink));
      imageData = response.bodyBytes;
      notifyListeners();
    } catch (_) {
      loadImage();
    }
  }
}
