import 'package:flutter/material.dart';
import 'package:test_web_scraping/model/model_manga_info.dart';

class ComponentMangaDisplay extends StatelessWidget {
  final ModelMangaInfo manga;
  const ComponentMangaDisplay({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 150,
        height: 200,
        child: Column(
          children: [
            ListenableBuilder(
              listenable: manga,
              builder: (_,_) => SizedBox(
                height: 130,
                width: 130,
                child: manga.mangaImage == null
                    ? Center(child: CircularProgressIndicator())
                    : Image.memory(manga.mangaImage!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
