import 'package:flutter/material.dart';
import 'package:fluttery_seekbar/fluttery_seekbar.dart';
import 'dart:math';
import 'package:mgx_clone/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
class DetailPage extends StatefulWidget {
  DetailPage({Key key, this.auth}): super(key: key);
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => new _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  double _thumbPercent = 0.4;
  String _currentUserEmail;
  @override
  initState() {
    super.initState();
    doAsyncStuff();
  }
  doAsyncStuff() async{
    var user = await FirebaseAuth.instance.currentUser();
    var email = user.email;
    setState(() {
      this._currentUserEmail=email;
    });
  }
  Widget _buildRadialSeekBar() {
    return RadialSeekBar(
      trackColor: Colors.white.withOpacity(.5),
      trackWidth: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Thông tin",
              style: TextStyle(color: Colors.black, fontFamily: "oscinebold")),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  width: 250.0,
                  height: 250.0,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF93db70).withOpacity(.6),
                            shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: _buildRadialSeekBar(),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 200.0,
                          height: 200.0,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ClipOval(
                              clipper: MClipper(),
                              child: Image.asset(
                                "assets/man.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    "$_currentUserEmail",
                    style: TextStyle(
                        color: Color(0xFF93db70),
                        fontSize: 20.0,
                        fontFamily: "oscinebold"),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
              Container(
                width: 350.0,
                height: 100,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.details,color: Color(0xFF93db70).withOpacity(0.6),size: 100,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 190.0,
                width: double.infinity,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: -25,
                      child: Container(
                        width: 50.0,
                        height: 190.0,
                        decoration: BoxDecoration(
                            color: Color(0xFF93db70).withOpacity(0.6),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0))),
                      ),
                    ),
                    Positioned(
                      right: -25,
                      child: Container(
                        width: 50.0,
                        height: 190.0,
                        decoration: BoxDecoration(
                            color: Color(0xFF93db70).withOpacity(0.6),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0))),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Về chúng tôi",
                          style: TextStyle(
                              color: Color(0xFF93db70).withOpacity(0.6),
                              fontSize: 25,
                              fontFamily: "oscinebold"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.call,color: Colors.black87,size: 25,),
                            Text('0906516712',style: TextStyle(color: Colors.black87,fontFamily: "oscinebold",fontSize: 25),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.mail,color: Colors.black87,size: 25,),
                            Text('mgxvietnam@gmail.com',style: TextStyle(color: Colors.black87,fontFamily: "oscinebold",fontSize: 25),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.phone_iphone,color: Colors.black87,size: 25,),
                            Text('3.1.1',style: TextStyle(color: Colors.black87,fontFamily: "oscinebold",fontSize: 25),),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}


class MClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: min(size.width, size.height) / 2);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}