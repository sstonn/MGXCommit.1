import 'package:flutter/material.dart';
import 'package:mgx_clone/services/authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mgx_clone/pages/detail_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(
                            auth: widget.auth,
                          )));
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
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8.0),
          children: <Widget>[
            Text(
              'Doanh thu tổng',
              style: TextStyle(
                  fontFamily: "oscinebold",
                  fontWeight: FontWeight.w400,
                  fontSize: 25.0,
                  color: Colors.white),
            ),
            _buildTile(
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
                          Text('Tổng doanh thu hôm nay',
                              style: TextStyle(
                                  color: Color(0xFF93db70),
                                  fontFamily: "oscinebold")),
                          Text('400K',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontFamily: "oscinebold"))
                        ],
                      ),
                      Material(
                          color: Color(0xFF93db70),
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(Icons.timeline,
                                color: Colors.white, size: 30.0),
                          )))
                    ]),
              ),
            ),
            Text(
              'Doanh thu theo từng bãi',
              style: TextStyle(
                  fontFamily: "oscinebold",
                  fontWeight: FontWeight.w400,
                  fontSize: 25.0,
                  color: Colors.white),
            ),
            StaggeredGridView.countBuilder(
              crossAxisCount: 1,
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _buildTile(
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
                                Text('Tên bãi',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "oscinebold",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15)),
                                Text('Miêu tả',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "oscine",
                                        fontSize: 12)),
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
                );
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 35.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 35.0),
            StaggeredTile.extent(4, 600),
          ]),
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
