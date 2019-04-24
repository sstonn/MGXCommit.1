import 'package:flutter/material.dart';
import 'package:mgx_clone/services/authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mgx_clone/model/Item.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:mgx_clone/pages/detail_page.dart';
import 'package:mgx_clone/pages/homepage/minipages/revenuedetailpage/revenue_detail.dart';
import 'package:mgx_clone/model/parkingLots.dart';
class MyAnalysPage extends StatefulWidget {
  MyAnalysPage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _MyAnalysPageState();
}

class _MyAnalysPageState extends State<MyAnalysPage> {
  final List<List<double>> charts = [
    [
      300000,400000,600000,250000,300000,400000,500000
    ]
  ];
  static final List<String> chartDropdownItems = [
    'Trong tuần'
  ];
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;
  StreamSubscription<Event> _onTodoRemovedSubscription;
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Item> items = List();
  List<Lots> lotslist=new List();
  Item item;
  Lots lots;
  DatabaseReference itemRef;
  DateTime selectedDateStart,selectedDateEnd,selectedDate;
  TimeOfDay selectedTime;
  bool selected;
  @override
  void initState() {
    super.initState();
    selected=false;
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    Query _lotsQuery = database.reference()
        .child("parkinglots")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onTodoAddedSubscription = _lotsQuery.onChildAdded.listen(_onEntryAdded);
    _onTodoChangedSubscription =
        _lotsQuery.onChildChanged.listen(_onEntryChanged);
    _onTodoRemovedSubscription =
        _lotsQuery.onChildRemoved.listen(_onEntryRemoved);
  }

  _onEntryAdded(Event event) {
    setState(() {
      lotslist.add(Lots.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = lotslist.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      lotslist[lotslist.indexOf(old)] = Lots.fromSnapshot(event.snapshot);
    });
  }
  _onEntryRemoved(Event event) {
    setState(() {
      lotslist.remove(Lots.fromSnapshot(event.snapshot));
    });
  }
  void handleSubmit() {
    final FormState form = formKey.currentState;

    if (form.validate()) {
      form.save();
      form.reset();
      itemRef.push().set(item.toJson());
    }
  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    _onTodoRemovedSubscription.cancel();
    super.dispose();
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  _showDateStartPicker() async{
    selectedDate= await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1900),
      lastDate: new DateTime(3000),
    );
    setState(() {
      selectedDateStart=selectedDate;
    });
  }
  _showDateEndPicker() async{
    selectedDate= await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1900),
      lastDate: new DateTime(3000),
    );
    setState(() {
      selectedDateEnd=selectedDate;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFF93db70),
                Color(0xFF93db70),
          ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              tileMode: TileMode.clamp)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage()));
              }),
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
        body: StaggeredGridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
            children: <Widget>[
              Text(
                "Thống kê chi tiết",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: "oscinebold",
                ),
              ),
              _buildTile(
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed:(){
                                _showDateStartPicker();
                              },
                              child: (selectedDateStart==null)?
                              Text(new DateFormat('dd/MMMM/yyyy').format(new DateTime.now())):
                              Text(new DateFormat('dd/MMMM/yyyy').format(selectedDateStart)),
                            ),
                            Icon(Icons.keyboard_arrow_down,color: Colors.black,),
                            FlatButton(
                              onPressed:(){
                                _showDateEndPicker();
                              },
                              child: (selectedDateEnd==null)?
                              Text('Chọn ngày tháng kết thúc',style: TextStyle(color: Colors.black),):
                              Text(new DateFormat('dd/MMMM/yyyy').format(selectedDateEnd)),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
              RaisedButton(
                  color: Colors.white,
                  child: Text('Xác nhận',style: TextStyle(fontFamily: "oscinebold",
                      fontWeight: FontWeight.w400,
                      fontSize: 25.0,
                      color: Colors.black),),
                  onPressed: (){
                  }
              ),
              Text(
                'Chọn bãi muốn tra cứu',
                style: TextStyle(
                    fontFamily: "oscinebold",
                    fontWeight: FontWeight.w400,
                    fontSize: 25.0,
                    color: Colors.white),
              ),
              StaggeredGridView.countBuilder(
                crossAxisCount: 1,
                itemCount: lotslist.length,
                itemBuilder: (context, index) {
                  String key=lotslist[index].key;
                  String name=lotslist[index].lotsName;
                  String address=lotslist[index].address;
                  return _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                                color: Color(0xFF93db70),
                                shape: CircleBorder(),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(Icons.local_parking,
                                      color: Colors.white, size: 30.0),
                                )),
                            Padding(padding: EdgeInsets.only(left: 20.0)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('$name',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "oscinebold",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15)),
                                Text('$address',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "oscine",
                                        fontSize: 12)),
                              ],
                            )
                          ]),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>RevenueDetailPage(title: name,)));
                    }
                  );
                },
                staggeredTileBuilder: (int index) =>
                new StaggeredTile.fit(1),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
            ],
            staggeredTiles: [
              StaggeredTile.extent(2, 35.0),
              StaggeredTile.extent(2, 170),
              StaggeredTile.extent(4,50),
              StaggeredTile.extent(2,35),
              StaggeredTile.extent(4,200),

            ]),
        ),
    );
  }
  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        color: Colors.white,
        child: InkWell(
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
              print('Not set yet');
            },
            child: child));
  }
}
