import 'package:flutter/material.dart';
import 'package:manga/model/model_manga_info.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class ComponentMangaDisplay extends StatelessWidget {
  final ModelMangaInfo manga;
  final double containerWidth;
  const ComponentMangaDisplay({
    super.key,
    required this.manga,
    required this.containerWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(10),
        width: containerWidth,
        height: containerWidth * 1.24324,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListenableBuilder(
              listenable: manga,
              builder: (_, _) => SizedBox(
                height: ((containerWidth - 20 ) * 0.97) ,
                width: containerWidth - 20,
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

