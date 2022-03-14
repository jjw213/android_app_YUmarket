import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:last/data/login_toggle.dart';
import 'package:last/mypage/MyPage.dart';
import 'package:last/post/create.dart';
import 'package:last/screen/find_near_by_screen.dart';
import 'package:last/screen/login_screen.dart';
import 'package:last/screen/home_screen.dart';
import 'package:last/widget/bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:last/chat/chat_list.dart';
import 'package:last/mypage/setting.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash(),
    );
  }
}
class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SharedPreferences _prefs;
  String _font = 'NanumGothic';
  List<String> _category_order=['1차','2차','3차'];
  bool _inform = true;
  @override
  void initState(){
    super.initState();
    _loadSetting();
  }
  _loadSetting() async{
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _font= _prefs.getString('font')??'NanumGothic';
      _inform=_prefs.getBool('inform')??true;
      mySetting = new Setting(_font,_inform);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.data == null) { //로그인이 안된 상태
            return ChangeNotifierProvider<LoginToggle>.value(
              value: LoginToggle(),
              child: LogInPage(),
            );
          }
          else {
            return Scaffold(
              body: DefaultTabController(
                length: 5,
                child: Scaffold(
                  body: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      TopPage(),    //홈 이동
                      FindNearByPage(),//FindNearByPage(),//내 주변
                      CreatePage(),  //post 페이지
                      ChatListScreen(currentUserId: FirebaseAuth.instance.currentUser.uid),    //채팅
                      MyPage(),    //회원정보
                    ],
                  ),
                  bottomNavigationBar: BottomBar(),//widget 폴더속 bottom_bar.dart
                ),
              ),
            );
          }
        }
    );
  }
}