import 'package:flutter/material.dart';
import 'package:test_web_scraping/model/model_manga_page.dart';

class ComponentMangaPage extends StatelessWidget {
  final ModelMangaPage page;
  const ComponentMangaPage({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ListenableBuilder(
      listenable: page,
      builder: (_, _) {
        return page.imageData != null
            ? Image.memory(page.imageData!)
            : SizedBox(
                height: 300,
                width: screenSize.width,
                child: Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
      },
    );
  }
}
