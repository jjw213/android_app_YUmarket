import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:last/post/search.dart';
import 'package:last/post/print.dart';
import 'package:last/mypage/setting.dart';

_SellPageState pageState;

class SellPage extends StatefulWidget {
  final place;
  SellPage({key, @required this.place}):super(key: key);

  _SellPageState createState() => _SellPageState(places: place);
}

class _SellPageState extends State<SellPage> {

  final String places;
  _SellPageState({Key key, @required this.places});

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // 컬렉션명
  final String Post = "Post";
  String DocumentID='';
  // 필드명
  final String Title = "Title";
  final String Contents = "Contents";
  final String WriteDate = "WriteDate";
  final int Price=0;

  TextEditingController _undNameCon = TextEditingController();
  TextEditingController _undDescCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      body: ListView(
        children: <Widget>[
          Container(
            height: 500,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(Post)
                  .where('Place', isEqualTo: places)    //건물 마커선택값
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text("Loading...",style: TextStyle(fontFamily: mySetting.font),);
                  default:
                    return ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        Timestamp ts = document[WriteDate];
                        String dt = timestampToStrDateTime(ts);
                        if(document['CategoryOne']==0&&document['Process']==0) { //판매인 경우만 출력하도록
                          return Card(
                            elevation: 2,
                            child: InkWell(
                              // Read Document
                              onTap: () {
                                showDocument(document.documentID); //짧게 터치하면 아래 스낵바 뜸
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                    children: <Widget>[
                                      Image.network(document['ImgPath'],
                                        width: 60,
                                        height: 60,),

                                      SizedBox(width: 15,),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            document[Title],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,fontFamily: mySetting.font
                                            ),
                                          ),

                                          Row(mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                document['Place'],
                                                style: TextStyle(color: Colors.black54,fontFamily: mySetting.font),
                                              ),
                                              Text(' - ',style: TextStyle(fontFamily: mySetting.font),),
                                              Text(
                                                dt.toString().substring(0,10),
                                                style:
                                                TextStyle(color: Colors.grey[600],fontFamily: mySetting.font),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            //alignment: Alignment.centerLeft,
                                            child: Text(
                                              document['Price'].toString()+'원',
                                              style: TextStyle(color: Colors.blueGrey,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,fontFamily: mySetting.font),

                                            ),
                                          ),
                                          // Container(
                                          //   alignment: Alignment.centerLeft,
                                          //   child: Text(
                                          //     document['Price'],
                                          //     style: TextStyle(color: Colors.black54),
                                          //   ),)
                                        ],
                                      ),
                                    ]),
                              ),
                            ),
                          );
                        }
                        else{
                          return Container();
                        }
                      }).toList(),
                    );
                }
              },
            ),
          )
        ],
      ),
      // Create Document
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => SearchPage()));
        },
        tooltip: "검색하려면 클릭하세요",
        label: Text('검색',style: TextStyle(fontFamily: mySetting.font),),
        icon: Icon(Icons.search),
      ),
    );
  }

  /// Firestore CRUD Logic


  // 문서 조회 (Read)
  void showDocument(String documentID) {
    Firestore.instance
        .collection(Post)
        .document(documentID)
        .get()
        .then((doc) {
      showReadDocSnackBar(doc);
      DocumentID=documentID;
    });
  }



  void showReadDocSnackBar(DocumentSnapshot doc) {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.deepOrangeAccent,
          duration: Duration(seconds: 5),
          content: Text(
            "$Title: ${doc[Title]}\n$Contents: ${doc[Contents]}"
                "\n$WriteDate: ${timestampToStrDateTime(doc[WriteDate])}",style: TextStyle(fontFamily: mySetting.font),),
          action: SnackBarAction(
            label: "거래신청",
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PrintPage(DocumentID:doc.documentID, selleruid: doc['SellerUID'],)));},
          ),
        ),
      );
  }

  String timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }
}