import 'package:flutter/material.dart';
import 'package:last/post/auction.dart';
import 'package:last/post/rental.dart';
import 'package:last/post/sell.dart';
import 'package:last/mypage/setting.dart';


class TopPage extends StatefulWidget {
  @override
  _TopPageState createState() => _TopPageState();
  //TopPage({Key key, email}) : super(key: key);
}

class _TopPageState extends State<TopPage> {
  
  //String _email = LogInPage;
  final choices = ['판매', '대여', '경매'];

  @override
  Widget build(BuildContext context) {
    //상단 탭 
    return Scaffold(
      body: DefaultTabController(
          length: choices.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text('YU마켓',style: TextStyle(fontFamily: mySetting.font),), //프로필 나타낼곳
              backgroundColor: Colors.blue,
              bottom: TabBar(
                tabs: choices.map((String choice) {
                  return Tab(text: choice);
                }).toList(),
              ),
            ),
            //상단 탭 페이지 이동
            body: TabBarView(
              children: <Widget>[
                SellPage(),    //판매 물품 출력 페이지로 변경
                RentalPage(), //대여 물품 출력 페이지로 변경
                AuctionPage(),  //경매 물품 출력 페이지로 변경
              ],
            ),
          ),
        ),
      
      //검색 버튼
      /*floatingActionButton: FloatingActionButton(
        onPressed: () { Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) {
          return SearchPage(); // 검색 페이지로 변경
          }));
        },
        tooltip: 'search',
        child: Icon(Icons.search),
      ), */
    );
  }
}