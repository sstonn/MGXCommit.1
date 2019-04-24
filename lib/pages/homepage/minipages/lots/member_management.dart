import 'package:flutter/material.dart';
class MemberManagePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _MemberManagePageState();
}
class _MemberManagePageState extends State<MemberManagePage>{
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  var items = List<String>();
  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }
  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if(query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if(item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFF93db70),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF93db70),
            ),
            onPressed: ()=>Navigator.pop(context)),
        title: Text('Quản Lý Thành Viên',style: TextStyle(color: Color(0xFF93db70),fontFamily: 'oscinebold'),),
      ),
      body: Container(
        child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  style: TextStyle(color: Colors.white,fontFamily: 'oscinebold'),
                  controller: editingController,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      ),
                      hintText: "Tìm kiếm thành viên",
                      hintStyle: TextStyle(color: Colors.white70,fontFamily: 'oscinebold'),
                      prefixIcon: Icon(Icons.search,color: Colors.white,),
                      ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context,index){
                        return Padding
                          (
                          padding: EdgeInsets.only(bottom: 16.0),
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
                                    size: Size.fromHeight(140.0),
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
                                            color: Colors.transparent,
                                            child: Container
                                              (
                                              decoration: BoxDecoration
                                                (
                                                  gradient: LinearGradient
                                                    (
                                                      colors: [ Colors.white, Colors.white ]
                                                  )
                                              ),
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
                                                        Text('${items[index]}', style: TextStyle(color: Colors.black87)),
                                                        Row
                                                          (
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>
                                                          [
                                                            Text('$index', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w700, fontSize: 34.0)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    /// Infos
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        /// Item image
                                        Align
                                          (
                                          alignment: Alignment.topRight,
                                          child: Padding
                                            (
                                            padding: EdgeInsets.only(right: 16.0),
                                            child: SizedBox.fromSize
                                              (
                                              size: Size.fromRadius(40),
                                              child: Material
                                                (
                                                elevation: 20.0,
                                                shadowColor: Color(0x802196F3),
                                                shape: CircleBorder(),
                                                child: Image.asset('assets/man.png'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                              /// Review
                            ],
                          ),
                        );
                      }
                  )
              )
            ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}

