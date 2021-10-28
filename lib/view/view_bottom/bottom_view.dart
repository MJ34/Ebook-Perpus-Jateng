import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ebook_account.dart';
import 'ebook_favorite.dart';
import 'ebook_library.dart';
import 'ebook_news.dart';
import 'home.dart';

class BottomView extends StatefulWidget {

  @override
  _BottomViewState createState() => _BottomViewState();
}

class _BottomViewState extends State<BottomView> {

  int currentIndex = 0;
  List<Widget> items = [
    Home(),
    EbookLibrary(),
    EbookNews(),
    EbookFavorite(),
    EbookAccount()
  ];

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     home: Scaffold(
       bottomNavigationBar: BottomNavigationBar(
         onTap: onTapPage,
         type: BottomNavigationBarType.fixed,
         currentIndex: currentIndex,
         items: const [
           BottomNavigationBarItem(
               icon: Icon(Icons.home),
               label: 'Home'
           ),
           BottomNavigationBarItem(
               icon: Icon(Icons.my_library_books_rounded),
               label: 'Library'
           ),
           BottomNavigationBarItem(
               icon: Icon(Icons.article_rounded),
               label: 'Berita'
           ),
           BottomNavigationBarItem(
               icon: Icon(Icons.bookmark_border),
               label: 'Favorite'
           ),
           BottomNavigationBarItem(
               icon: Icon(Icons.account_circle_outlined),
               label: 'Profile'
           )
         ],
       ),
       body: items[currentIndex],
     ),
   );
  }

  void onTapPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}