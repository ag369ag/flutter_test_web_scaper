import 'package:flutter/material.dart';
import 'package:manga/model/model_manga_info.dart';

class ComponentSavedMangaDisplay extends StatelessWidget {
  final ModelMangaInfo manga;
  final VoidCallback removeMangaFunction;
  const ComponentSavedMangaDisplay({super.key, required this.manga, required this.removeMangaFunction});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.memory(manga.mangaImage!, height: 100, width: 80),
            SizedBox(width: 5,),
            Expanded(
              child: Text(
                manga.mangaTitle,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 3,
              ),
            ),
            SizedBox(width: 5,),
            IconButton(onPressed: removeMangaFunction, icon: Icon(Icons.close_rounded))
          ],
        ),
      ),
    );
  }
}
