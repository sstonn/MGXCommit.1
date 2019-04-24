import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:mgx_clone/model/parkingLots.dart';
import 'package:mgx_clone/services/authentication.dart';
class MyLotsAddPage extends StatefulWidget {
  MyLotsAddPage({Key key, this.userId})
      : super(key: key);
  final String userId;
  @override
  State<StatefulWidget> createState() => new _MyLotsAddPageState();
}

class _MyLotsAddPageState extends State<MyLotsAddPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Lots lots;
  List<Lots> lotsList=new List();
  DatabaseReference lotsRef;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;
  StreamSubscription<Event> _onTodoRemovedSubscription;
  Query _lotsQuery;
  bool isAdded;
  @override
  void initState() {
    isAdded=false;
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    _lotsQuery = database
        .reference()
        .child("parkinglots")
        .orderByChild("userId")
        .equalTo(widget.userId);
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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFF93db70),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Color(0xFF93db70),),
            onPressed: ()=>Navigator.pop(context),
        ),
        title: Text(
          'Danh sách bãi hiện có',
          style: TextStyle(fontFamily: 'oscinebold', color: Color(0xFF93db70)),
        ),
      ),
      body: ListView.builder(
          itemCount: lotsList.length,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          itemBuilder: (context, index) {
            String key=lotsList[index].key;
            String name=lotsList[index].lotsName;
            String address=lotsList[index].address;
            String description=lotsList[index].description;
            return Container(
              margin: EdgeInsets.only(top: 24.0),
              child: _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('$name',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: "oscinebold")),
                            Text('$address',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: "oscine")),
                            Text('$description',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontFamily: "oscine"))
                          ],
                        ),
                        Material(
                            color: isAdded==true?Color(0xFF93db70):Colors.redAccent,
                            borderRadius: BorderRadius.circular(24.0),
                            child: Container(
                                child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(Icons.local_parking,
                                  color: Colors.white, size: 30.0),
                            )))
                      ]),
                ),
                onTap: (){
                  setState(() {
                    isAdded=!isAdded;
                  });
                }
              ),
            );
          }),
    );
  }
  Future _configurationAdd() async {
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
                // dialog top
                Text(
                    'Bạn có chắc muốn gán nhân viên vào bãi này'
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            isAdded=true;
                          });
                          Navigator.pop(context);
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
  Future _configurationRemoved() async {
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
                // dialog top
                Text(
                    'Bạn có chắc muốn bỏ nhân viên khỏi bãi này'
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            isAdded=false;
                          });
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
  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap:(){
              isAdded==true?_configurationRemoved():_configurationAdd();
            },
            child: child));
  }
}
