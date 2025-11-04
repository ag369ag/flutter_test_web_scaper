import 'package:flutter/material.dart';
import 'package:manga/mangaService.dart';

class Mangareaderpage extends StatelessWidget {
  final Mangaservice mangaservice;
  const Mangareaderpage({super.key, required this.mangaservice});

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    return ListenableBuilder(listenable: mangaservice, builder: (_,_){
      
      return

      mangaservice.pageLink.isEmpty ?

      Center( child: CircularProgressIndicator()) :

      SizedBox(
        width: mediaSize.width,
        height: mediaSize.height,
        child: SingleChildScrollView(
          child: Column(children: mangaservice.pageLink.map(
            (page)=> 
            ListenableBuilder(listenable: page, builder: (_,_){

              return page.imageData == null ?
            SizedBox(height: mediaSize.height * 0.5, width: mediaSize.width, child: Center( child: CircularProgressIndicator(), ),) :
            Image.memory(page.imageData!);

            })
            
            
            
          ).toList(),),
        ),
      );
      

    });
  }
}