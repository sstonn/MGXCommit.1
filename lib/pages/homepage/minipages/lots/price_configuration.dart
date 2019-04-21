import 'package:flutter/material.dart';
import 'package:mgx_clone/model/data.dart';
import 'package:mgx_clone/widget/slider/flutter_range_slider.dart';
import 'dart:math';

class PriceConfigurationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PriceConfigurationPageState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _PriceConfigurationPageState extends State<PriceConfigurationPage> {
  var bike1, bike2, bike3, car1, car2, car3, ga1, ga2, ga3, so1, so2, so3;
  var currentPage = images.length - 1.0;

  Future _configuration(int s) async {
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
                          'Cấu hình giá xe',
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
                    Icon(
                      Icons.directions_bike,
                      color: Colors.grey.shade500,
                    ),
                    new Expanded(
                      child: new Container(
                          child: new TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: new EdgeInsets.only(
                              left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                          hintText: 'Nhập giá bạn muốn cấu hình',
                          hintStyle: new TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12.0,
                            fontFamily: "oscinebold",
                          ),
                        ),
                        validator: (value) {
                        },
                        onSaved: (value) {
                        },
                      )),
                      flex: 2,
                    ),
                  ],
                ),
                Row(
                  // dialog centre
                  children: <Widget>[
                    Icon(
                      Icons.motorcycle,
                      color: Colors.grey.shade500,
                    ),
                    new Expanded(
                      child: new Container(
                          child: new TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: new EdgeInsets.only(
                              left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                          hintText: 'Nhập giá bạn muốn cấu hình xe số',
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
                    Icon(
                      Icons.directions_car,
                      color: Colors.grey.shade500,
                    ),
                    new Expanded(
                      child: new Container(
                          child: new TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: new EdgeInsets.only(
                              left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                          hintText: 'Nhập giá bạn muốn cấu hình',
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
                // dialog bottom
                Row(
                  // dialog centre
                  children: <Widget>[
                    Icon(
                      Icons.motorcycle,
                      color: Colors.grey.shade500,
                    ),
                    new Expanded(
                      child: new Container(
                          child: new TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: new EdgeInsets.only(
                              left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                          hintText: 'Nhập giá bạn muốn cấu hình xe ga',
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
                          print('$bike1');
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

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: images.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
            Color(0xFF1b1e44),
            Color(0xFF2d3447),
          ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              tileMode: TileMode.clamp)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 30.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Cấu hình giá gửi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: "oscinebold",
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  CardScrollWidget(currentPage),
                  Positioned.fill(
                    child: PageView.builder(
                      itemCount: images.length,
                      controller: controller,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return Container(
                          child: GestureDetector(
                            onTap: () {
                              print("onTap called.");
                              _configuration(index);
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;

  CardScrollWidget(this.currentPage);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var i = 0; i < images.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3.0, 6.0),
                      blurRadius: 10.0)
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(images[i], fit: BoxFit.cover),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(title[i],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                      fontFamily: "oscinebold")),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}
