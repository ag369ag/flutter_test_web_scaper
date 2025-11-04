// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:manga/mangaPageModel.dart';

class Mangaservice extends ChangeNotifier {
  final List<Mangapagemodel> pageLink;

  Mangaservice({
    required this.pageLink
  });

}