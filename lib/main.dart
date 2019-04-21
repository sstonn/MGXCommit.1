import 'package:flutter/material.dart';
import 'package:mgx_clone/services/authentication.dart';
import 'package:mgx_clone/pages/splashscreen.dart';
import 'package:mgx_clone/pages/root_page.dart';
void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter login demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SplashScreen(auth: new Auth()),
      routes: <String, WidgetBuilder>{
        '/rootpage': (BuildContext context) => new RootPage(auth: new Auth(),),
      },
    );
  }
}
