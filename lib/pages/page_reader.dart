import 'package:flutter/material.dart';
import 'package:test_web_scraping/components/component_manga_page.dart';
import 'package:test_web_scraping/model/model_chapter_links.dart';

class PageReader extends StatelessWidget {
  final ModelChapterLinks mangaChapter;
  const PageReader({super.key, required this.mangaChapter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: mangaChapter,
          builder: (_, _) {
            return mangaChapter.pages.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: mangaChapter.pages.map((page) {
                      return ComponentMangaPage(page: page);
                    }).toList(),
                  );
          },
        ),
      ),
    );
  }
}
