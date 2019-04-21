import 'package:flutter/material.dart';
import 'package:mgx_clone/services/authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mgx_clone/model/Item.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:mgx_clone/pages/detail_page.dart';
import 'package:mgx_clone/pages/homepage/minipages/revenuedetailpage/revenue_detail.dart';
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
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Item> items = List();
  Item item;
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
    itemRef = database.reference().child('items');
    itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(Item.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = Item.fromSnapshot(event.snapshot);
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
            Color(0xFF2d3247),
            Color(0xFF2d3247),
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
                color: Colors.redAccent,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage()));
              }),
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
        body: StaggeredGridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                              Text('Chọn ngày tháng bắt đầu',style: TextStyle(color: Colors.black),):
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
              Text(
                'Chọn bãi muốn tra cứu',
                style: TextStyle(
                    fontFamily: "oscinebold",
                    fontWeight: FontWeight.w400,
                    fontSize: 25.0,
                    color: Colors.white),
              ),
              StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Material(
                                color: selected==true?Colors.green:Colors.redAccent,
                                shape: CircleBorder(),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(Icons.local_parking,
                                      color: Colors.white, size: 30.0),
                                )),
                            Padding(padding: EdgeInsets.only(bottom: 16.0)),
                          ]),
                    ),
                    onTap: (){
                      setState(() {
                        if(selected==false) {
                          selected = true;
                        }else{
                          selected=false;
                        }
                      });
                    }
                  );
                },
                staggeredTileBuilder: (int index) =>
                new StaggeredTile.fit(1),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
              RaisedButton(
                  child: Text('Xác nhận',style: TextStyle(fontFamily: "oscinebold",
                      fontWeight: FontWeight.w400,
                      fontSize: 25.0,
                      color: Colors.white),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>RevenueDetailPage()));
                  }
              ),
            ],
            staggeredTiles: [
              StaggeredTile.extent(2, 35.0),
              StaggeredTile.extent(2, 200),
              StaggeredTile.extent(4,35),
              StaggeredTile.extent(4,600),
              StaggeredTile.extent(2,50),
            ]),
        ),
    );
  }
  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
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
