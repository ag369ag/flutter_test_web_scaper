import 'package:flutter/material.dart';
import 'package:test_web_scraping/model/model_manga_info.dart';
import 'package:test_web_scraping/pages/page_reader.dart';

class PageChapters extends StatelessWidget {
  final ModelMangaInfo manga;
  const PageChapters({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    Widget topPart() {
      return Expanded(
        child: Column(
          children: [
            Text(
              manga.mangaTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(manga.mangaStatus),
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
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageReader(mangaChapter: chapter),
                  ),
                ),
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

    Widget mangaPart() {
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Column(
          children: [
            topPart(),
            Expanded(child: chapterList()),
          ],
        ),
      );
    }

    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: ListenableBuilder(
        listenable: manga,
        builder: (_, _) {
          return Stack(
            children: [
              SizedBox(
                height: screenSize.height * 0.5,
                width: screenSize.width,
                child: manga.mangaImage != null
                    ? CircularProgressIndicator()
                    : Image.memory(manga.mangaImage!),
              ),
              mangaPart(),
            ],
          );
        },
      ),
    );
  }
}
