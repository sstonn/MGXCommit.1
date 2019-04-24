import 'package:flutter/material.dart';
import 'package:mgx_clone/services/authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:mgx_clone/model/parkingLots.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:mgx_clone/pages/homepage/minipages/lots/price_configuration.dart';
import 'package:mgx_clone/pages/homepage/minipages/lots/member_management.dart';
import 'package:mgx_clone/pages/detail_page.dart';

class MyParkingPlacePage extends StatefulWidget {
  MyParkingPlacePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _MyParkingPlacePageState();
}

enum Answers { PRICE, MEMBER,EDIT }

class _MyParkingPlacePageState extends State<MyParkingPlacePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Color accentColor = Colors.redAccent;
  List<Lots> lotsList;
  Lots lots;
  DatabaseReference lotsRef;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;
  StreamSubscription<Event> _onTodoRemovedSubscription;
  String mname;
  String maddress;
  String mkey;
  Query _lotsQuery;
  final _textEditingController = TextEditingController();
  final _textEditingController1 = TextEditingController();
  final _textEditingController2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    lotsList = new List();
    //Rather then just writing FirebaseDatabase(), get the instance.
    _lotsQuery = database
        .reference()
        .child("parkinglots")
        .orderByChild("userId")
        .equalTo(widget.userId);
    ;
    _onTodoAddedSubscription = _lotsQuery.onChildAdded.listen(_onEntryAdded);
    _onTodoChangedSubscription =
        _lotsQuery.onChildChanged.listen(_onEntryChanged);
    _onTodoRemovedSubscription =
        _lotsQuery.onChildRemoved.listen(_onEntryRemoved);
  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    _onTodoRemovedSubscription.cancel();
    super.dispose();
  }

  _onEntryChanged(Event event) {
    var oldEntry = lotsList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      lotsList[lotsList.indexOf(oldEntry)] = Lots.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      lotsList.add(Lots.fromSnapshot(event.snapshot));
    });
  }

  _onEntryRemoved(Event event) {
    setState(() {
      lotsList.remove(Lots.fromSnapshot(event.snapshot));
    });
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  _addNewPLots(
      String lotsItemName, String lotsItemAddress, String lotItemDescription) {
    if (lotsItemName.length > 0) {
      Lots lots = new Lots(lotsItemName.toString(), widget.userId,
          lotsItemAddress.toString(), lotItemDescription.toString());
      database.reference().child("parkinglots").push().set(lots.toJson());
    }
  }

  _updatePlots(String lotsItemName, String lotsItemAddress, String key,
      String lotsItemDescription) {
    Lots lots = new Lots(
        lotsItemName, widget.userId, lotsItemAddress, lotsItemDescription);
    database.reference().child("parkinglots").child(key.toString()).update({
      "address": "" + lots.address,
      "lotsName": "" + lots.lotsName,
      "userId": "" + lots.userId,
      "description": "" + lots.description,
    });
  }

  _deleteTodo(String lotsId, int index) {
    database.reference().child("parkinglots").child(lotsId).remove().then((_) {
      print("Delete $lotsId successful");
      setState(() {
        lotsList.removeAt(index);
      });
    });
  }

  Widget _buildTitle() {
    return Text(
      "Home",
      style: TextStyle(
          fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold),
    );
  }

  Text _buildText(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCardsList() {
    if (lotsList.length > 0) {
      return ListView.builder(
        itemCount: lotsList.length,
        itemBuilder: (context, index) {
          String lotsId = lotsList[index].key;
          String name = lotsList[index].lotsName;
          String address = lotsList[index].address;
          String description=lotsList[index].description;
          String userId = lotsList[index].userId;
          var lotsElement = lotsList.elementAt(index);
          return GestureDetector(
            onTap: () {
              _configuration(lotsList[index].lotsName,
                  lotsList[index].address,
                  lotsList[index].description,
                  lotsList[index].key);
            },
            onLongPress: (){
              _deleteconfiguration(lotsId, index);
            },
            child: Container(
              width: 120,
              height: 90,
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              margin: EdgeInsets.only(left: 32, right: 32, top: 2, bottom: 2),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 15)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'oscinebold'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                      ),
                      Text(
                        address,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'oscine'),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'oscine'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Bạn chưa thêm bãi xe nào, nhấn nút '+' để thêm mới",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontFamily: 'oscinebold', color: Colors.white),
          ),
        ),
      );
    }
  }

  Widget _buildAdd() {
    return IconButton(
      icon: Icon(
        Icons.add,
        color: Color(0xFF93db70),
        size: 30.0,
      ),
      onPressed: () {
        _addconfiguration();
      },
    );
  }

  Future _addconfiguration() async {
    await showDialog(
        context: context,
        child: AlertDialog(
          content: new Container(
            width: 260.0,
            height: 230.0,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(100)),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // dialog top
                new Expanded(
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        // padding: new EdgeInsets.all(10.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                        ),
                        child: new Text(
                          'Thêm bãi xe',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontFamily: "oscinebold",
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  // dialog centre
                  children: <Widget>[
                    Text('Tên bãi',style: TextStyle(color: Colors.black87,
                      fontSize: 12.0,
                      fontFamily: "oscinebold",),),
                    new Expanded(
                      child: new Container(
                          child: new TextField(
                        controller: _textEditingController,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: new EdgeInsets.only(
                              left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                          hintText: 'Nhập tên bãi',
                          hintStyle: new TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12.0,
                            fontFamily: "oscinebold",
                          ),
                        ),
                      )),
                      flex: 2,
                    ),
                  ],
                ),
                Row(
                  // dialog centre
                  children: <Widget>[
                    Text('Địa chỉ',style: TextStyle(color: Colors.black87,
                      fontSize: 12.0,
                      fontFamily: "oscinebold",),),
                    new Expanded(
                      child: new Container(
                          child: new TextField(
                        controller: _textEditingController1,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: new EdgeInsets.only(
                              left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                          hintText: 'Nhập địa chỉ',
                          hintStyle: new TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12.0,
                            fontFamily: "oscinebold",
                          ),
                        ),
                      )),
                      flex: 2,
                    ),
                  ],
                ),
                Row(
                  // dialog centre

                  children: <Widget>[
                    Text('Miêu tả',style: TextStyle(color: Colors.black87,
                      fontSize: 12.0,
                      fontFamily: "oscinebold",),),
                    new Expanded(
                      child: new Container(
                          child: new TextField(
                        controller: _textEditingController2,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: new EdgeInsets.only(
                              left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                          hintText: 'Nhập miêu tả',
                          hintStyle: new TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12.0,
                            fontFamily: "oscinebold",
                          ),
                        ),
                      )),
                      flex: 2,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          _addNewPLots(
                              _textEditingController.text.toString(),
                              _textEditingController1.text.toString(),
                              _textEditingController2.text.toString());
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Lưu lại',
                          style: TextStyle(
                              fontFamily: 'oscinebold', color: Colors.green),
                        )),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Hủy bỏ',
                          style: TextStyle(
                              fontFamily: 'oscinebold',
                              color: Colors.redAccent),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Future _updateconfiguration(mname, maddress, mdescription, mkey) async {
    await showDialog(
        context: context,
        child: AlertDialog(
          content: new Container(
            width: 260.0,
            height: 230.0,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(100)),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // dialog top
                new Expanded(
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        // padding: new EdgeInsets.all(10.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                        ),
                        child: new Text(
                          'Sửa bãi xe',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontFamily: "oscinebold",
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  // dialog centre
                  children: <Widget>[
                    Text('Tên bãi',style: TextStyle(color: Colors.black87,
                      fontSize: 12.0,
                      fontFamily: "oscinebold",),),
                    new Expanded(
                      child: new Container(
                          child: new TextField(
                            controller: _textEditingController,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              filled: false,
                              contentPadding: new EdgeInsets.only(
                                  left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                              hintText: 'Nhập tên bãi',
                              hintStyle: new TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12.0,
                                fontFamily: "oscinebold",
                              ),
                            ),
                          )),
                      flex: 2,
                    ),
                  ],
                ),
                Row(
                  // dialog centre
                  children: <Widget>[
                    Text('Địa chỉ',style: TextStyle(color: Colors.black87,
                      fontSize: 12.0,
                      fontFamily: "oscinebold",),),
                    new Expanded(
                      child: new Container(
                          child: new TextField(
                            controller: _textEditingController1,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              filled: false,
                              contentPadding: new EdgeInsets.only(
                                  left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                              hintText: 'Nhập địa chỉ',
                              hintStyle: new TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12.0,
                                fontFamily: "oscinebold",
                              ),
                            ),
                          )),
                      flex: 2,
                    ),
                  ],
                ),
                Row(
                  // dialog centre
                  children: <Widget>[
                    Text('Miêu tả',style: TextStyle(color: Colors.black87,
                      fontSize: 12.0,
                      fontFamily: "oscinebold",),),
                    new Expanded(
                      child: new Container(
                          child: new TextField(
                            controller: _textEditingController2,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              filled: false,
                              contentPadding: new EdgeInsets.only(
                                  left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                              hintText: 'Nhập miêu tả',
                              hintStyle: new TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12.0,
                                fontFamily: "oscinebold",
                              ),
                            ),
                          )),
                      flex: 2,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          mname = _textEditingController.text.toString();
                          maddress = _textEditingController1.text.toString();
                          mdescription =
                              _textEditingController2.text.toString();
                          _updatePlots(mname, maddress, mkey, mdescription);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Lưu lại',
                          style: TextStyle(
                              fontFamily: 'oscinebold', color: Colors.green),
                        )),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Hủy bỏ',
                          style: TextStyle(
                              fontFamily: 'oscinebold',
                              color: Colors.redAccent),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
  Future _deleteconfiguration(lotsId,index) async {
    await showDialog(
        context: context,
        child: AlertDialog(
          content: new Container(
            width: 260.0,
            height: 100,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(100)),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        // padding: new EdgeInsets.all(10.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                        ),
                        child: new Text(
                          'Bạn có chắc chắc muốn xóa?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontFamily: "oscinebold",
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          _deleteTodo(lotsId, index);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Có',
                          style: TextStyle(
                              fontFamily: 'oscinebold', color: Colors.green),
                        )),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Hủy bỏ',
                          style: TextStyle(
                              fontFamily: 'oscinebold',
                              color: Colors.redAccent),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
  Future _configuration(mname,maddress,mdescription,mkey) async {
    switch (await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text("Thông tin bãi xe"),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Text("Cấu hình giá"),
              onPressed: () {
                Navigator.pop(context, Answers.PRICE);
              },
            ),
            new SimpleDialogOption(
              child: new Text("Quản lý thành viên"),
              onPressed: () {
                Navigator.pop(context, Answers.MEMBER);
              },
            ),
            new SimpleDialogOption(
              child: new Text("Sửa bãi xe"),
              onPressed: () {
                Navigator.pop(context, Answers.EDIT);
              },
            ),
          ],
        ))) {
      case Answers.PRICE:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PriceConfigurationPage()));
        break;
      case Answers.MEMBER:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MemberManagePage()));
        break;
      case Answers.EDIT:
        _updateconfiguration(mname, maddress, mdescription, mkey);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF93db70),
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.contact_phone,
              color: Color(0xFF93db70),
              size: 30.0,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DetailPage()));
            }),
        title: _buildAdd(),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                FontAwesomeIcons.signOutAlt,
                color: Color(0xFF93db70),
                size: 30.0,
              ),
              onPressed: () {
                _signOut();
              }),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 16),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildCardsList(),
            ),
          ],
        ),
      ),
    );
  }
}
