import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
class RevenueDetailPage extends StatefulWidget {
  RevenueDetailPage({Key key,this.title}): super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => new _RevenueDetailPageState();
}
class _RevenueDetailPageState extends State<RevenueDetailPage> {
  List<String> xe = [
      'Xe đạp','Xe số','Xe ga'
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFF2d3247),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.redAccent,),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        title: Text('Xem doanh thu bãi',style: TextStyle(color: Colors.redAccent,fontFamily: "oscinebold"),),
      ),
      body: ListView.builder(
          itemCount: xe.length,
          itemBuilder: (context,index){
            String name=xe[index];
            return Container(
              margin:const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
              child:_buildTile(
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(bottom: 16.0)),
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
                            ]),
                        Padding(padding: EdgeInsets.only(left: 120.0)),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text('100K',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "oscinebold",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24.0)),
                            ]),
                      ]),
                ),
              ),
            );
          }
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