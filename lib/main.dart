import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:test_web_scraping/mangaChapterLinks.dart';
import 'package:test_web_scraping/mangaPageModel.dart';
import 'package:test_web_scraping/mangaReaderPage.dart';
import 'package:test_web_scraping/mangaService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainScaffold());
  }
}

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TestPage());
  }
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          var response = await http.get(
            Uri.parse("https://ww2.mangafreak.me/Mangalist"),
          );
          dom.Document parsedBody = parser.parse(response.body);

          String mangaImageLink = "";
          String mangaTitle = "";
          String mangaStatus = "";
          String mangaLink = "";

          for (var item in parsedBody.getElementsByClassName("list_item")) {
            dom.Element image = item.getElementsByClassName("list_image")[0];
            dom.Element a = image.getElementsByTagName("a")[0];
            mangaLink =
                "http://mangafreak.me${a.attributes["href"].toString()}";
            mangaImageLink = a
                .getElementsByTagName("img")[0]
                .attributes["src"]
                .toString();

            dom.Element titleDiv = item.getElementsByClassName(
              "list_item_info",
            )[0];
            mangaTitle = titleDiv.getElementsByTagName("a")[0].text;
            mangaStatus = titleDiv
                .getElementsByTagName("div")[0]
                .text
                .split("\n")[2]
                .trim();

            // dom.Element title = item.getElementsByTagName("h3")[0];
            // dom.Element titleH3 = title.getElementsByTagName("a")[0];

            // List<dom.Element> description = item.getElementsByTagName("p");

            // mangaTitle = titleH3.text.trim();
            // mangaLink = image.attributes["href"].toString();

            // if(description.isNotEmpty){
            //   if(description[0].text.contains("\n")){
            //     mangaDescription = description[0].text.split("\n")[2].trimLeft();
            //   }else{
            //     mangaDescription = description[0].text;
            //   }
            // }
          }

          print(mangaImageLink);
          print(mangaTitle);
          print(mangaStatus);
          print(mangaLink);
          print("**************************************");

          var mangaClickedResponse = await http.get(Uri.parse(mangaLink));
          dom.Document mangaInfo = parser.parse(mangaClickedResponse.body);

          String mangaDescription = mangaInfo
              .getElementsByClassName("manga_series_description")[0]
              .getElementsByTagName("p")[0]
              .text
              .trim();
          print(mangaDescription);

          List<Mangachapterlinks> chapters = [];

          dom.Element mangaSeriesList = mangaInfo.getElementsByClassName(
            "manga_series_list",
          )[0];
          for (var chapter in mangaSeriesList.getElementsByTagName("tr")) {
            if (chapter.getElementsByTagName("td").isNotEmpty) {
             
              chapters.add(
                Mangachapterlinks(
                  chapter: chapter.getElementsByTagName("td")[0].text,
                  link: "http://mangafreak.me${chapter
                    .getElementsByTagName("td")[0]
                    .getElementsByTagName("a")[0]
                    .attributes["href"]}",
                ),
              );
             
            }
          }

          List<Mangapagemodel> mangaPageList = [];

          var chapterResponse = await http.get(Uri.parse(chapters.last.link));
          dom.Document chapterValue = parser.parse(chapterResponse.body);
          dom.Element mangaReaderPart = chapterValue.getElementsByClassName("slideshow-container")[0];
          for(var imagePart in mangaReaderPart.getElementsByClassName("image_orientation")){
            print(imagePart.getElementsByClassName("mySlides fade")[0].getElementsByTagName("img")[0].attributes["src"]);
            
            Mangapagemodel mpm = Mangapagemodel(imgLink: imagePart.getElementsByClassName("mySlides fade")[0].getElementsByTagName("img")[0].attributes["src"].toString());
            
            mangaPageList.add(mpm);
            mpm.loadImage();
          }

          Mangaservice ms = Mangaservice(pageLink: mangaPageList);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Mangareaderpage(mangaservice: ms)));

        },
        child: Text("TEST"),
      ),
    );
  }
}
