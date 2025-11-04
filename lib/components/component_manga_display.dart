import 'package:flutter/material.dart';
import 'package:manga/model/model_manga_info.dart';

class ComponentMangaDisplay extends StatelessWidget {
  final ModelMangaInfo manga;
  final Size screenSize;
  const ComponentMangaDisplay({
    super.key,
    required this.manga,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: 185,
        height: 230,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListenableBuilder(
              listenable: manga,
              builder: (_, _) => SizedBox(
                height: 150,
                width: 165,
                child: manga.mangaImage == null
                    ? Center(child: CircularProgressIndicator())
                    : Image.memory(manga.mangaImage!, fit: BoxFit.fill),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    manga.mangaTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            Text(manga.mangaStatus),
            // Expanded(
            //   child: ListTile(
            //     title: Text(manga.mangaTitle, maxLines: 2,overflow: TextOverflow.ellipsis,),
            //     subtitle: Text(manga.mangaStatus),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
