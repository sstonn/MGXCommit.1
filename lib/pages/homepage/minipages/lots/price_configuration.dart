import 'package:flutter/material.dart';
import 'package:mgx_clone/services/authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mgx_clone/pages/homepage/minipages/parkinglotsAdd/lots_add.dart';
import 'package:mgx_clone/pages/detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
class PriceConfigurationPage extends StatefulWidget{

  @override
  _PriceConfigurationPageState createState() => _PriceConfigurationPageState();
}

class _PriceConfigurationPageState extends State<PriceConfigurationPage>
{
  List<String> buoi=['buổi sáng','buổi chiều','qua đêm'];
  String _userId = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
        backgroundColor: Color(0xFF93db70),
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF93db70),
                size: 30.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  FontAwesomeIcons.save,
                  color: Color(0xFF93db70),
                  size: 30.0,
                ),
                onPressed: () {
                }),
          ],
        ),
        body: ListView.builder(
            itemCount: buoi.length,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            itemBuilder: (context,index){
              String name=buoi[index];
              return Padding
                (
                padding: EdgeInsets.only(bottom: 16.0,left: 30,right: 30),
                child: Stack
                  (
                  children: <Widget>
                  [
                    /// Item card
                    Align
                      (
                      alignment: Alignment.topCenter,
                      child: SizedBox.fromSize
                        (
                          size: Size.fromHeight(285),
                          child: Stack
                            (
                            fit: StackFit.expand,
                            children: <Widget>
                            [
                              /// Item description inside a material
                              Container
                                (
                                margin: EdgeInsets.only(top: 24.0),
                                child: Material
                                  (
                                  elevation: 14.0,
                                  borderRadius: BorderRadius.circular(12.0),
                                  shadowColor: Color(0x802196F3),
                                  color: Colors.white,
                                  child: InkWell
                                    (
                                    onTap: () {

                                    },
                                    child: Padding
                                      (
                                      padding: EdgeInsets.all(24.0),
                                      child: Column
                                        (
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>
                                        [
                                          /// Title and rating
                                          Column
                                            (
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>
                                            [
                                              Text('Cấu hình giá '+name, style: TextStyle(color: Colors.black,fontFamily: 'oscinebold',fontSize: 15)),
                                              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                                              Text('Giá xe đạp', style: TextStyle(color: Colors.black, fontFamily: 'oscine', fontSize: 12)),
                                              TextField(
                                                    autofocus: true,
                                                    keyboardType: TextInputType.text,
                                                    decoration: new InputDecoration(
                                                      border: InputBorder.none,
                                                      filled: false,
                                                      contentPadding: new EdgeInsets.only(
                                                          left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                                                      hintText: 'Nhập giá xe đạp',
                                                      hintStyle: new TextStyle(
                                                        color: Colors.grey.shade500,
                                                        fontSize: 12.0,
                                                        fontFamily: "oscinebold",
                                                      ),
                                                    ),
                                                  ),
                                              Text('Giá xe số', style: TextStyle(color: Colors.black, fontFamily: 'oscine', fontSize: 12)),
                                              TextField(
                                                autofocus: true,
                                                keyboardType: TextInputType.text,
                                                decoration: new InputDecoration(
                                                  border: InputBorder.none,
                                                  filled: false,
                                                  contentPadding: new EdgeInsets.only(
                                                      left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                                                  hintText: 'Nhập giá xe số',
                                                  hintStyle: new TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize: 12.0,
                                                    fontFamily: "oscinebold",
                                                  ),
                                                ),
                                              ),
                                              Text('Giá xe ga', style: TextStyle(color: Colors.black, fontFamily: 'oscine', fontSize: 12)),
                                              TextField(
                                                autofocus: true,
                                                keyboardType: TextInputType.text,
                                                decoration: new InputDecoration(
                                                  border: InputBorder.none,
                                                  filled: false,
                                                  contentPadding: new EdgeInsets.only(
                                                      left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                                                  hintText: 'Nhập giá xe ga',
                                                  hintStyle: new TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize: 12.0,
                                                    fontFamily: "oscinebold",
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          /// Infos

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              );
            }
        )
    );
  }
}