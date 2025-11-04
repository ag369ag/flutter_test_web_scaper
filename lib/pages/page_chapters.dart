import 'package:flutter/material.dart';
import 'package:manga/model/model_manga_info.dart';
import 'package:manga/pages/page_reader.dart';

class PageChapters extends StatelessWidget {
  final ModelMangaInfo manga;
  const PageChapters({super.key, required this.manga});

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
                onTap: () {
                  chapter.getPages();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PageReader(mangaChapter: chapter),
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

    Widget mangaPart() {
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Column(
          children: [
            topPart(),
            SizedBox(height: 10,),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(child: chapterList()),
            ),
          ],
        ),
      );
    }

    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
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
    );
  }
}
