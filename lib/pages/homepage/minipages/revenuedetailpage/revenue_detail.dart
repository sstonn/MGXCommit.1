import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
class RevenueDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RevenueDetailPageState();
}
class _RevenueDetailPageState extends State<RevenueDetailPage> {
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
        title: Text('Xem doanh thu từng bãi',style: TextStyle(color: Colors.redAccent,fontFamily: "oscinebold"),),
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context,index){
            return Container(
              margin:const EdgeInsets.all(24.0),
              child:_buildTile(
              Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Doanh thu theo thời gian',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontFamily: "oscinebold")),
                            ],
                          ),
                          DropdownButton(
                              isDense: true,
                              value: actualDropdown,
                              onChanged: (String value) => setState(() {
                                actualDropdown = value;
                                actualChart = chartDropdownItems
                                    .indexOf(value); // Refresh the chart
                              }),
                              items: chartDropdownItems.map((String title) {
                                return DropdownMenuItem(
                                  value: title,
                                  child: Text(title,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                          fontFamily: "oscinebold")),
                                );
                              }).toList())
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 4.0)),
                      Sparkline(
                        data: charts[actualChart],
                        lineWidth: 5.0,
                        pointsMode: PointsMode.all,
                        pointSize: 8.0,
                        pointColor: Colors.redAccent,
                        lineColor: Colors.greenAccent,
                      )
                    ],
                  )),
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