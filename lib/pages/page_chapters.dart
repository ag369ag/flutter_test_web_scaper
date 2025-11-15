import 'package:flutter/material.dart';
import 'package:manga/model/model_chapter_links.dart';
import 'package:manga/model/model_manga_history.dart';
import 'package:manga/model/model_manga_info.dart';
import 'package:manga/pages/page_reader.dart';
import 'package:manga/service/service_manga.dart';

class PageChapters extends StatelessWidget {
  final ServiceManga mangaService;
  final ModelMangaInfo manga;
  const PageChapters({
    super.key,
    required this.mangaService,
    required this.manga,
  });

  @override
  Widget build(BuildContext context) {
    Widget topPart() {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    manga.mangaTitle,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(manga.mangaStatus),
                ListenableBuilder(
                  listenable: mangaService,
                  builder: (_, _) {
                    String saveStatus =
                        mangaService.savedManga
                            .where((item) => item.mangaTitle == manga.mangaTitle)
                            .isEmpty
                        ? "Save"
                        : "Saved";
                    return ElevatedButton(
                      onPressed: () => mangaService.saveNewManga(manga),
                      child: Text(saveStatus),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 5),
            Text("Description: "),
            Expanded(
              child: SingleChildScrollView(
                child: Text(manga.mangaDescription ?? ""),
              ),
            ),
          ],
        ),
      );
    }

    Widget chapterList() {
      return Column(
        children: manga.chapters
            .map(
              (chapter) => GestureDetector(
                onTap: () {
                  mangaService.addMangaHistory(manga, chapter, 0);
                  chapter.getPages();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PageReader(
                        mangaChapter: chapter,
                        mangaService: mangaService,
                        manga: manga,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: Row(
                      children: [Expanded(child: Text(chapter.chapter))],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      );
    }

    Widget mangaHistory() {
      return Visibility(
        visible: manga.chapters.isNotEmpty,
        child: ListenableBuilder(
          listenable: mangaService,
          builder: (_, _) => Column(
            children: mangaService.getMangaLastHistory(manga) == null
                ? []
                : [
                    GestureDetector(
                      onTap: () {
                        ModelMangaHistory currentMangaHistory = mangaService
                            .getMangaLastHistory(manga)!;
                        ModelChapterLinks chapter = manga.chapters
                            .where(
                              (a) =>
                                  a.chapter == currentMangaHistory.lastChapter,
                            )
                            .first;
                        chapter.getPages();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageReader(
                              mangaChapter: chapter,
                              mangaService: mangaService,
                              manga: manga,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Last read: ${mangaService.getMangaLastHistory(manga)!.lastChapter}",
                              ),
                              IconButton(
                                onPressed: () =>
                                    mangaService.removeMangaHistory(manga),
                                icon: Icon(Icons.close_rounded),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
          ),
        ),
      );
    }

    Widget mangaPart() {
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Column(
          children: [
            topPart(),
            SizedBox(height: 10),
            mangaHistory(),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(child: chapterList()),
            ),
          ],
        ),
      );
    }

    Size screenSize = MediaQuery.of(context).size;
    return PopScope(
      onPopInvokedWithResult: (_, _) {
        manga.dispose();
      },
      child: Scaffold(
        body: SafeArea(
          child: ListenableBuilder(
            listenable: manga,
            builder: (_, _) {
              return Stack(
                children: [
                  SizedBox(
                    height: screenSize.height,
                    width: screenSize.width,
                    child: manga.mangaImage == null
                        ? Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          )
                        : Image.memory(
                            manga.mangaImage!,
                            fit: BoxFit.fill,
                            opacity: AlwaysStoppedAnimation(0.2),
                          ),
                  ),

                  mangaPart(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
