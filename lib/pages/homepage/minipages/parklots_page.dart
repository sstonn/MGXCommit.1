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

enum Answers { PRICE, MEMBER }

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

  _addNewPLots(String lotsItemName, String lotsItemAddress) {
    if (lotsItemName.length > 0) {
      Lots lots = new Lots(
          lotsItemName.toString(), widget.userId, lotsItemAddress.toString());
      database.reference().child("parkinglots").push().set(lots.toJson());
    }
  }

  _updatePlots(String lotsItemName, String lotsItemAddress, String key) {
    Lots lots = new Lots(lotsItemName, widget.userId, lotsItemAddress);
    database.reference().child("parkinglots").child(key.toString()).update({
      "address": "" + lots.address,
      "lotsName": "" + lots.lotsName,
      "userId": "" + lots.userId,
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

  IconButton _buildButton(IconData icon) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  Widget _buildBottomCardChildren() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[_buildText("All"), Spacer(), _buildText("Done")],
        ),
        Container(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildButton(Icons.radio_button_checked),
            _buildButton(Icons.home),
            _buildButton(Icons.settings),
          ],
        )
      ],
    );
  }

  Widget _buildBottomCard(double width, double height) {
    return Container(
      width: width,
      height: height / 3,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16), topLeft: Radius.circular(16))),
      child: _buildBottomCardChildren(),
    );
  }

  _showDialogUpdate(BuildContext context, mname, maddress, mkey) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Column(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Tên bãi gửi',
                  ),
                )),
                new Expanded(
                    child: new TextField(
                  controller: _textEditingController1,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Địa chỉ',
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new IconButton(
                  icon: Icon(Icons.save_alt),
                  onPressed: () {
                    mname = _textEditingController.text.toString();
                    maddress = _textEditingController1.text.toString();
                    _updatePlots(mname, maddress, mkey);
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Widget _buildCardsList() {
    if (lotsList.length > 0) {
      return ListView.builder(
        itemCount: lotsList.length,
        itemBuilder: (context, index) {
          String lotsId = lotsList[index].key;
          String name = lotsList[index].lotsName;
          String address = lotsList[index].address;
          String userId = lotsList[index].userId;
          var lotsElement = lotsList.elementAt(index);
          return Container(
            width: 120,
            height: 200,
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            margin: EdgeInsets.only(left: 32, right: 32, top: 2, bottom: 2),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)]),
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
                    Text(
                      address,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'oscinebold'),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        _configuration();
                      },
                      icon: Icon(
                        Icons.info,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _showDialogUpdate(context, lotsList[index].lotsName,
                            lotsList[index].address, lotsList[index].key);
                      },
                      icon: Icon(
                        Icons.update,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _deleteTodo(lotsId, index);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      );
    } else {
      return Center(
          child: Text(
        "Bạn chưa thêm bãi xe nào, nhấn nút '+' để thêm mới",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20, fontFamily: 'oscinebold', color: Colors.white),
      ));
    }
  }

  Widget _buildAdd() {
    return IconButton(
      icon: Icon(
        Icons.add,
        color: Colors.redAccent,
        size: 30.0,
      ),
      onPressed: () {
        _showDialog(context);
      },
    );
  }

  _showDialog(BuildContext context) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Column(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Tên bãi gửi',
                  ),
                )),
                new Expanded(
                    child: new TextField(
                  controller: _textEditingController1,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Địa chỉ',
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new IconButton(
                  icon: Icon(Icons.save_alt),
                  onPressed: () {
                    _addNewPLots(_textEditingController.text.toString(),
                        _textEditingController1.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Future _configuration() async {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF2d3247),
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.contact_phone,
              color: Colors.redAccent,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage()));
            }),
        title: _buildAdd(),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                FontAwesomeIcons.signOutAlt,
                color: Colors.redAccent,
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
