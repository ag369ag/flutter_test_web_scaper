import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Mangapagemodel extends ChangeNotifier {
  final String imgLink;

  Mangapagemodel({
    required this.imgLink
  });

  Uint8List? imageData;

  
  loadImage()async{
    var response = await http.get(Uri.parse(imgLink));
    imageData = response.bodyBytes;
    notifyListeners();
  }
}