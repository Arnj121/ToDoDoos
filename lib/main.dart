import 'package:flutter/material.dart';
import 'package:todo/home.dart';
import 'package:todo/categories.dart';
import 'package:todo/catview.dart';
void main(){runApp(MyApp());}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light
      ),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
          brightness: Brightness.dark
      ),
      initialRoute: '/home',
      routes: {
        '/home':(context)=>Home(),
        '/categories':(context)=>Categories(),
        '/catview':(context)=>CatView()
      },
    );
  }
}
