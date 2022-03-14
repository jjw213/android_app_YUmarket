import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last/data/place_data.dart';
import 'package:last/mypage/setting.dart';

class AccountSetting extends StatefulWidget {
  @override
  _AccountSettingState createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  
  String currentEmail = FirebaseAuth.instance.currentUser.email;
  String currentuid = FirebaseAuth.instance.currentUser.uid;
  
  //건물 선택
  PlaceData placeData = new PlaceData();
  var _selectPlace = '사범대학';

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar (
        title: Text('계정정보',style: TextStyle(fontFamily: mySetting.font),),
      ),  
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
          .collection("User")
          .where("Email", isEqualTo: currentEmail)
          .snapshots(),
        builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

          return _buildList(context, snapshot.data.docs);
        },
      ),
    );
  }

 Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
   return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
 }

 Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  
  StateSetter _setState;
   
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Column(
      children: <Widget> [
        //이메일
        Row(
          children: <Widget> [
            Text('이메일 : ', style: TextStyle(fontSize: 20,fontFamily: mySetting.font),),
                SizedBox(width: 10,),
                Text(currentEmail, style: TextStyle(fontSize: 25,fontFamily: mySetting.font),),
              ]
          ),
          SizedBox(height: 20,),
          //이름
          Row(
          children: <Widget> [
            Text('이름 : ', style: TextStyle(fontSize: 20,fontFamily: mySetting.font),),
                SizedBox(width: 10,),
                Text(data['UserName'], style: TextStyle(fontSize: 25,fontFamily: mySetting.font),),
              ]
          ),
          SizedBox(height: 20,),
          //자주가는 건물
          Row(
            children: <Widget> [
              Text('건물 : ', style: TextStyle(fontSize: 20,fontFamily: mySetting.font),),
              SizedBox(width: 10,),
              Text(data['FavoritePlace'], style: TextStyle(fontSize: 25,fontFamily: mySetting.font),),
              SizedBox(width: 10,),
              RaisedButton(
                
                color: Colors.orange,
                child: Text('변경',style: TextStyle(fontFamily: mySetting.font),),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('제목',style: TextStyle(fontFamily: mySetting.font),),
                        content: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            _setState = setState;
                            return DropdownButton(
                              value: _selectPlace,
                              items: placeData.favoritePlace.map(
                                (value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value,style: TextStyle(fontFamily: mySetting.font),),
                                  );
                                },
                              ).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectPlace = value;
                                });
                              },
                            );
                          }
                        ),
                        actions: <Widget>[
                        FlatButton(
                          child: Text('OK',style: TextStyle(fontFamily: mySetting.font),),
                          onPressed: () {
                            FirebaseFirestore.instance
                              .collection('User')
                              .doc(currentuid)
                              .update({'FavoritePlace' :  _selectPlace });
                            Navigator.pop(context, "OK");
                          },
                        ),
                        FlatButton(
                          child: Text('Cancel',style: TextStyle(fontFamily: mySetting.font),),
                          onPressed: () {
                            Navigator.pop(context, "Cancel");
                          },
                        ),
                      ],
                    );
                  },
                );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
 
