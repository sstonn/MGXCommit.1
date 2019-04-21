import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mgx_clone/pages/root_page.dart';
import 'package:mgx_clone/services/authentication.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({this.auth});

  final BaseAuth auth;
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/rootpage');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF1b1e44),
                  Color(0xFF2d3447),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp)),
        child: Center(
          child: Image.asset('assets/flutter-icon.png',width: 70,height: 70,),
        ),
      ),
    );
  }
}