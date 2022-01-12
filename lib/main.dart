// @dart=2.9
import 'package:ebook/view/login/login.dart';
import 'package:ebook/widget/theme_ebook.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(ChangeNotifierProvider<ThemeEbook>(
    create: (_)=>ThemeEbook(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType){
        return MaterialApp(
          //remove banner
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Login(),
        );
      }
    );
  }
}
