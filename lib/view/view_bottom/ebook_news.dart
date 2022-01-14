import 'package:flutter/material.dart';

class EbookNews extends StatefulWidget {
  const EbookNews({Key? key}) : super(key: key);


  @override
  _EbookNewsState createState() => _EbookNewsState();
}

class _EbookNewsState extends State<EbookNews> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Coming Soon',
          style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
