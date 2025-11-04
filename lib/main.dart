import 'package:flutter/material.dart';
import 'package:manga/components/component_custom_textfield.dart';
import 'package:manga/components/component_floating_button.dart';
import 'package:manga/components/component_manga_display.dart';
import 'package:manga/pages/page_chapters.dart';
import 'package:manga/service/service_manga.dart';
// import 'package:html/dom.dart' as dom;
// import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' as parser;
// import 'package:test_web_scraping/mangaChapterLinks.dart';
// import 'package:test_web_scraping/mangaPageModel.dart';
// import 'package:test_web_scraping/mangaReaderPage.dart';
// import 'package:test_web_scraping/mangaService.dart';

ServiceManga mangaService = ServiceManga();
TextEditingController searchFieldController = TextEditingController();
late Size _screenSize;

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
    return Scaffold(body: MainPage());
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    mangaService.getMangaList();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListenableBuilder(
            listenable: mangaService,
            builder: (_, _) => Column(
              children: [
                Visibility(
                  visible: mangaService.searchedTitle != "",
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Searched: ${mangaService.searchedTitle}"),
                          IconButton(
                            onPressed: () => mangaService.removeSearchedTitle(),
                            icon: Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: mangaService.mangaListInfo.isNotEmpty
                          ? mangaService.mangaListInfo
                                .map(
                                  (manga) => GestureDetector(
                                    onTap: () {
                                      manga.mangaClicked();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PageChapters(manga: manga),
                                        ),
                                      );
                                    },
                                    child: ComponentMangaDisplay(manga: manga),
                                  ),
                                )
                                .toList()
                          : [
                              Container(
                                width: _screenSize.width - 10,
                                height: _screenSize.height - 10,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              ),
                            ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ListenableBuilder(
        listenable: mangaService,
        builder: (_, _) => Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ComponentFloatingButton(
              buttonFunction: () => mangaService.backPageClicked(),
              isVisible: mangaService.showMenu,
              buttonIcon: Icons.arrow_left_rounded,
            ),
            SizedBox(width: 10),
            ComponentFloatingButton(
              buttonFunction: () => mangaService.nextPageClicked(),
              isVisible: mangaService.showMenu,
              buttonIcon: Icons.arrow_right_rounded,
            ),
            SizedBox(width: 10),
            ComponentFloatingButton(
              buttonFunction: () => showSearchDialog(context),
              isVisible: mangaService.showMenu,
              buttonIcon: Icons.search,
            ),
            SizedBox(width: 10),
            ComponentFloatingButton(
              buttonFunction: () => mangaService.updateMenuState(),
              isVisible: true,
              buttonIcon: mangaService.showMenu
                  ? Icons.keyboard_arrow_right_rounded
                  : Icons.keyboard_arrow_left_rounded,
            ),
          ],
        ),
      ),
    );
  }

  showSearchDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      useSafeArea: true,
      context: context,
      builder: (context) {
        searchFieldController.clear();
        return Dialog(
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded),
                  ),
                ],
              ),
              Container(
                width: 400,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Search", style: TextStyle(fontSize: 20)),
                    SizedBox(height: 5),
                    ComponentCustomTextfield(
                      fieldController: searchFieldController,
                      label: "Title",
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                        mangaService.searchManga(searchFieldController.text);
                      },
                      child: Text("Search"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// class TestPage extends StatelessWidget {
//   const TestPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ElevatedButton(
//         onPressed: () async {
//           var response = await http.get(
//             Uri.parse("https://ww2.mangafreak.me/Mangalist"),
//           );
//           dom.Document parsedBody = parser.parse(response.body);

//           String mangaImageLink = "";
//           String mangaTitle = "";
//           String mangaStatus = "";
//           String mangaLink = "";

//           for (var item in parsedBody.getElementsByClassName("list_item")) {
//             dom.Element image = item.getElementsByClassName("list_image")[0];
//             dom.Element a = image.getElementsByTagName("a")[0];
//             mangaLink =
//                 "http://mangafreak.me${a.attributes["href"].toString()}";
//             mangaImageLink = a
//                 .getElementsByTagName("img")[0]
//                 .attributes["src"]
//                 .toString();

//             dom.Element titleDiv = item.getElementsByClassName(
//               "list_item_info",
//             )[0];
//             mangaTitle = titleDiv.getElementsByTagName("a")[0].text;
//             mangaStatus = titleDiv
//                 .getElementsByTagName("div")[0]
//                 .text
//                 .split("\n")[2]
//                 .trim();

           
//           }

//           print(mangaImageLink);
//           print(mangaTitle);
//           print(mangaStatus);
//           print(mangaLink);
//           print("**************************************");

//           var mangaClickedResponse = await http.get(Uri.parse(mangaLink));
//           dom.Document mangaInfo = parser.parse(mangaClickedResponse.body);

//           String mangaDescription = mangaInfo
//               .getElementsByClassName("manga_series_description")[0]
//               .getElementsByTagName("p")[0]
//               .text
//               .trim();
//           print(mangaDescription);

//           List<Mangachapterlinks> chapters = [];

//           dom.Element mangaSeriesList = mangaInfo.getElementsByClassName(
//             "manga_series_list",
//           )[0];
//           for (var chapter in mangaSeriesList.getElementsByTagName("tr")) {
//             if (chapter.getElementsByTagName("td").isNotEmpty) {
             
//               chapters.add(
//                 Mangachapterlinks(
//                   chapter: chapter.getElementsByTagName("td")[0].text,
//                   link: "http://mangafreak.me${chapter
//                     .getElementsByTagName("td")[0]
//                     .getElementsByTagName("a")[0]
//                     .attributes["href"]}",
//                 ),
//               );
             
//             }
//           }

//           List<Mangapagemodel> mangaPageList = [];

//           var chapterResponse = await http.get(Uri.parse(chapters.last.link));
//           dom.Document chapterValue = parser.parse(chapterResponse.body);
//           dom.Element mangaReaderPart = chapterValue.getElementsByClassName("slideshow-container")[0];
//           for(var imagePart in mangaReaderPart.getElementsByClassName("image_orientation")){
//             print(imagePart.getElementsByClassName("mySlides fade")[0].getElementsByTagName("img")[0].attributes["src"]);
            
//             Mangapagemodel mpm = Mangapagemodel(imgLink: imagePart.getElementsByClassName("mySlides fade")[0].getElementsByTagName("img")[0].attributes["src"].toString());
            
//             mangaPageList.add(mpm);
//             mpm.loadImage();
//           }

//           Mangaservice ms = Mangaservice(pageLink: mangaPageList);
//           Navigator.push(context, MaterialPageRoute(builder: (context)=>Mangareaderpage(mangaservice: ms)));

//         },
//         child: Text("TEST"),
//       ),
//     );
//   }
// }
