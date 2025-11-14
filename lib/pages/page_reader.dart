import 'package:flutter/material.dart';
import 'package:manga/components/component_manga_page.dart';
import 'package:manga/model/model_chapter_links.dart';
import 'package:manga/model/model_manga_history.dart';
import 'package:manga/model/model_manga_info.dart';
import 'package:manga/service/service_manga.dart';

ScrollController _scrollController = ScrollController();

class PageReader extends StatelessWidget {
  final ServiceManga mangaService;
  final ModelChapterLinks mangaChapter;
  final ModelMangaInfo manga;
  const PageReader({
    super.key,
    required this.mangaChapter,
    required this.mangaService,
    required this.manga,
  });

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      mangaService.addMangaHistory(
        manga,
        mangaChapter,
        _scrollController.offset,
      );
    });

    mangaChapter.addListener(() {
      if (mangaChapter.pages.isEmpty) {
        return;
      }

      ModelMangaHistory? currentMangaHistory = mangaService.getMangaLastHistory(
        manga,
      );
      double scrollOffset =
          (mangaChapter.pages.isNotEmpty && currentMangaHistory != null)
          ? currentMangaHistory.offSet!
          : 0;
      Future.delayed(Duration(seconds: 2), () {
        _scrollController.animateTo(
          scrollOffset,
          duration: Duration(milliseconds: 1500),
          curve: Curves.decelerate,
        );
      });
    });

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: mangaChapter,
          builder: (_, _) {
            return mangaChapter.pages.isEmpty
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: mangaChapter.pages.map((page) {
                        return ComponentMangaPage(page: page);
                      }).toList(),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
